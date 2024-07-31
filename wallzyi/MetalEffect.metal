#include <metal_stdlib>
using namespace metal;

//constant float2 c_defaultLightPosition = float2(0.5, 0.5);
//constant float2 c_defaultVelocity = float2(0.0, 0.0);

half4 metalEffect(float2 p, texture2d<half> a, sampler s, float2 l, float2 v) {
    float2 m = -v * pow(clamp(1.0 - length(l - p) / 190.0, 0.0, 1.0), 2.0) * 1.5;
    
    half3 c = half3(0.0);
    
    for (float i = 0.0; i < 10.0; i++) {
        float spread = 0.175 + 0.005 * i;
        
        c += half3(
            a.sample(s, p + spread * m).r,
            a.sample(s, p + (spread + 0.025) * m).g,
            a.sample(s, p + (spread + 0.05) * m).b
        );
    }
    
    return half4(c / 10.0, 1.0);
}

struct VertexIn {
    float4 position [[attribute(0)]];
    float2 texCoord [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

vertex VertexOut vertexShader(VertexIn in [[stage_in]]) {
    VertexOut out;
    out.position = in.position;
    out.texCoord = in.texCoord;
    return out;
}

fragment half4 fragmentShader(VertexOut in [[stage_in]],
                              texture2d<half> texture [[texture(0)]],
                              sampler textureSampler [[sampler(0)]],
                              constant float2& lightPosition [[buffer(0)]],
                              constant float2& velocity [[buffer(1)]]) {
    return metalEffect(in.texCoord, texture, textureSampler, lightPosition, velocity);
}
