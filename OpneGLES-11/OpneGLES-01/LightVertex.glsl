
attribute vec3 Position;
attribute vec3 Color;
attribute vec2 textureIn;

uniform lowp mat4 model;
uniform lowp mat4 view;
uniform lowp mat4 projection;


varying lowp vec2 textureOut;
varying vec4 vertexColor;

void main(void) {
    textureOut = textureIn;
    vertexColor = vec4(Color, 1.0);
    gl_Position = projection * view * model  * vec4(Position, 1.0);
}
