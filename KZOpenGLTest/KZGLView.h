//
//  KZGLView.h
//  KZOpenGLTest
//
//  Created by HouKangzhu on 16/7/4.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface KZGLView : UIView {
    EAGLContext *_context;
    CAEAGLLayer *_eaglLayer;
    GLuint      _colorRenderBuffer;
    
    GLuint _programHandle;
    GLuint _positionSlot;
    GLuint _modelViewSlot;
    GLuint _projectionSlot;
    
    ksMatrix4 _modelViewMatrix;
    ksMatrix4 _projectionMatrix;
    
    CADisplayLink *_displayLink;
}

@property (nonatomic, assign) float posX;
@property (nonatomic, assign) float posY;
@property (nonatomic, assign) float posZ;


@property (nonatomic, assign) float scaleZ;
@property (nonatomic, assign) float rotateX;

- (void)resetTransform;


- (void)toggleDisplayLink;

@end
