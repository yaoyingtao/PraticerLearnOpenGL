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
#import "Cocos3DMathLib/ccTypes.h"
#import "Cocos3DMathLib/CC3GLMatrix.h"


/*
https://learnopengl-cn.github.io/02%20Lighting/01%20Colors/
 11-光照场景
 */

#define Size 1.0f
typedef struct {
    float Position[3];
    float Color[3];
    float Texture[2];
}SceneVertex;

SceneVertex vertices[] =
{
    {{0.5f, 0.5f, 0.5f}, {1.0, 0.0f, 0.0f}, {1.0, 1.0f}}, // lower left corner前
    {{0.5f, -0.5f, 0.5f}, {0.0f, 1.0f, 0.0f}, {1.0, 0.0f}}, // lower right corner
    {{-0.5f, -0.5f, 0.5f}, {0.0f, 0.0f, 1.0f}, {0.0, 0.0f}}, // upper left corner
    {{-0.5f, 0.5f, 0.5f}, {1.0, 0.0f, 0.0f}, {0.0, 1.0f}}, // lower right corner
    
    {{0.5f, 0.5f, -0.5}, {1.0, 0.0f, 0.0f}, {1.0, 1.0f}}, // lower left corner后
    {{0.5f, -0.5f, -0.5}, {0.0f, 1.0f, 0.0f}, {1.0, 0.0f}}, // lower right corner
    {{-0.5f, -0.5f, -0.5}, {0.0f, 0.0f, 1.0f}, {0.0, 0.0f}}, // upper left corner
    {{-0.5f, 0.5f, -0.5}, {1.0, 0.0f, 0.0f}, {0.0, 1.0f}}, // lower right corner
    
    {{0.5f, 0.5f, 0.5f}, {1.0, 0.0f, 0.0f}, {1.0, 1.0f}}, // lower left corner上
    {{0.5f, 0.5f, -0.5f}, {0.0f, 1.0f, 0.0f}, {1.0, 0.0f}}, // lower right corner
    {{-0.5f, 0.5f, -0.5f}, {0.0f, 0.0f, 1.0f}, {0.0, 0.0f}}, // upper left corner
    {{-0.5f, 0.5f, 0.5f}, {1.0, 0.0f, 0.0f}, {0.0, 1.0f}}, // lower right corner
    
    {{0.5f, -0.5f, 0.5f}, {1.0, 0.0f, 0.0f}, {1.0, 1.0f}}, // lower left corner下
    {{0.5f, -0.5f, -0.5f}, {0.0f, 1.0f, 0.0f}, {1.0, 0.0f}}, // lower right corner
    {{-0.5f, -0.5f, -0.5f}, {0.0f, 0.0f, 1.0f}, {0.0, 0.0f}}, // upper left corner
    {{-0.5f, -0.5f, 0.5f}, {1.0, 0.0f, 0.0f}, {0.0, 1.0f}}, // lower right corner
    
    {{0.5f, 0.5f, 0.5f}, {1.0, 0.0f, 0.0f}, {1.0, 1.0f}}, // lower left corner右
    {{0.5f, -0.5f, 0.5f}, {0.0f, 1.0f, 0.0f}, {1.0, 0.0f}}, // lower right corner
    {{0.5f, -0.5f, -0.5f}, {0.0f, 0.0f, 1.0f}, {0.0, 0.0f}}, // upper left corner
    {{0.5f, 0.5f, -0.5f}, {1.0, 0.0f, 0.0f}, {0.0, 1.0f}}, // lower right corner
    
    {{-0.5f, 0.5f, 0.5f}, {1.0, 0.0f, 0.0f}, {1.0, 1.0f}}, // lower left corner左
    {{-0.5f, -0.5f, 0.5f}, {0.0f, 1.0f, 0.0f}, {1.0, 0.0f}}, // lower right corner
    {{-0.5f, -0.5f, -0.5f}, {0.0f, 0.0f, 1.0f}, {0.0, 0.0f}}, // upper left corner
    {{-0.5f, 0.5f, -0.5f}, {1.0, 0.0f, 0.0f}, {0.0, 1.0f}}, // lower right corner
};



const GLubyte indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    4,5,6,
    6,7,4,
    8,9,10,
    10,11,8,
    12,13,14,
    14,15,12,
    16,17,18,
    18,19,16,
    20,21,22,
    22,23,20
};



