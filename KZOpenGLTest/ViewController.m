//
//  ViewController.m
//  KZOpenGLTest
//
//  Created by HouKangzhu on 16/7/5.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import "ViewController.h"
#import "KZGLView.h"
@interface ViewController ()

@property (nonatomic, strong) KZGLView *glView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.glView = [[KZGLView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.glView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
