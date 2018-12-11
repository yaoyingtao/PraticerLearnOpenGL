varying lowp vec4 vertexColor;
varying lowp vec2 textureOut;


uniform lowp sampler2D ourTexture;
uniform lowp sampler2D faceTexture;



void main(void) {
    //1color from data
    gl_FragColor = vec4(1,0,0,1);
    //2 color from picture
//    gl_FragColor = texture2D(ourTexture, textureOut);
    //3 two picture mix
//    gl_FragColor = mix(texture2D(ourTexture, textureOut),texture2D(faceTexture, textureOut), 0.5);
}
