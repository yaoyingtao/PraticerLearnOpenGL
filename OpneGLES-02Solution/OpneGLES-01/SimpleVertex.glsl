
attribute vec3 Position;
attribute vec3 Color;
attribute vec2 textureIn;

varying lowp vec2 textureOut;
varying vec4 vertexColor;

void main(void) {
    textureOut = textureIn;
    vertexColor = vec4(Color, 1.0);
    gl_Position = vec4(Position, 1.0);
}
