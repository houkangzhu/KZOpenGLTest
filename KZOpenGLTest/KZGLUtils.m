//
//  KZGLUtils.m
//  KZOpenGLTest
//
//  Created by HouKangzhu on 16/7/5.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import "KZGLUtils.h"

@implementation KZGLUtils

+ (GLuint)loadShader:(GLenum)type withShaderStringPath:(NSString *)shaderPath {
    NSError *error = nil;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error: loadFiale Error");
        return 0;
    }
    return [self loadShader:type withShaderString:shaderString];
}

+ (GLuint)loadShader:(GLenum)type withShaderString:(NSString *)shaderString {
    GLuint shader = glCreateShader(type);
    if (shader == GL_FALSE) {
        NSLog(@"Error: create Shader Filed");
        return 0;
    }
    const char *shaderUTF8 = [shaderString UTF8String];
    glShaderSource(shader, 1, &shaderUTF8, NULL);
    
    glCompileShader(shader);
    
    GLint compiled = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (compiled == GL_FALSE) {
        GLint logLen = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLen);
        if (logLen > 1) {
            char *logChar = malloc(sizeof(char) * logLen);
            glGetShaderInfoLog(shader, logLen, NULL, logChar);
            printf("Error: compily Faild!");
            free(logChar);
        }
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

@end
