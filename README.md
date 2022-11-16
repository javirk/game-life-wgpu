# Conway's Game of Life - WGPU

I wanted to learn how to do GPU programming in Rust, so I developed this small thing. It uses Compute Shaders for computing and traditional vertex + fragment shaders for rendering. It does three channels in parallel for the colors. 

60fps in my machine, with a modest GTX 1070 using Vulkan backend.

I used https://github.com/blakej11/wgpu-life as a reference. One week ago I had no idea what a Compute Shader was.

### Example
![gol](https://github.com/javirk/game-life-wgpu/blob/master/images_readme/game_of_life.gif)