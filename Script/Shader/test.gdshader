shader_type canvas_item;

uniform vec2 mouse_screen_pos;
uniform float hovering;
uniform float screen_scale = 1.0;

void vertex() {
    
    vec2 screen_size = vec2(1.0,1.0);
    float mid_dist = length(VERTEX.xy - 0.5 * screen_size) / length(screen_size);
    vec2 mouse_offset = (VERTEX.xy + mouse_screen_pos.xy) / screen_scale;
    float scale = 0.2 * (-0.03 - 0.3 * max(0.0, 0.3 - mid_dist)) * 
                  hovering * (length(mouse_offset) * length(mouse_offset)) / (2.0 - mid_dist);
    
    VERTEX += scale;
}