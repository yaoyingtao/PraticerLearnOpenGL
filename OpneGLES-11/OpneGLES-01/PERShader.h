//
//  PERShader.h
//  LearnOpenGLES
//
//  Created by yaoyingtao on 2018/11/10.
//  Copyright © 2018 loyinglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>


NS_ASSUME_NONNULL_BEGIN

@interface PERShader : NSObject
- (instancetype)initWithVertexName:(NSString *)vertexUrl frameName:(NSString *)frameUrl;
- (void)compileShader;
@property (nonatomic, assign) GLuint programHandle;
@end

NS_ASSUME_NONNULL_END
