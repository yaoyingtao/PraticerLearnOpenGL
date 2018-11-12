//
//  PERGLView.m
//  LearnOpenGLES
//
//  Created by yaoyingtao on 2018/11/10.
//  Copyright © 2018 loyinglin. All rights reserved.
//

#import "PERGLView.h"
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES2/gl.h>
#import "PERShader.h"


/*
 https://learnopengl-cn.github.io/01%20Getting%20started/04%20Hello%20Triangle/
 solution 使用EBO节省几点
 使用两个shader画两个三角形
 */

typedef struct {
    float Position[3];
    float Color[2];
}SceneVertex;


//SceneVertex vertices[] =
//{
//    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
//    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
//    {{0,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
//};

SceneVertex vertices[] =
{
    {{0.5f, 0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f, 0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
    {{-0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
};

const GLubyte indices[] = {
    // Front
    0, 1, 2,
};

const GLubyte yellowIndices[] = {
    // Front
    2, 3, 1,
};


@interface PERGLView ()
@property (nonatomic, strong) CAEAGLLayer *glLayer;
@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, assign) GLuint colorRenderBuffer;
@property (nonatomic, assign) GLuint indexBuffer;
@property (nonatomic, assign) GLuint yellowIndexBuffer;
@property (nonatomic, strong) PERShader *shader;
@property (nonatomic, strong) PERShader *yellowShader;
@property (nonatomic, assign) GLuint positionSlot;
@property (nonatomic, assign) GLuint yellowPositionSlot;


@end

@implementation PERGLView

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self setupShader];
        [self setupData];
        [self render:nil];
    }
    return self;
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

#pragma mark - commmon init
- (void)commonInit {
    [self setupLayer];
    [self setupContex];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
}

- (void)setupLayer {
    self.glLayer = (CAEAGLLayer *)self.layer;
    self.glLayer.opaque = YES;
}

- (void)setupContex {
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.glContext) {
        NSLog(@"glcontext crate fail");
        return;
    }
    if (![EAGLContext setCurrentContext:self.glContext]) {
        NSLog(@"glcontext set fail");
        return;
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [self.glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
}

- (void)setupFrameBuffer {
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

#pragma mark - databuffer
- (void)setupData {
    [self setupEBO];
    [self setupVBO];
}

- (void)setupVBO {
    GLuint VBO;
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

- (void)setupEBO {
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_yellowIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _yellowIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(yellowIndices), yellowIndices, GL_STATIC_DRAW);
}

#pragma mark - shader
- (void)setupShader {
    self.shader = [[PERShader alloc] initWithVertexName:@"SimpleVertex" frameName:@"SimpleFragment"];
    [self.shader compileShader];
    _positionSlot = glGetAttribLocation(self.shader.programHandle, "Position");
    glEnableVertexAttribArray(_positionSlot);
    
    self.yellowShader = [[PERShader alloc] initWithVertexName:@"SimpleVertex" frameName:@"SimpleFragmentYellow"];
    [self.yellowShader compileShader];
    _yellowPositionSlot = glGetAttribLocation(self.yellowShader.programHandle, "Position");
    glEnableVertexAttribArray(_yellowPositionSlot);
}

#pragma mark - render
- (void)render:(CADisplayLink*)displayLink {
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), 0);
    glEnableVertexAttribArray(_positionSlot);
    glUseProgram(self.shader.programHandle);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);

//    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices)/sizeof(SceneVertex));
    
    glEnableVertexAttribArray(_yellowPositionSlot);
    glUseProgram(self.yellowShader.programHandle);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _yellowIndexBuffer);
    glDrawElements(GL_TRIANGLES, sizeof(yellowIndices)/sizeof(yellowIndices[0]), GL_UNSIGNED_BYTE, 0);
    
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
}
@end
