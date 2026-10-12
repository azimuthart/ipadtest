shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;

varying vec3 local_position;

void vertex() {
    local_position = VERTEX;
}

void fragment() {
    vec2 p = local_position.xz;
    float radius = length(p);
    float t = TIME;

    float basin_radius = 4.7;
    float speed = 0.65;
    float spacing = 1.35;
    float ring_width = 0.22;
    float wall_delay = 0.05;

    float travel_time = basin_radius / speed;
    float cycle_duration = travel_time * 2.0 + wall_delay;
    float emission_interval = spacing / speed;

    // Break up the rings, with stronger distortion near the rim.
    float edge_factor = smoothstep(3.5, basin_radius, radius);

    float distortion =
        sin(p.x * 2.3 + t * 0.7)
        * sin(p.y * 2.0 - t * 0.5) * 0.10;

    distortion +=
        sin(p.x * 5.0 - t * 0.9)
        * cos(p.y * 4.0 + t * 0.6)
        * 0.08 * edge_factor;

    float r = radius + distortion;

    float outgoing = 0.0;
    float returning = 0.0;
    float impact = 0.0;

    // Fewer ripple sources, spaced further apart.
    for (int i = 0; i < 10; i++) {
        float start_time = float(i) * emission_interval;
        float age = t - start_time;

        if (age >= 0.0) {
            age = mod(age, cycle_duration);

            if (age < travel_time) {
                // Incoming ring travels towards the basin wall.
                float ring_radius = age * speed;
                float d = abs(r - ring_radius);

                float ring = 1.0 - smoothstep(
                    ring_width * 0.25,
                    ring_width,
                    d
                );

                // Incoming wave breaks up near the wall.
                float breakup =
                    sin(p.x * 7.0 + t * 2.0)
                    * cos(p.y * 6.0 - t * 1.7);

                float break_factor = smoothstep(
                    basin_radius - 1.0,
                    basin_radius,
                    ring_radius
                );

                ring *= 1.0 - break_factor * 0.55
                    * smoothstep(-0.2, 0.8, breakup);

                outgoing = max(outgoing, ring);

                // Retained for the wall interaction calculation.
                float time_to_impact = travel_time - age;
                float impact_pulse =
                    exp(-time_to_impact * time_to_impact * 18.0);

                impact = max(
                    impact,
                    impact_pulse * break_factor
                );

            } else if (age >= travel_time + wall_delay) {
                // Weaker, irregular reflected wave travels inward.
                float return_age =
                    age - travel_time - wall_delay;

                float ring_radius =
                    basin_radius - return_age * speed;

                float reflected_distortion =
                    sin(p.x * 3.0 + t * 0.8)
                    * cos(p.y * 3.7 - t * 0.6) * 0.18;

                float reflected_radius =
                    ring_radius + reflected_distortion;

                float d = abs(r - reflected_radius);

                float ring = 1.0 - smoothstep(
                    ring_width * 0.25,
                    ring_width * 1.5,
                    d
                );

                // Reflection loses energy as it travels.
                ring *= 0.5 * exp(-return_age * 0.45);

                // Break the reflection into uneven fragments.
                float breakup =
                    sin(p.x * 6.0 + t * 1.3)
                    * cos(p.y * 7.0 - t * 1.1);

                ring *= 0.65 + 0.35 * breakup;

                // Dissipate before reaching the centre.
                ring *= smoothstep(0.0, 1.3, ring_radius);

                returning = max(returning, ring);
            }
        }
    }

    // Combine waves without the extra pulsing impact glow.
    float waves = max(outgoing, returning * 0.8);

    // Fade the pattern at the basin's edge.
    float edge_fade = 1.0 - smoothstep(
        basin_radius - 0.08,
        basin_radius + 0.02,
        radius
    );

    waves *= edge_fade;

    // Dark water with muted blue-grey highlights.
ALBEDO = mix(
    vec3(0.22, 0.29, 0.36),
    vec3(0.38, 0.47, 0.55),
    clamp(waves, 0.0, 1.0)
);

    ROUGHNESS = 0.28;
    METALLIC = 0.03;
    SPECULAR = 0.6;
}