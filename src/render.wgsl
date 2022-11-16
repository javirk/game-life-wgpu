struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) tex_coord: vec3<f32>,
};

struct LifeParams {
    width : u32,
    height : u32,
};

@vertex
fn vs_main(
    @location(0) position: vec4<f32>,
    @location(1) tex_coord: vec3<f32>,
) -> VertexOutput {
    var out: VertexOutput;
    out.position = position;
    out.tex_coord = tex_coord;
    return out;
}

@group(0) @binding(0) var texture: texture_storage_3d<r32float, read>;
@group(0) @binding(1) var<uniform> params : LifeParams;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let thresh : f32 = 0.001;
    var loadCoord_h: vec3<i32> = vec3<i32>(
        i32(in.tex_coord[0] * f32(params.width)),
        i32(in.tex_coord[1] * f32(params.height)),
        i32(0),
    );
    var loadCoord_s: vec3<i32> = vec3<i32>(
        i32(in.tex_coord[0] * f32(params.width)),
        i32(in.tex_coord[1] * f32(params.height)),
        i32(1),
    );
    var loadCoord_v: vec3<i32> = vec3<i32>(
        i32(in.tex_coord[0] * f32(params.width)),
        i32(in.tex_coord[1] * f32(params.height)),
        i32(2),
    );
    
    var cellValue: vec3<f32> = vec3<f32>(
        textureLoad(texture, loadCoord_h).x,
        textureLoad(texture, loadCoord_s).x,
        textureLoad(texture, loadCoord_v).x,
    );

    return vec4<f32>(cellValue, 1.0f);
}