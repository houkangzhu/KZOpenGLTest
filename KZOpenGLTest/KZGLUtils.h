//
//  KZGLUtils.h
//  KZOpenGLTest
//
//  Created by HouKangzhu on 16/7/5.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZGLUtils : NSObject

+ (GLuint)loadShader:(GLenum)type  withShaderString:(NSString *)shaderString;

+ (GLuint)loadShader:(GLenum)type withShaderStringPath:(NSString *)shaderPath;

@end
