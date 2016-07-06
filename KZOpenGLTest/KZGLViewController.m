//
//  KZGLViewController.m
//  KZOpenGLTest
//
//  Created by HouKangzhu on 16/7/6.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import "KZGLViewController.h"
#import "KZGLView.h"

@interface KZGLViewController ()
@property (weak, nonatomic) IBOutlet KZGLView *glView;
@property (weak, nonatomic) IBOutlet UIView *ctrlView;

@property (weak, nonatomic) IBOutlet UISlider *posXslider;

@end

@implementation KZGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)XsliderVelueChanged:(UISlider *)sender {
    float currentValue = sender.value;
//    NSLog(@"--- %f", currentValue);
    
    switch (sender.tag) {
        case 10:
            self.glView.posX = currentValue;
            break;
        case 20:
            self.glView.posY = currentValue;
            break;
        case 30:
            self.glView.posZ = currentValue;
            break;
        case 40:
            self.glView.rotateX = currentValue;
            break;
        case 50:
            self.glView.scaleZ = currentValue;
            break;
        default:
            break;
    }
}

- (IBAction)autoAction:(UIButton *)sender {
    [self.glView toggleDisplayLink];
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"自动"]) {
        sender.titleLabel.text = @"停止";
    }
    else {
        sender.titleLabel.text = @"自动";
    }
}
- (IBAction)resetAction:(id)sender {
    for (UIView *subView in self.ctrlView.subviews) {
        if ([subView isKindOfClass:[UISlider class]]) {
            UISlider *slider = (UISlider *)subView;
            slider.value = (slider.maximumValue + slider.minimumValue)/2;
        }
    }
    [self.glView resetTransform];
}

@end
