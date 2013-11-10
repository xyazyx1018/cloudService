//
//  MainViewController.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "MainViewController.h"

#import "DataAccess.h"
#import "AppDelegate.h"
@interface MainViewController ()

@end

@implementation MainViewController

extern NSMutableArray *totalArr;
extern UIViewController *thisView;
extern UIImageView *currentSingleImageView;
extern int currentTag;
bool animateFlag;

@synthesize aoView;
@synthesize leftSwipeGestureRecognizer;
@synthesize rightSwipeGestureRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}
//初始化

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    thisView = self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    
    
    animateFlag = YES;
    
    
    
    
    
    
    DataAccess *dataAccess= [[DataAccess alloc]init];
    self.view.frame = CGRectMake(0, 0, 320, 568);
    //[self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paper@2x.png"]]];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320, 568)];
    UIImage *logo = [UIImage imageNamed:@"45.jpg"];
    logoView.image = logo;
    [self.view addSubview:logoView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    label.text = @"Cloud Album";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
    [self.navigationItem setTitleView:label];
    
    
    // Request
    NSString *URLPath = [NSString stringWithFormat:@"https://cloud.camera360.com/activity/picture/latest?activityId=526e399c8852d6ad68680fc3&limit=50"];
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSMutableArray *dataArray = [[res objectForKey:@"data"] objectForKey:@"list"];
                
                //NSDictionary *dic = [self getDicByPlist];
                NSMutableArray *imageList = [[NSMutableArray alloc]init];
                NSMutableArray *dicArray = dataArray;
                
                //NSLog(@"%@",dicArray);
                totalArr = [[NSMutableArray alloc] init];
                
                
                for(int i=0; i<[dicArray count]; i++){
                    DataInfo *data=[[DataInfo alloc]init];
                    NSDictionary *vdic = [dicArray objectAtIndex:i];
                    
                    NSNumber *hValue=[vdic objectForKey:@"h"];
                    
                    data.height= hValue.floatValue;
                    NSNumber *wValue=[vdic objectForKey:@"w"];
                    
                    data.width= wValue.floatValue;
                    data.tag = [totalArr count] + i;
    
                    
                    //data.url = [vdic objectForKey:@"key"];
                    //NSString *str =
                    data.url = [NSString stringWithFormat:@"http://cloud-activity.qiniudn.com/%@?imageView/2/w/200", [vdic objectForKey:@"key"]];
                    
                    data.title=[vdic objectForKey:@"nickname"];
                    data.mess=[vdic objectForKey:@"这是一张图片"];
                    [imageList addObject:data];
                    
                    
                }
                
//                for (NSDictionary *vdic in dicArray) {
//                    DataInfo *data=[[DataInfo alloc]init];
//                    NSNumber *hValue=[vdic objectForKey:@"h"];
//                    
//                    data.height= hValue.floatValue;
//                    NSNumber *wValue=[vdic objectForKey:@"w"];
//                    
//                    data.width= wValue.floatValue;
//                    //data.url = [vdic objectForKey:@"key"];
//                    //NSString *str =
//                    data.url = [NSString stringWithFormat:@"http://cloud-activity.qiniudn.com/%@?imageView/2/w/200", [vdic objectForKey:@"key"]];
//                    
//                    data.title=[vdic objectForKey:@"nickname"];
//                    data.mess=[vdic objectForKey:@"这是一张图片"];
//                    [imageList addObject:data];
//                }
                
                NSMutableArray *arr = imageList;
                totalArr = dataArray;
                
                self.aoView = [[AOWaterView alloc]initWithDataArray:arr];
                self.aoView.delegate=self;
                self.aoView.frame = CGRectMake(0, 0, 320, 567);
                self.aoView.alpha = 0.9;
                [self.view addSubview:self.aoView];
                [self createHeaderView];
                //[self setFooterView];
                [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
                
            } else {
                //[self dataSourceDidError];
            }
        } else {
            //[self dataSourceDidError];
        }
    }];
    
        // Do any additional setup after loading the view from its nib.
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"tttt");
//    int currentPostion = scrollView.contentOffset.y;
//    if (currentPostion - _lastPosition > 25) {
//        _lastPosition = currentPostion;
//        NSLog(@"ScrollUp now");
//    }
//    else if (_lastPosition - currentPostion > 25)
//    {
//        _lastPosition = currentPostion;
//        NSLog(@"ScrollDown now");
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[self.aoView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

-(void)setFooterView{
    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.aoView.contentSize.height, self.aoView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.aoView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.aoView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.aoView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark-
#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.aoView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.aoView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.aoView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.aoView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}
//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }

	// overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
    
   int currentPostion = scrollView.contentOffset.y;
   if (currentPostion - _lastPosition > 400) {
       _lastPosition = currentPostion;
       [self.navigationController setNavigationBarHidden:YES animated:YES];
   }else if (_lastPosition - currentPostion > 400)
   {
      _lastPosition = currentPostion;
       [self.navigationController setNavigationBarHidden:NO animated:YES];
   }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

//刷新调用的方法
-(void)refreshView{
    DataAccess *dataAccess= [[DataAccess alloc]init];
    
    
    NSString *URLPath = [NSString stringWithFormat:@"https://cloud.camera360.com/activity/picture/latest?activityId=526e399c8852d6ad68680fc3&limit=50"];
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSMutableArray *dataArray = [[res objectForKey:@"data"] objectForKey:@"list"];
                
                //NSDictionary *dic = [self getDicByPlist];
                NSMutableArray *imageList = [[NSMutableArray alloc]init];
                NSMutableArray *dicArray = dataArray;
                
                //NSLog(@"%@",dicArray);
                totalArr = [[NSMutableArray alloc] init];
                
                for(int i=0; i<[dicArray count]; i++){
                    DataInfo *data=[[DataInfo alloc]init];
                    NSDictionary *vdic = [dicArray objectAtIndex:i];
                    
                    NSNumber *hValue=[vdic objectForKey:@"h"];
                    
                    data.height= hValue.floatValue;
                    NSNumber *wValue=[vdic objectForKey:@"w"];
                    
                    data.width= wValue.floatValue;
                    data.tag = [totalArr count] + i;
                    
                    //data.url = [vdic objectForKey:@"key"];
                    //NSString *str =
                    data.url = [NSString stringWithFormat:@"http://cloud-activity.qiniudn.com/%@?imageView/2/w/200", [vdic objectForKey:@"key"]];
                    
                    data.title=[vdic objectForKey:@"nickname"];
                    data.mess=[vdic objectForKey:@"这是一张图片"];
                    [imageList addObject:data];
                    
                    
                }
                
                NSMutableArray *arr = imageList;
                totalArr = dataArray;
            
                [self.aoView refreshView:arr];
                [self testFinishedLoadData];
                
            } else {
                //[self dataSourceDidError];
            }
        } else {
            //[self dataSourceDidError];
        }
    }];
    

}
//加载调用的方法
-(void)getNextPageView{
    [self removeFooterView];
    DataAccess *dataAccess= [[DataAccess alloc]init];
    NSMutableArray *dataArray = [dataAccess getDateArray];
//    NSMutableArray *testData = [[NSMutableArray alloc]init];
//    for (int i=0; i<9; i++) {
//        [testData addObject:[dataArray objectAtIndex:i]];
//    }
    
    NSString *URLPath = [NSString stringWithFormat:@"https://cloud.camera360.com/activity/picture/latest?activityId=526e399c8852d6ad68680fc3&limit=50"];
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSMutableArray *dataArray = [[res objectForKey:@"data"] objectForKey:@"list"];
                
                //NSDictionary *dic = [self getDicByPlist];
                NSMutableArray *imageList = [[NSMutableArray alloc]init];
                NSMutableArray *dicArray = dataArray;
                
                //NSLog(@"%@",dicArray);
                
                for(int i=0; i<[dicArray count]; i++){
                    DataInfo *data=[[DataInfo alloc]init];
                    NSDictionary *vdic = [dicArray objectAtIndex:i];
                    
                    NSNumber *hValue=[vdic objectForKey:@"h"];
                    
                    data.height= hValue.floatValue;
                    NSNumber *wValue=[vdic objectForKey:@"w"];
                    
                    data.width= wValue.floatValue;
                    data.tag = [totalArr count] + i;
                    
                    //data.url = [vdic objectForKey:@"key"];
                    //NSString *str =
                    data.url = [NSString stringWithFormat:@"http://cloud-activity.qiniudn.com/%@?imageView/2/w/200", [vdic objectForKey:@"key"]];
                    
                    data.title=[vdic objectForKey:@"nickname"];
                    data.mess=[vdic objectForKey:@"这是一张图片"];
                    [imageList addObject:data];
                    
                    
                }
                
                NSMutableArray *arr = imageList;
                [totalArr addObjectsFromArray:dataArray];
                
                [self.aoView getNextPage:arr];
                [self testFinishedLoadData];
                
            } else {
                //[self dataSourceDidError];
            }
        } else {
            //[self dataSourceDidError];
        }
    }];
    
   
}
-(void)testFinishedLoadData{

    [self finishReloadingData];
    [self setFooterView];
}

