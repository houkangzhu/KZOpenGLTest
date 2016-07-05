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
}
@end
