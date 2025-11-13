shader_type canvas_item;

uniform bool selected = true;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float outline_thickness = 10.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (selected) {
        float alpha = tex_color.a;
        for (float x = -outline_thickness; x <= outline_thickness; x++) {
            for (float y = -outline_thickness; y <= outline_thickness; y++) {
                alpha = max(alpha, texture(TEXTURE, UV + vec2(x, y) / TEXTURE_PIXEL_SIZE).a);
            }
        }
        if (alpha > tex_color.a) {
            COLOR = outline_color;
        }
    } else {
    	COLOR = tex_color;
	}
}
