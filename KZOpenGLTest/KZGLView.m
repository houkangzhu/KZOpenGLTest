//
//  KZGLView.m
//  KZOpenGLTest
//
//  Created by HouKangzhu on 16/7/4.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import "KZGLView.h"
#import "KZGLUtils.h"
@implementation KZGLView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupAll];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self layoutSubviews];
        [self layoutIfNeeded];
        [self setupAll];
    }
    return self;
}


- (void)setupAll {
    [self setupLayer]; // 设置layer
    [self setupContext]; // 设置context
    [self setupRenderBuffer]; // 设置渲染缓冲
    [self setupFrameBuffer]; // 设置帧缓冲
    [self setupProgram];
    
    [self setupProjection];
    //        [self renderNew];
    //        [self render]; // 渲染
    [self renderCone];
    [self resetTransform];
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

///加载渲染程序
- (void)setupProgram {
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"glsl"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"glsl"];
    
    GLuint vertexShader = [KZGLUtils loadShader:GL_VERTEX_SHADER withShaderStringPath:vertexShaderPath];
    
    GLuint fragmentShader = [KZGLUtils loadShader:GL_FRAGMENT_SHADER withShaderStringPath:fragmentShaderPath];
    
    _programHandle = glCreateProgram();
    if (!_programHandle) {
        NSLog(@"Error: programHandle Field");
        return;
    }
    
    glAttachShader(_programHandle, vertexShader);
    glAttachShader(_programHandle, fragmentShader);
    
    glLinkProgram(_programHandle);
    GLint linked;
    glGetProgramiv(_programHandle, GL_LINK_STATUS, &linked);
    if (linked == GL_FALSE) {
        GLint infoLen;
        glGetProgramiv(_programHandle, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            char *infoLog = malloc(sizeof(char)*infoLen);
            glGetProgramInfoLog(_programHandle, infoLen, NULL, infoLog);
            printf("Error: link Error--> %s",infoLog);
            free(infoLog);
        }
        glDeleteProgram(_programHandle);
        _programHandle = 0;
        return;
    }
    glUseProgram(_programHandle);
    
    _positionSlot = glGetAttribLocation(_programHandle, "vPosition");
    _modelViewSlot = glGetUniformLocation(_programHandle, "modelView");
    _projectionSlot = glGetUniformLocation(_programHandle, "projection");
}

//新的渲染
- (void)renderNew {
    glClearColor(0, 1.0, 0.0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    GLfloat vertices[] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f };
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];;
}

/// 画一个 3D 物体
- (void)drawTriCone {
    GLfloat vertices[] = {
        0.5f,  0.5f,  0.0f,
        0.5f, -0.5f,  0.0f,
        -0.5f,-0.5f,  0.0f,
        -0.5f, 0.5f,  0.0f,
        0.0f, 0.0f,  -0.707f
    };
    
    GLubyte indices[] = {
        0,  1,  1,  2,  2,  3,  3,  0,
        4,  0,  4,  1,  4,  2,  4,  3,
    };
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    glDrawElements(GL_LINES, sizeof(indices)/sizeof(GLubyte), GL_UNSIGNED_BYTE, indices);

    /**
    glDrawElements(GLenum mode, GLsizei count, GLenum type, const GLvoid *indices)
     mode : 绘图元的模式 GL_POINTS, GL_LINES, GL_LINE_STRIP,  GL_LINE_LOOP,  GL_TRIANGLES,  GL_TRIANGLE_STRIP, GL_TRIANGLE_FAN ;
     count: 顶点索引的个数;
     indices: 顶点存放的数组;
     */
}

- (void)setupProjection {
    float aspect = self.frame.size.width/self.frame.size.height;
    ksMatrixLoadIdentity(&_projectionMatrix);
    ksPerspective(&_projectionMatrix, 60.0, aspect, 1.0f, 20.0f);

    glUniformMatrix4fv(_projectionSlot, 1, GL_FALSE,  (GLfloat*)&_projectionMatrix.m[0][0]);
}

- (void)updateTransform {
    
    // Generate a model view matrix to rotate/translate/scale
    //
    ksMatrixLoadIdentity(&_modelViewMatrix);
    
    // Translate away from the viewer
    //
    ksMatrixTranslate(&_modelViewMatrix, self.posX, self.posY, self.posZ);
    
    // Rotate the triangle
    //
    ksMatrixRotate(&_modelViewMatrix, self.rotateX, 1.0, 0.0, 0.0);
    
    // Scale the triangle
    ksMatrixScale(&_modelViewMatrix, 1.0, 1.0, self.scaleZ);
    
    // Load the model-view matrix
    glUniformMatrix4fv(_modelViewSlot, 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
}

- (void)resetTransform {
    _posX = 0.0;
    _posY = 0.0;
    _posZ = -5.5;
    
    _scaleZ = 1.0;
    _rotateX = 0.0;
    
    [self updateTransform];
    [self renderCone];
}

- (void)renderCone {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self drawTriCone];
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}


- (void)setPosX:(float)posX {
    _posX = posX;
    [self updateTransform];
    [self renderCone];
}

- (void)setPosY:(float)posY {
    _posY = posY;
    [self updateTransform];
    [self renderCone];
}

- (void)setPosZ:(float)posZ {
    _posZ = posZ;
    [self updateTransform];
    [self renderCone];
}

- (void)setScaleZ:(float)scaleZ {
    _scaleZ = scaleZ;
    [self updateTransform];
    [self renderCone];
}

- (void)setRotateX:(float)rotateX {
    _rotateX = rotateX;
    [self updateTransform];
    [self renderCone];
}

- (void)displayLinkCallback:(CADisplayLink *)displayLink {
    self.rotateX += displayLink.duration * 90;
}

- (void)toggleDisplayLink {
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    else {
        [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [_displayLink invalidate];
        _displayLink = nil;
    }
}
@end
