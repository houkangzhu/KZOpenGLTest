//
//  KZGLUtils.h
//  KZOpenGLTest
//
//  Created by HouKangzhu on 16/7/5.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZGLUtils : NSObject
/**
 *  编译 Shader
 *
 *  @param type       类型
 *  @param shaderPath Shader程序的String
 *
 *  @return shader
 */
+ (GLuint)loadShader:(GLenum)type  withShaderString:(NSString *)shaderString;
/**
 *  编译 Shader
 *
 *  @param type       类型
 *  @param shaderPath 路径
 *
 *  @return shader
 */
+ (GLuint)loadShader:(GLenum)type withShaderStringPath:(NSString *)shaderPath;

@end
