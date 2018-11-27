varying lowp vec4 vertexColor;
varying lowp vec2 textureOut;


uniform lowp sampler2D ourTexture;
uniform lowp sampler2D faceTexture;



void main(void) {
    //1color from data
//    gl_FragColor = vertexColor;
    //2 color from picture
//    gl_FragColor = texture2D(ourTexture, textureOut);
    //3 two picture mix
    //chang up and down
//    lowp vec4 back = texture2D(faceTexture, textureOut);
//    lowp vec4 bettle = texture2D(ourTexture, vec2(textureOut.x, 1.0 - textureOut.y));
//    gl_FragColor = mix(back,bettle, bettle.a);
    
    //4chang picture size
    lowp vec4 back = texture2D(faceTexture, textureOut);
    lowp vec4 bettle = texture2D(ourTexture, vec2(textureOut.x*3.0, textureOut.y*3.0));
    gl_FragColor = mix(back,bettle, bettle.a);
}
