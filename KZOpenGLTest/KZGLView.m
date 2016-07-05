//
//  KZGLView.m
//  KZOpenGLTest
//
//  Created by HouKangzhu on 16/7/4.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import "KZGLView.h"
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES2/gl.h>
@implementation KZGLView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupLayer]; // 设置layer
        [self setupContext]; // 设置context
        [self setupRenderBuffer]; // 设置渲染缓冲
        [self setupFrameBuffer]; // 设置帧缓冲
        [self render]; // 渲染
    }
    return self;
}

- (void)dealloc {
    _context = nil;
}

///CAEAGLayer的特别层作为默认层
+ (Class)layerClass {
    return [CAEAGLLayer class];
}
///设置为非透明  影响性能
- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
//    //设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
//    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

///创建并设置 上下午 context
- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSAssert(1, @"context创建失败");
    }
    BOOL setOK = [EAGLContext setCurrentContext:_context];
    if (!setOK) {
        NSAssert(2, @"设置当前context失败");
    }
}

///创建渲染缓冲
- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

///创建帧缓冲
- (void)setupFrameBuffer {
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

///清除屏幕
- (void)render {
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}
@end
