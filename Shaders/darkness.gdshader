shader_type canvas_item;

// Controls how large the visible circle is (0.0 = full black, 1.0 = full visible)
uniform float circle_radius : hint_range(0.0, 1.5) = 1.0;
// Controls how soft the edge of the darkness is
uniform float softness : hint_range(0.0, 1.0) = 0.5;
// The color of the darkness (usually black)
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    // Get the vector from the center of the screen (0.5, 0.5)
    vec2 dist = UV - vec2(0.5);

    // Calculate distance from center, adjusted for aspect ratio if necessary
    // (For pixel art games, simple length is usually fine)
    float len = length(dist);

    // Calculate the vignette effect
    // We use smoothstep to create a soft transition based on the radius
    float vignette = smoothstep(circle_radius, circle_radius - softness, len);

    // Mix the screen color with the vignette color based on the calculated value
    // If vignette is 1.0, show screen. If 0.0, show darkness.
    COLOR = vec4(vignette_color.rgb, 1.0 - vignette);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
