```c

########### Jupyter (TS) ###########
class SSVRenderView
  /\
  ||
  \/                       
class SSVRenderModel    <----\ controls
                             |
                             |
########### Kernal (Py) #####|######
                             |
class SSVCanvas              |
|                            |
| owns                       |
|->  class SSVRenderWidget --/
|
| owns
|->  class SSVRender
     | one of
     | 
     |-> SSVRenderOpenGL
     |
     |-> SSVRenderWebGL

```