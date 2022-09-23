# Shader Tips

Project created to implement some common shader techniques with some documentation. In this project you can check out a example of:
- Vertex displacement
- Vertex color
- UV Displacement
- Stencil mask
- RGB Mask

You can combine this techniques to create effects or support features you need. 

## Vertex displacement

In the vertex shader, we can change object's vertices position to create some different effects. As the vertices are manipulated in the GPU, this changes DOESN'T affect the collisions.

In this project I've implemented 3 methods:

### Vertex displacement with map
This approach let you map a texture into a object in the vertex shader, then you can change each vertex based on the texture color mapped into them. You can also scroll the texture to animate this displacement.

Link: https://github.com/Felipinski/ShaderSlide/blob/main/Assets/Project/Shaders/VertexDisplacement_Map.shader

### Vertex displacement to inflate object
This example moves each vertex outward using the vertex normal.

Link: https://github.com/Felipinski/ShaderSlide/blob/main/Assets/Project/Shaders/VertexDisplacement_Scale.shader

### Vertex displacement to vibrate object
In this one, the vertices are moved in the same direction.

Link: https://github.com/Felipinski/ShaderSlide/blob/main/Assets/Project/Shaders/VertexDisplacement_Vibrate.shader

(These techniques can also be used with the particle system to animate meshes)

![VertexDisplacement](https://user-images.githubusercontent.com/59582811/191853615-210dc575-dc72-42e8-8f44-27187724e805.gif)

## Vertex color
Vertex color is a color usually added directly to the mesh in the 3D software. It can be used to render solid colors, or even use it as color mask.

### Only vertex color
In this one, the shader renders only the vertex color. It can be useful to render different objects with the same material to save some performances. But since vertex color depends on the vertex amount, you must be careful to not give to much details, because it can cause performance problems.

Link: https://github.com/Felipinski/ShaderSlide/blob/main/Assets/Project/Shaders/VertexColor_FullColor.shader

### Vertex color as mask
The color information can also be used as a color mask to render textures, for example, in different parts of the mesh.

Link: https://github.com/Felipinski/ShaderSlide/blob/main/Assets/Project/Shaders/VertexColor_Mask.shader

![VertexColor](https://user-images.githubusercontent.com/59582811/191853598-06940e02-1ce5-4205-9a6a-28befbb04579.gif)

## Stencil mask
This technique use the stencil buffer to render or discard pixels. 

But what is stencil buffer? It's part of the depth buffer where you can write and read its value to perform operations.

In this example, there's 3 hats and 1 spherical mask. The spherical mask writes 1 to the stencil buffer and each hat reads the stencil buffer. If the value is NOT EQUAL, the hat is rendered, otherwise its discarded.

Link: https://github.com/Felipinski/ShaderSlide/blob/main/Assets/Project/Shaders/StencilMask.shader

![Stencil mask](https://user-images.githubusercontent.com/59582811/191853568-3a1a13ed-4c04-4065-8c79-56b3bb4380a5.gif)
## Texture scroll

This technique changes the object UV to move/distort the textured mapped on it. It can be used to create water, lava, scrolling dissolves, etc.

Link: https://github.com/Felipinski/ShaderSlide/blob/main/Assets/Project/Shaders/UVDisplacement.shader

![TextureScroll](https://user-images.githubusercontent.com/59582811/191853583-155dec1f-e7bf-4736-a309-ea72ea6ff629.gif)

## RGB Mask

Really useful to create customization, this technique can be used to create many objects with different color with no need of more textures.
In this example, I've added one color variable per color channel, so I can change it even in runtime.
You'll need one material per color variation, but you can avoid it by using Material Property Block (Not implemented in this project).

Link: https://github.com/Felipinski/ShaderSlide/blob/main/Assets/Project/Shaders/RGBMask.shader

![RGBMask](https://user-images.githubusercontent.com/59582811/191853549-8a53361e-1c4e-4e5f-adb4-a1ef8c778295.gif)

All this techniques can be used together to create features and effects.
