shader_type canvas_item;

// 主星星控制参数
uniform vec4 bg_color : source_color = vec4(0.0,0.0,0.0,255.0);
uniform float glare_intensity : hint_range(0, 1) = 0.0;
uniform float star_prob : hint_range(0, 1) = 1.0;
uniform float star_size : hint_range(0.5, 2.0) = 1.0; // 🚀主星星尺寸系数

// 小星星控制参数
uniform float small_star_prob : hint_range(0.9, 0.999) = 0.996; // 🚀小星星出现概率
uniform float small_star_size : hint_range(0.1, 2.0) = 0.5;    // 🚀小星星尺寸
uniform float small_star_speed : hint_range(0.5, 5.0) = 3.0;   // 🚀闪烁速度
uniform float small_star_intensity : hint_range(0, 1) = 0.8;   // 🚀最大亮度

float rand(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    float base_size = 100.0;
    float size = base_size * star_size; // 🚀应用主星尺寸系数
    
    vec2 pos = floor(FRAGCOORD.xy / size);
    float color = 0.0;
    float starValue = rand(pos);

    // 主星星生成
    if (starValue > star_prob) {
        vec2 center = size * pos + vec2(size) * 0.5;
        float t = 0.9 + 0.2 * sin(TIME * 8.0 + (starValue - star_prob)/(1.0 - star_prob)*45.0);
        float dist = distance(FRAGCOORD.xy, center);
        
        // 动态尺寸计算
        float core_radius = 0.5 * size * (0.8 + star_size * 0.2);
        float core = 1.0 - smoothstep(0.0, core_radius, dist);
        
        // 星芒计算
        float dx = abs(FRAGCOORD.x - center.x) + 0.001;
        float dy = abs(FRAGCOORD.y - center.y) + 0.001;
        float glare = t * t / (dx * dy * 0.05) * glare_intensity;
        
        color = core + glare;
        color = clamp(color, 0.0, 1.0);
    }
    // 小星星生成（带尺寸控制）
    else if (rand(SCREEN_UV.xy * 20.0) > small_star_prob) {
        vec2 star_uv = SCREEN_UV * 50.0;
        vec2 grid_pos = floor(star_uv);
        vec2 center = (grid_pos + 0.5) / 50.0;
        
        // 🚀尺寸计算
        float dist = distance(SCREEN_UV, center) * 100.0;
        float radius = 2.0 * small_star_size;
        float star = smoothstep(radius, 0.0, dist);
        
        // 🚀动态亮度
        float r = rand(grid_pos);
        float blink = 0.85 * sin(TIME * small_star_speed + r * 10.0) + 0.95;
        color = star * blink * small_star_intensity;
        color = clamp(color, 0.0, 1.0);
    }

    COLOR = mix(bg_color, vec4(1.0), color);
}