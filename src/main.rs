use texture::Texture;
use wgpu::util::DeviceExt;

mod life;
mod render;
mod framework;
mod texture;
mod life_params;

use crate::{
    life::Life,
    render::Renderer,
    life_params::LifeParams
};

struct GameLife {
    life: Life,
    renderer: Renderer,
    params: Vec<usize>
}

impl framework::Example for GameLife {
    fn required_limits() -> wgpu::Limits {
        wgpu::Limits::downlevel_defaults()
    }

    fn required_downlevel_capabilities() -> wgpu::DownlevelCapabilities {
        wgpu::DownlevelCapabilities {
            flags: wgpu::DownlevelFlags::COMPUTE_SHADERS,
            ..Default::default()
        }
    }

    /// update is called for any WindowEvent not handled by the framework
    fn update(&mut self, _event: winit::event::WindowEvent) {
        //empty
    }

    /// resize is called on WindowEvent::Resized events
    fn resize(
        &mut self,
        _sc_desc: &wgpu::SurfaceConfiguration,
        _device: &wgpu::Device,
        _queue: &wgpu::Queue,
    ) {
        //empty
    }

    fn init(
        config: &wgpu::SurfaceConfiguration,
        _adapter: &wgpu::Adapter,
        device: &wgpu::Device,
        _queue: &wgpu::Queue,
    ) -> Self {
        // Create texture
        // Init life, setting the initial state
        // Init renderer

        let life_param_data: Vec<usize> = [
            768, // height
            1024, // width
        ].to_vec();

        let life_params = LifeParams::new(device, &life_param_data);
        let texture = Texture::new(&device, &life_param_data, wgpu::TextureFormat::R32Float);
        let mut life = Life::new(&texture, &life_param_data, &life_params, &device);
        let renderer = Renderer::new(&texture, &life_params, &config, &device);

        GameLife {
            life: life,
            renderer: renderer,
            params: life_param_data,
        }
    }

    fn render(
        &mut self,
        view: &wgpu::TextureView,
        device: &wgpu::Device,
        queue: &wgpu::Queue,
        _spawner: &framework::Spawner,
    ) {
        // Create command encoder
        // Run life step
        // Run render step
        // Submit queue

        let mut command_encoder = device.create_command_encoder(&wgpu::CommandEncoderDescriptor { label: None });

        self.life.step(&mut command_encoder, &self.params);
        self.renderer.render(&mut command_encoder, &view);

        queue.submit(Some(command_encoder.finish()));
    }
}

/// run example
fn main() {
    framework::run::<GameLife>("Game of Life");
}