@interface PERGLView ()
@property (nonatomic, strong) CAEAGLLayer *glLayer;
@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, assign) GLuint colorRenderBuffer;
@property (nonatomic, assign) GLuint indexBuffer;
@property (nonatomic, strong) PERShader *shader;
@property (nonatomic, strong) PERShader *lightShader;
@property (nonatomic, assign) GLuint positionSlot;
@property (nonatomic, assign) GLuint vertexColorSlot;
@property (nonatomic, assign) GLuint VAO;

@property (nonatomic, assign) GLuint textureUniform;
@property (nonatomic, assign) GLuint leafTextureUniform;

@property (nonatomic, assign) GLuint ourTexture;
@property (nonatomic, assign) GLuint leafTexture;

@property (nonatomic, assign) GLuint textureCoor;

@property (nonatomic, assign) GLuint modelMatrix;
@property (nonatomic, assign) GLuint viewMatrix;
@property (nonatomic, assign) GLuint projectionMatrix;


@property (nonatomic, assign) GLuint lightPositionSlot;
@property (nonatomic, assign) GLuint lightVertexColorSlot;
@property (nonatomic, assign) GLuint lightModelMatrix;
@property (nonatomic, assign) GLuint lightViewMatrix;
@property (nonatomic, assign) GLuint lightProjectionMatrix;
@property (nonatomic, assign) GLuint lightVAO;




@end

@implementation PERGLView

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self setupShader];
        [self setupLightShader];
        [self setupData];
        self.ourTexture = [self setupTexture:@"container.jpg" texure:GL_TEXTURE0];
        self.leafTexture = [self setupTexture:@"beetle" texure:GL_TEXTURE1];
        [self setupRender];

    }
    return self;
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

#pragma mark - commmon init

