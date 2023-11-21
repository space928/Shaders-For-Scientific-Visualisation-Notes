# Shader Render & Vertex Buffers API

The existing solution is nice for simple single-pass full screen shaders:
```py
canvas = ssv.canvas()
canvas.shader("glsl code...")
canvas.run()
```
Setting uniforms can be done globally on the canvas:
```py
canvas.update_uniform("uColour", (1, 0, 1, 1))
canvas.update_uniform("uColour", (1, 0, 1, 1), buffer_id=1)  # Only update the uniform for this render buffer
```
We can also update the uniforms from a separate thread at runtime to animate these values

### But what if we want multiple passes or multiple draw calls
I see two (major) options, procedural and object-oriented (I guess we could also imagine a fluent interface, idk)
The procedural option I think is more concise (especially for simple shaders) but has higher cognitive load to read
as the user needs a mental map of the buffer ids being used.

**Fully procedural, render buffers are referenced by index:**
```py
canvas = ssv.canvas()
canvas.shader("glsl code...")
canvas.shader("glsl code...", buffer_id=1)
canvas.shader("glsl code...", buffer_id=2)
canvas.run()
# Updating the parameters of the render buffer is done in a separate call
canvas.update_render_buffer(buffer_id=1, size=(512, 512))
```

**Object-oriented, render buffers are referenced by object (but the object just represents an index internally):**
```py
canvas = ssv.canvas()
rb = canvas.render_buffer(output_buffer=True)  # One of the buffers needs to be the canvas' output
rb.shader("glsl code...")
rb1 = canvas.render_buffer(order=100)  # Priorities would need to be specified if you want to impose a rendering order
rb1.shader("glsl code...")
rb2 = canvas.render_buffer(order=200)
rb2.shader("glsl code...")
canvas.run()
# This method does have the advantage that we can put other functionality in the render buffer object which could be
# useful:
rb1 = canvas.render_buffer(size=(512, 512), order=100)
rb1.update_uniform()
```

#### This is all complicated when we introduce multiple draw calls:

**Procedural:**
```py
canvas = ssv.canvas()
canvas.shader("glsl code...")  # Normal full screen shader as before, takes advantage of default parameters to save code
# In buffer 1 though we'll render two draw calls
canvas.vertex_buffer([...], buffer_id=1, vertex_buffer=1)
canvas.shader("glsl code...", buffer_id=1, vertex_buffer=1)
canvas.vertex_buffer([...], buffer_id=1, vertex_buffer=2)
canvas.shader("glsl code...", buffer_id=1, vertex_buffer=2)
```

**OOP:**
```py
canvas = ssv.canvas()
rb = canvas.render_buffer(output_buffer=True)  # One of the buffers needs to be the canvas' output
vb = rb.vertex_buffer()  # A default full-screen vertex buffer
vb.shader("glsl code...")
# In buffer 1 though we'll render two draw calls
rb1 = canvas.render_buffer(order=100)
vb1 = rb1.vertex_buffer([...])
vb1.shader("glsl code...")
vb2 = rb1.vertex_buffer([...])
vb2.shader("glsl code...")
```

Neither of these are ideal, and maybe a hybrid approach would be better. OOP takes 3 lines to do what procedural can
do in one; on the other hand procedural means that a `shader()` needs to be associated with two random integers which
need to be kept track of. We could bring the "default" parameters approach of procedural to OOP to allow
`canvas.shader()` in the OOP approach but this would mean that in OOP: the canvas, the render buffer, and the vertex
buffer would have a `shader()` method which seems confusing.

**Fluent**, I really don't like this one, fluent apis just aren't good for DAG like structures they only really work for
```py
canvas = (ssv.canvas()
          .create_render_buffers([lambda rb: rb
                                  .vertex_buffer(...)
                                  .shader("glsl"),
                                  lambda rb: rb
                                  .vertex_buffer(...)
                                  .shader("glsl")])
          .run())
```

### More Approaches

