shader_type canvas_item;

// 背景颜色
uniform vec4 bg_color : source_color = vec4(0.0,0.0,0.0,1.0);

// 小星星控制参数
uniform float small_star_prob : hint_range(0.9, 0.999) = 0.996; // 小星星出现概率
uniform float small_star_size : hint_range(0.1, 2.0) = 0.5;     // 小星星尺寸
uniform float small_star_speed : hint_range(0.5, 5.0) = 3.0;    // 闪烁速度
uniform float small_star_intensity : hint_range(0, 1) = 0.8;    // 最大亮度

float rand(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    float color = 0.0;

    // 小星星生成（保持原版完全相同的参数和计算方式）
    if (rand(SCREEN_UV.xy * 20.0) > small_star_prob) {
        vec2 star_uv = SCREEN_UV * 50.0;
        vec2 grid_pos = floor(star_uv);
        vec2 center = (grid_pos + 0.5) / 50.0;

        // 保持原版完全相同的尺寸计算
        float dist = distance(SCREEN_UV, center) * 100.0;
        float radius = 2.0 * small_star_size;
        float star = smoothstep(radius, 0.0, dist);

        // 保持原版完全相同的闪烁效果
        float r = rand(grid_pos);
        float blink = 0.85 * sin(TIME * small_star_speed + r * 10.0) + 0.95;
        color = star * blink * small_star_intensity;
        color = clamp(color, 0.0, 1.0);
    }

    COLOR = mix(bg_color, vec4(1.0), color);
}
