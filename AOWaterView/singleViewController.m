//
//  singleViewController.m
//  cloudService
//
//  Created by chester on 13-11-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "singleViewController.h"

@interface singleViewController ()

@end

@implementation singleViewController

extern NSMutableArray *totalArr;
extern NSInteger *currentTag;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
