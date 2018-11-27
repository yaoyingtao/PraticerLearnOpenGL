//
//  PERShader.m
//  LearnOpenGLES
//
//  Created by yaoyingtao on 2018/11/10.
//  Copyright © 2018 loyinglin. All rights reserved.
//

#import "PERShader.h"

@interface PERShader ()
@property (nonatomic, copy) NSString *vertexUrl;
@property (nonatomic, copy) NSString *frameUrl;


@end

@implementation PERShader
#pragma mark - life circle
- (instancetype)initWithVertexName:(NSString *)vertexUrl frameName:(NSString *)frameUrl {
    self = [super init];
    if (self) {
        _vertexUrl = vertexUrl;
        _frameUrl = frameUrl;
    }
    return self;
}

- (void)compileShader {
    GLuint vertexShader = [self complieShader:self.vertexUrl WithType:GL_VERTEX_SHADER];
    GLuint frameShader = [self complieShader:self.frameUrl WithType:GL_FRAGMENT_SHADER];
    
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, frameShader);
    glLinkProgram(programHandle);

    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    self.programHandle = programHandle;
    glUseProgram(programHandle);
    glDeleteShader(vertexShader);
    glDeleteShader(frameShader);
}

- (GLuint)complieShader:(NSString *)shaderName WithType:(GLenum)shaderType {
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"error loading shader");
    }
    
    const char *shaderStringUTF8 = [shaderString UTF8String];
    int shaderLength = [shaderString length];
    GLuint shaderHandle = glCreateShader(shaderType);
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderLength);
    glCompileShader(shaderHandle);
    
    GLuint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar message[256];
        glGetShaderInfoLog(shaderHandle, sizeof(message), 0, message);
        NSString *messageString = [NSString stringWithUTF8String:message];
        NSLog(@"compile shader error:%@", messageString);
        exit(1);
    }
    return shaderHandle;
}


@end
