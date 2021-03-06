module Yu.Splash exposing (Uniforms, Vertex, fragmentShader, mesh, vertexShader, view)

import Html exposing (Html)
import Html.Attributes as A
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import WebGL exposing (Mesh, Shader)
import Yu.Types exposing (Size)


type alias Vertex =
    { position : Vec3
    , color : Vec3
    }


type alias Uniforms =
    { time : Float
    , resolution : Vec2
    }


mesh : Mesh Vertex
mesh =
    WebGL.indexedTriangles
        [ Vertex (vec3 -1 -1 0) (vec3 1 0 0)
        , Vertex (vec3 -1 1 0) (vec3 0 1 0)
        , Vertex (vec3 1 1 0) (vec3 0 0 1)
        , Vertex (vec3 1 -1 0) (vec3 0 0 1)
        ]
        [ ( 0, 1, 2 )
        , ( 3, 2, 0 )
        ]


vertexShader : Shader Vertex Uniforms { vcolor : Vec3 }
vertexShader =
    [glsl|
        attribute vec3 position;
        attribute vec3 color;
        varying vec3 vcolor;

        void main() {
          gl_Position = vec4(position, 1.0);
          vcolor = color;
        }
    |]


fragmentShader : Shader {} Uniforms { vcolor : Vec3 }
fragmentShader =
    [glsl|
        precision mediump float;
        uniform float time;
        uniform vec2 resolution;
        varying vec3 vcolor;

        vec4 permute(vec4 x){return mod(((x*34.0)+1.0)*x, 289.0);}
        vec4 taylorInvSqrt(vec4 r){return 1.79284291400159 - 0.85373472095314 * r;}
        vec2 fade(vec2 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}

        float cnoise(vec2 P){
          vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
          vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
          Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
          vec4 ix = Pi.xzxz;
          vec4 iy = Pi.yyww;
          vec4 fx = Pf.xzxz;
          vec4 fy = Pf.yyww;
          vec4 i = permute(permute(ix) + iy);
          vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
          vec4 gy = abs(gx) - 0.5;
          vec4 tx = floor(gx + 0.5);
          gx = gx - tx;
          vec2 g00 = vec2(gx.x,gy.x);
          vec2 g10 = vec2(gx.y,gy.y);
          vec2 g01 = vec2(gx.z,gy.z);
          vec2 g11 = vec2(gx.w,gy.w);
          vec4 norm = 1.79284291400159 - 0.85373472095314 *
            vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
          g00 *= norm.x;
          g01 *= norm.y;
          g10 *= norm.z;
          g11 *= norm.w;
          float n00 = dot(g00, vec2(fx.x, fy.x));
          float n10 = dot(g10, vec2(fx.y, fy.y));
          float n01 = dot(g01, vec2(fx.z, fy.z));
          float n11 = dot(g11, vec2(fx.w, fy.w));
          vec2 fade_xy = fade(Pf.xy);
          vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
          float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
          return 2.3 * n_xy;
        }

        float getTexture(vec2 uv) {
          float min = min(resolution.x, resolution.y);
          float max = max(resolution.x, resolution.y);
          float xf = resolution.x <= resolution.y ? (min / max) : 1.0;
          float yf = resolution.y <= resolution.x ? (min / max) : 1.0;
          return cos(uv.x * xf) + sin(uv.y * yf);
        }

        void main () {
            vec2 uv1 = gl_FragCoord.xy + vec2(0.0, -time * 100.0);
            vec2 uv2 = gl_FragCoord.yx + vec2(0.0, -time * 100.0);
            float n1 = cnoise(uv1 / resolution.xy * 1.5) * 0.4;
            float n2 = cnoise(uv2 / resolution.yx * 1.5) * 0.4;

            vec2 flowDirection = (gl_FragCoord.xy / resolution - 0.5) * 2.0 + vec2(n1, n2);
            float cycleTime = 6.0;
            float t1 = time / cycleTime;
            float t2 = t1 + 0.5;
            float ct1 = t1 - floor(t1);
            float ct2 = t2 - floor(t2);
            float flowSpeed = 1.0 + 0.4 * sin(cos(time * 0.2) * log(time));
            vec2 flowVector1 = flowDirection * ct1 * flowSpeed;
            vec2 flowVector2 = flowDirection * ct2 * flowSpeed;
            float c1 = getTexture((gl_FragCoord.xy / resolution + flowVector1) * 64.0);
            float c2 = getTexture((gl_FragCoord.xy / resolution + flowVector2) * 64.0);
            float c = mix(c1, c2, abs(ct1 - 0.5) * 2.0);

            gl_FragColor = vec4(c - sin(abs(n1) + abs(n2)), floor(c) + abs(n1), floor(c) + abs(n2), 1.0);
        }
    |]


view : Size -> Float -> Html msg
view resolution time =
    WebGL.toHtmlWith
        []
        [ A.width resolution.width
        , A.height resolution.height
        , A.class "shader-canvas"
        ]
        [ WebGL.entity
            vertexShader
            fragmentShader
            mesh
            { time = time
            , resolution = vec2 (toFloat resolution.width) (toFloat resolution.height)
            }
        ]
