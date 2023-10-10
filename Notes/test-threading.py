#  Copyright (c) 2023 Thomas Mathieson.
#  Distributed under the terms of the MIT license.

import threading
import logging
import time

import moderngl
import numpy as np


class SSVRenderOpenGL:
    """
    A rendering backend for SSV based on OpenGL
    """

    def __init__(self, resolution):
        self.resolution = resolution
        self.__create_context()
        self.start_time = time.time()

    def __create_context(self):
        """
        Creates an OpenGL context and a framebuffer.
        """
        self.ctx = moderngl.create_context(standalone=True)

        # To use moderngl with threading we need call the garbage collector manually
        self.ctx.gc_mode = None

        resolution = (min(self.resolution[0], self.ctx.info["GL_MAX_VIEWPORT_DIMS"][0]),
                      min(self.resolution[1], self.ctx.info["GL_MAX_VIEWPORT_DIMS"][1]))
        self.fbo = self.ctx.simple_framebuffer(resolution, components=4)
        self.fbo.use()

    def log_context_info(self, full=False):
        """
        Logs the OpenGL information to the console for debugging.
        :param full: whether to log *all* of the OpenGL context information (including extensions)
        """
        print(f"Got OpenGL context:\n"
              f"\tGL_VENDOR={self.ctx.info['GL_VENDOR']}\n"
              f"\tGL_RENDERER={self.ctx.info['GL_RENDERER']}\n"
              f"\tGL_VERSION={self.ctx.info['GL_VERSION']}")
        if full:
            from pprint import pformat
            info = pformat(self.ctx.info, indent=4)
            print(f"Full info: \n{info}")
            extensions = pformat(self.ctx.extensions, indent=4)
            print(f"GL Extensions: \n{extensions}")

    def register_shader(self):
        ...

    def dbg_render_test(self):
        # Create a vertex buffer
        vertices = np.array([
            # X      Y      R    G    B
            -1.0, -1.0, 1.0, 0.0, 0.0,
            1.0, -1.0, 0.0, 1.0, 0.0,
            0.0, 1.0, 0.0, 0.0, 1.0],
            dtype='f4',
        )

        self.log_context_info()
        prog = self.ctx.program(vertex_shader="""
        #version 330
        in vec2 in_vert;
        in vec3 in_color;
        out vec3 color;
        out vec2 position;
        void main() {
            gl_Position = vec4(in_vert, 0.0, 1.0);
            color = in_color;
            position = in_vert*0.5+0.5;
        }
        """,
                                fragment_shader="""
        #version 330
        out vec4 fragColor;
        in vec3 color;
        in vec2 position;

        uniform vec2 iResolution;
        uniform float iTime;

        float amod(float x, float y)
        {
            return x - y * floor(x/y);
        }

        vec4 mainImage(in vec2 fragCoord)
        {
            // Normalized pixel coordinates (from 0 to 1)
            vec2 uv = fragCoord/iResolution.xy;

            float coord = floor(fragCoord.x) + floor(fragCoord.y/10.) + floor(iTime);
            //vec3 col = vec3(amod(coord, 16.)>=8.?1.:0., amod(coord, 32.)>=16.?1.:0., amod(coord, 64.)>=32.?1.:0.);
            //col = amod(coord, 128.)>64.?(col*0.3333+.3333):col;

            vec3 col = vec3(amod(coord, 64.) >= 56. ? 1. : 0.,
                            amod(coord + 16., 64.) >= 56. ? 1. : 0.,
                            amod(coord + 32., 64.) >= 56. ? 1. : 0.);
            col += amod(coord + 48., 64.) >= 56. ? 1. : 0.;
            col = amod(coord, 128.) > 64. ? (col * 0.3333 + .3333) : col;

            // Output to screen
            return vec4(col,1.0);
        }

        void main() {
            fragColor = mainImage(position * iResolution) + vec4(color, 1.0)*0.01;
            //fragColor = vec4(color, 1.0);
        }
        """)

        # Set uniforms
        prog["iResolution"].value = self.resolution
        prog["iTime"].value = time.time() - self.start_time

        # Assign buffers and render
        vao = self.ctx.simple_vertex_array(prog, self.ctx.buffer(vertices), 'in_vert', 'in_color')
        vao.render(mode=moderngl.TRIANGLES)

    def get_frame(self):
        """
        Gets the current contents of the frame buffer as a byte array.
        :return: the contents of the frame buffer as a bytearray in the ``RGBA`` format.
        """
        return self.fbo.read(components=4)


renderer = SSVRenderOpenGL((640, 480))


def render_loop(exit_flag):
    target_framerate = 60
    last_frame_time = time.time()
    timeout = 0
    delta_time = 1 / target_framerate
    while not exit_flag.wait(timeout=timeout):
        renderer.dbg_render_test()

        current_time = time.time()
        delta_time = current_time - last_frame_time
        timeout = max(1 / target_framerate - delta_time, 0)
        last_frame_time = current_time
        break


def run():
    exit_flag = threading.Event()
    thread = threading.Thread(target=render_loop, args=(exit_flag,))

    # render_loop(exit_flag)
    thread.start()


run()
