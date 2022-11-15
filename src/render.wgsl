struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) tex_coord: vec2<f32>,
};

struct LifeParams {
    width : u32,
    height : u32,
};

@vertex
fn vs_main(
    @location(0) position: vec4<f32>,
    @location(1) tex_coord: vec2<f32>,
) -> VertexOutput {
    var out: VertexOutput;
    out.position = position;
    out.tex_coord = tex_coord;
    return out;
}

@group(0) @binding(0) var texture: texture_storage_2d<r32float, read>;
@group(0) @binding(1) var<uniform> params : LifeParams;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let thresh : f32 = 0.1;
    var loadCoord: vec2<i32> = vec2<i32>(
        i32(in.tex_coord[0] * f32(params.width)),
        i32(in.tex_coord[1] * f32(params.height))
    );
    var cellValue: f32 = textureLoad(texture, loadCoord).x;
    if (cellValue < thresh) {
        return vec4<f32>(0f, 0f, 0f, 1f);
    } else {
        return vec4<f32>(1f, 1f, 1f, 1f);
    }
}