**Stateful:**
```py
# We can store the result of these constructors, but the api is stateful, so you don't need to
canvas = ssv.canvas()
canvas.shader("glsl")  # Here we rely on the init state being to bind to the output buffer on a full screen vertex buff
canvas.render_buffer(...)  # Now we've changed the state, we're now working on this render buffer
canvas.shader("glsl")  # Full screen shader in a new render buffer
canvas.vertex_buffer(...)  # Two more draw calls in the same render_buffer
canvas.shader("glsl")
canvas.vertex_buffer(...)
canvas.shader("glsl")
```
This method seems concise at first, but eventually you need to rely on either buffer_ids or buffer objects to be
able to refer back to buffers you've already made to bind them again (for instance to write uniforms after everything
else is done). So you get the woes of stateful apis (ie: hidden dependencies) and you still don't fully escape the
problems of OOP/procedural.
It also has some readability issues since it hides the hierarchy of ownership of these objects which OOP makes
apparent.


**Hybrid procedural OOP:**
```py
canvas = ssv.canvas()
# A shader on a render buffer directly implies rendering in full screen
canvas.shader("glsl", buffer_id=1)
# Vertex buffers are bound to render buffers and can have shaders bound to them as well
vb = canvas.vertex_buffer([...], buffer_id=1)
vb.triangles()
vb.shader("glsl", buffer_id=1)
canvas.run()
```

**In matplotlib the "multiple buffers problem" (in their case multiple plots) is handled by just allowing graphing
calls on both:**
```py
canvas = ssv.canvas()
canvas.shader("glsl")
# For matplotlib you would have to define all your axes at once, but here there's no need
rb = canvas.render_buffer(...)
rb.shader("glsl")
```
In this case internally the call to canvas.shader() is actually:
```py
def shader(self, source):
    self._default_render_buffer.shader(source)
```

It feels a little inelegant (maybe confusing?) to have two classes you can call shader() from, but it's arguably
concise and flexible.

Taking this further and integrating multiple draw calls as well though we end up with three different classes where
you can call `shader()`:
```py
canvas = ssv.canvas()
canvas.shader("glsl")  # SSVCanvas.shader() -> Binds to the full screen, to the output buffer
rb = canvas.render_buffer(...)
rb.shader("glsl")  # SSVRenderBuffer.shader() -> Binds to the full screen, to a given buffer
vb = rb.vertex_buffer(...)
vb.shader("glsl")  # SSVVertexBuffer.shader() -> Binds to a given mesh, to a given buffer
# You could also have:
vb1 = canvas.vertex_buffer(...)
vb1.shader("glsl")  # SSVVertexBuffer.shader() -> Binds to a given mesh, to the output buffer
```

This way of doing OOP mirrors the use of default parameters when using procedural code:
```py
# Where render_buffer_id=0 is the output buffer, and vertex_buffer_id=-1 is a full screen vertex buffer
def shader(self: SSVCanvas, source, render_buffer_id = 0, vertex_buffer_id = -1): 
    ...
```