-(void)disappear:(NSTimer *)timer
{
    //NSLog(@"fdfff");
    UIImageView *oldView = [[timer userInfo] objectForKey:@"currentSingleImageView"];
    [oldView removeFromSuperview];
    animateFlag = YES;
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {  //后退翻页
        if(currentSingleImageView && currentTag >0 && animateFlag == YES)
        {
            
            animateFlag = NO;
            currentTag = currentTag - 1;
            
            NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://cloud-activity.qiniudn.com/%@?imageView/2/w/200", [[totalArr objectAtIndex:currentTag] objectForKey:@"key"]]];
            UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
            //currentSingleImageView.image = imagea;
            UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-320, 0, 320, 568)];
            nextImageView.image= imagea;
            
            UIView *parentView = [currentSingleImageView superview];
            [parentView addSubview:nextImageView];
            
            
            [UIImageView beginAnimations:nil context:NULL];
            UIImageView.animationDuration = 0.6;
            UIImageView.animationRepeatCount = 0;
            [currentSingleImageView setFrame:CGRectMake(320, 0, 320, 568)];
            [UIImageView commitAnimations];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:currentSingleImageView forKey:@"currentSingleImageView"];
            [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(disappear:) userInfo:dict repeats:NO];
            
            
            [UIImageView beginAnimations:nil context:NULL];
            UIImageView.animationDuration = 0.6;
            UIImageView.animationRepeatCount = 0;
            [nextImageView setFrame:CGRectMake(0, 0, 320, 568)];
            [UIImageView commitAnimations];
            
            currentSingleImageView = nextImageView;
            
        }else if(currentTag == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"attention" message:@"this is the first image." delegate:self cancelButtonTitle:@"I got" otherButtonTitles:nil];
            [alert show];
        }
        //CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x - 100.0, self.swipeLabel.frame.origin.y);
        //self.swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height);
        //self.swipeLabel.text = @"尼玛的, 你在往左边跑啊....";
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) { //前进翻页
        if(currentSingleImageView && currentTag < [totalArr count] - 1 && animateFlag ==YES)
        {
            
            animateFlag = NO;
            currentTag = currentTag + 1;
            
            NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://cloud-activity.qiniudn.com/%@?imageView/2/w/200", [[totalArr objectAtIndex:currentTag] objectForKey:@"key"]]];
            UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
            //currentSingleImageView.image = imagea;
            UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 320, 568)];
            nextImageView.image= imagea;
            
            UIView *parentView = [currentSingleImageView superview];
            [parentView addSubview:nextImageView];
            
            
            [UIImageView beginAnimations:nil context:NULL];
            UIImageView.animationDuration = 0.6;
            UIImageView.animationRepeatCount = 0;
            [currentSingleImageView setFrame:CGRectMake(-320, 0, 320, 568)];
            [UIImageView commitAnimations];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:currentSingleImageView forKey:@"currentSingleImageView"];
            [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(disappear:) userInfo:dict repeats:NO];
            
            
            [UIImageView beginAnimations:nil context:NULL];
            UIImageView.animationDuration = 0.6;
            UIImageView.animationRepeatCount = 0;
            [nextImageView setFrame:CGRectMake(0, 0, 320, 568)];
            [UIImageView commitAnimations];
            
            currentSingleImageView = nextImageView;
            
            
            
        }else if(currentTag == [totalArr count] - 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"attention" message:@"this is the last image." delegate:self cancelButtonTitle:@"I got" otherButtonTitles:nil];
            [alert show];
        }
        //CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x + 100.0, self.swipeLabel.frame.origin.y);
        //self.swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height);
        //self.swipeLabel.text = @"尼玛的, 你在往右边跑啊....";
    }
}

@end
