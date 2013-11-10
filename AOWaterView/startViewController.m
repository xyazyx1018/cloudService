//
//  mainViewController.m
//  zhangzhi
//
//  Created by chester on 13-11-5.
//  Copyright (c) 2013年 zhangzhi. All rights reserved.
//

#import "mainViewController.h"
#import "homeViewController.h"

@interface mainViewController ()

@end

@implementation mainViewController
{
    homeViewController *_homeView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    UIImage *img = [UIImage imageNamed:@"cup.jpeg"];
    backImage.image = img;
    [self.view addSubview:backImage];
    
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 250, 180, 82)];
    UIImage *logo = [UIImage imageNamed:@"logo.png"];
    logoView.image = logo;
    [backImage addSubview:logoView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
    [backImage addGestureRecognizer:singleTap];
    
    backImage.userInteractionEnabled = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)singleTapAction
{
    if(_homeView){
        
    }else{
        _homeView = [[homeViewController alloc] init];
    };
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:_homeView animated:YES];
    //[self presentViewController:_homeView animated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