Again, I think the OOP is easier to read (especially if you don't know the library at all) whereas the procedural is
easier to fully grasp. Especially if you don't initially understand the strict hierarchy of:
```
   SSVCanvas
       \/  Owns[n]
 SSVRenderBuffer
       \/  Owns[n]
 SSVVertexBuffer
       \/  Owns[1]
     Shader
```


# Data Input

Ok besides vertex data and shaders we want to pass other data into the shader. This data may be:
 - A simple array of floats or colours
 - A 2D array of floats or colours
 - A 1D/2D of a more complex data type
 - A sparse data type
 - Something that might benefit from interpolation or not
 - Multidimensional (more than 3 dimensions)

### Device Limits

Some of this data might be well suited to vertex data (positions and other attributes), some might be just arrays of
uniforms, some might be 1D/2D/3D textures.
In OpenGL there are limits to how much data you can pass in through each of these formats:
On my machine that's:
 Textures:
 - MAX_3D_TEXTURE_SIZE: `16384`
 - MAX_TEXTURE_SIZE: `32768` *This is about 4GB of data*
 - MAX_TEXTURE_BUFFER_SIZE: `134217728`
 Uniforms:
 - COMBINED_FRAGMENT_UNIFORM_COMPONENTS: `233472` *FRAGMENT_UNIFORM_COMPONENTS + UNIFORM_BLOCK_SIZE * UNIFORM_BLOCKS / 4*
 - UNIFORM_BLOCKS: `14` *How many UBOs*
 - UNIFORM_COMPONENTS: `4096` *How many floats (ie vec3=3 components); Similar for other shader stages*
 - UNIFORM_VECTORS: `1024`
 - UNIFORM_BLOCK_SIZE: `65536` *Max size in bytes of a UBO*
 - UNIFORM_BUFFER_BINDINGS: `84`
 Vertices:
 - MAX_ELEMENTS_VERTICES: `1048576`
 - MAX_ELEMENTS_INDICES:  `1048576`
 Varyings:
 - VARYING_VECTORS: `31`

How do we handle cases where the user wants to allocate too much memory?  
*->Multi-pass rendering -> not trivial to do automatically, needs the user to help*  
*->Just error out -> let the user do multi-pass rendering if they need it*  
How do we decide how to pass the data in?  
*->The user should?*

Ways to handle big data:
 - For vertices, we can usually just render in multiple passes, this is a solved problem for opaque geometry (for
   transparent geometry order matters!)
 - For uniforms, we can optimise the use of uniforms, pack things together when possible and take advantage of UBOs
   (which give us an additional ~900KB of uniforms). Beyond that, the user needs to split the work themselves.
 - For textures, generally it's also up to the user, but there are some cases where virtual textures could help.  
   https://silverspaceship.com/src/svt/  

In general none of these methods can be fully automatic, so we need keep these limits clear and concise to the user.

### Feeding With Data

#### Vertex Buffers

Working with vertex buffers is non-trivial for users, there are pitfalls to consider:
https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/TechniquesforWorkingwithVertexData/TechniquesforWorkingwithVertexData.html
Users might prefer to just specify an array of verts, arrays of vertex attributes, and an array of triangles.
To do this though in OpenGL you need to interleave and pack all your vertex data and then order it carefully
(this is an optimisation problem) into triangle strips. It might make more sense to do that for the user. If we do
this for the user there may be a performance hit in reordering vertex data which users might be able to do faster in
some cases, but this is only a problem if you want to animate vertex data, for which I think vertex/geometry 
shaders + textures would be better.
 - *Users shouldn't need to carefully interleave their vertex attributes together*
 - *Users shouldn't need to order their vertex arrays carefully to make triangles -> index arrays are nicer -> we need
   to work out how best to convert these into triangles/triangle strips*
 - *We shouldn't have to triangulate random vertices for users -> if we wanted though we could give them a separate
   delaunay triangulator...*

#### Textures

There are plenty of cases where users might already have their data in a texture (or a format adjacent to a texture 
format). In these cases, no problem and we should provide APIs to let them do this (import texture from file or Pillow 
image). In other cases they may want to convert a numpy tensor to a texture. 

When sampling textures, OpenGL always samples into a `vec` unless using a *Buffer Texture*. The precision of data in 
textures is dependent on the texture format (the most common, RGBA8 provides 8 bits per channel), there's a range of 
formats to choose from based on the user's needs. But we should encourage users to be conservative of the texture 
format they use instead of just blindly converting a NumPy array to a `GL_R32F` texture. 64 bit textures/vector 
opertations are supported on many platforms with an extension. All this being said we should probably just let users 
decide how they want to use 2D textures, the different formats (with the exception of some specialised ones) are not 
complicated to grasp (unlike direct x):
https://moderngl.readthedocs.io/en/5.8.2/topics/texture_formats.html

*Buffer Textures* bridge the gap between uniform arrays and textures. They allow for raw access (no interpolation) to 1D
data. They allow for larger arrays than uniform arrays and normal 1D textures (but less data than a full size 2D 
texture). They are still constrained to standard OpenGL texture types, but with raw access to the data within them (so 
they can effectively be used for any simple data structure).

ModernGL can copy texture data from a python `bytes` or a `moderngl.Buffer`. I'm not entirely familiar with memory 
marshalling in python, so I don't know how efficient sending `bytes` to OpenGL is, and ideally it would be possible to 
pass a pointer to a NumPy array to OpenGL if the data is blittable.

### Getting the Memory From The Main Process to the Render Process


## How Would This API Look?

