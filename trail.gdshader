
shader_type spatial;
render_mode blend_mix, depth_draw_never, cull_disabled, unshaded;

void fragment() {
    ALBEDO = vec3(1.0, 0.62, 0.16);
    ALPHA = 0.55;
}
