
attribute vec3 Position;
attribute vec3 Color;
attribute vec2 textureIn;

uniform lowp mat4 transform;

varying lowp vec2 textureOut;
varying vec4 vertexColor;

void main(void) {
    textureOut = textureIn;
    vertexColor = vec4(Color, 1.0);
    gl_Position = transform * vec4(Position, 1.0);
}