- (void)setupRender {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    displayLink.frameInterval = 60;
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

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
    self.VAO = VBO;
    
    
    glGenBuffers(1, &_lightVAO);
    glBindBuffer(GL_ARRAY_BUFFER, _lightVAO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

- (void)setupEBO {
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
}

#pragma mark - shader
- (void)setupShader {
    self.shader = [[PERShader alloc] initWithVertexName:@"SimpleVertex" frameName:@"SimpleFragment"];
    [self.shader compileShader];
    _positionSlot = glGetAttribLocation(self.shader.programHandle, "Position");
    glEnableVertexAttribArray(_positionSlot);
    
    _vertexColorSlot = glGetAttribLocation(self.shader.programHandle, "Color");
    glEnableVertexAttribArray(_vertexColorSlot);
    
    _textureCoor = glGetAttribLocation(self.shader.programHandle, "textureIn");
    glEnableVertexAttribArray(_textureCoor);
    
    
    
    self.modelMatrix = glGetUniformLocation(self.shader.programHandle, "model");
    self.viewMatrix = glGetUniformLocation(self.shader.programHandle, "view");
    self.projectionMatrix = glGetUniformLocation(self.shader.programHandle, "projection");

    
    _textureUniform = glGetUniformLocation(self.shader.programHandle, "ourTexture");
    _leafTextureUniform = glGetUniformLocation(self.shader.programHandle, "faceTexture");

}

- (void)setupLightShader {
    self.lightShader = [[PERShader alloc] initWithVertexName:@"LightVertex" frameName:@"LightFragment"];
    [self.lightShader compileShader];
    _lightPositionSlot = glGetAttribLocation(self.lightShader.programHandle, "Position");
    glEnableVertexAttribArray(_lightPositionSlot);

    _lightVertexColorSlot = glGetAttribLocation(self.lightShader.programHandle, "Color");
    glEnableVertexAttribArray(_lightPositionSlot);
//
//    _textureCoor = glGetAttribLocation(self.shader.programHandle, "textureIn");
//    glEnableVertexAttribArray(_textureCoor);
    
    
    self.lightModelMatrix = glGetUniformLocation(self.lightShader.programHandle, "model");
    self.lightViewMatrix = glGetUniformLocation(self.lightShader.programHandle, "view");
    self.lightProjectionMatrix = glGetUniformLocation(self.lightShader.programHandle, "projection");
    
}


#pragma mark - texture
- (GLuint)setupTexture:(NSString*)fileName texure:(NSInteger)index {
    CGImageRef spirteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spirteImage) {
        NSLog(@"fiale to load image");
        exit(1);
    }
    size_t width = CGImageGetWidth(spirteImage);
    size_t height = CGImageGetHeight(spirteImage);
    
    GLubyte *spirteData = (GLubyte*)calloc(width * height * 4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spirteData, width, height, 8, width * 4, CGImageGetColorSpace(spirteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spirteImage);
    CGContextRelease(spriteContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glActiveTexture(index);
    glBindTexture(GL_TEXTURE_2D, texName);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spirteData);
    
    free(spirteData);
    return texName;
}

#pragma mark - render
- (void)render:(CADisplayLink*)displayLink {
    glEnable(GL_DEPTH_TEST);
    glClearColor(51/255.0, 76/255.0, 76/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    
    glBindVertexArrayOES(_VAO);
    glUseProgram(self.shader.programHandle);

    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), 0);
    glEnableVertexAttribArray(_positionSlot);
    
    glVertexAttribPointer(_vertexColorSlot, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (GLvoid*)(3*sizeof(float)));
    glEnableVertexAttribArray(_vertexColorSlot);
    
    glVertexAttribPointer(_textureCoor, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (GLvoid*)(6*sizeof(float)));
    glEnableVertexAttribArray(_textureCoor);
    
    glUniform1i(_textureUniform, 1);
    glUniform1i(_leafTextureUniform, 0);
    
    CC3GLMatrix *modelMatrix = [CC3GLMatrix identity];
    [modelMatrix rotateByX:12];
    [modelMatrix rotateByZ:22];
    [modelMatrix rotateByY:32];
        glUniformMatrix4fv(self.modelMatrix, 1, GL_FALSE, modelMatrix.glMatrix);
        
    CC3GLMatrix *viewMatrix = [CC3GLMatrix identity];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat z = 0;
    [viewMatrix translateByZ:z];
    [viewMatrix translateByX:x];
    [viewMatrix translateByY:y];
    glUniformMatrix4fv(self.viewMatrix, 1, GL_FALSE, viewMatrix.glMatrix);
        
    CC3GLMatrix *projetionMatrix = [CC3GLMatrix identity];
        //    [projetionMatrix populateFromFrustumLeft:-1 andRight:1 andBottom:-1 andTop:1 andNear:0.1 andFar:100];
//        [projetionMatrix populateOrthoFromFrustumLeft:-1 andRight:1 andBottom:-1 andTop:1 andNear:0.1 andFar:100];
    float radius = 10.0f;
    NSInteger random = [[NSDate date] timeIntervalSinceReferenceDate];
    float camX = sin(random%360*40/180.0) * radius;
    float camZ = cos(random%360*40/180.0) * radius;
    [projetionMatrix populateToLookAt:CC3VectorMake(camX, 0, camZ) withEyeAt:CC3VectorMake(0, 0, 0) withUp:CC3VectorMake(0, 1, 0)];
    glUniformMatrix4fv(self.projectionMatrix, 1, GL_FALSE, projetionMatrix.glMatrix);
    
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);
    
    
    glBindVertexArrayOES(_lightVAO);
    glUseProgram(self.lightShader.programHandle);
    glVertexAttribPointer(_lightPositionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), 0);
    glEnableVertexAttribArray(_lightPositionSlot);
    
    glVertexAttribPointer(_lightPositionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (GLvoid*)(3*sizeof(float)));
    glEnableVertexAttribArray(_lightPositionSlot);
    
  
    
    CC3GLMatrix *lightModelMatrix = [CC3GLMatrix identity];
    [lightModelMatrix scaleByX:0.1];
    [lightModelMatrix scaleByY:0.1];
    [lightModelMatrix scaleByZ:0.1];
    glUniformMatrix4fv(self.lightModelMatrix, 1, GL_FALSE, lightModelMatrix.glMatrix);
    
    CC3GLMatrix *lightViewMatrix = [CC3GLMatrix identity];
//    [lightViewMatrix translateByZ:0];
    [lightViewMatrix translateByX:-0.8];
    [lightViewMatrix translateByY:0.7];
    glUniformMatrix4fv(self.lightViewMatrix, 1, GL_FALSE, lightViewMatrix.glMatrix);
    
    CC3GLMatrix *lightProjetionMatrix = [CC3GLMatrix identity];
//        [lightProjetionMatrix populateFromFrustumLeft:-1 andRight:1 andBottom:-1 andTop:1 andNear:0.1 andFar:100];
    //        [projetionMatrix populateOrthoFromFrustumLeft:-1 andRight:1 andBottom:-1 andTop:1 andNear:0.1 andFar:100];

    [lightProjetionMatrix populateToLookAt:CC3VectorMake(8, 0, 7) withEyeAt:CC3VectorMake(0, 0, 0) withUp:CC3VectorMake(0, 1, 0)];
    glUniformMatrix4fv(self.lightProjectionMatrix, 1, GL_FALSE, projetionMatrix.glMatrix);
    
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);
 

//    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices)/sizeof(SceneVertex));
    
    
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
}
@end
