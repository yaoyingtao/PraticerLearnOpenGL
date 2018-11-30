//
//  ViewController.m
//  OpneGLES-01
//
//  Created by yaoyingtao on 2018/11/9.
//  Copyright © 2018 yaoyingtao. All rights reserved.
//

#import "ViewController.h"
#import "PERGLView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    PERGLView *glView = [[PERGLView alloc] initWithFrame:CGRectMake(0, 150, width, width)];
    [self.view addSubview:glView];
}


@end
