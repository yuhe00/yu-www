module Yu.Home exposing (..)

import Array exposing (Array)
import Html exposing (Html)
import Html.Attributes as A
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector2 as Vec2 exposing (vec2, Vec2)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import WebGL exposing (Mesh, Shader)
import Window exposing (Size)


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

        float PI = 3.14;

        float rand(vec2 c) {
          return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
        }

        float noise(vec2 p, float freq) {
          float unit = resolution.x / freq;
          vec2 ij = floor(p/unit);
          vec2 xy = mod(p,unit)/unit;
          //xy = 3.*xy*xy-2.*xy*xy*xy;
          xy = .5*(1.-cos(PI*xy));
          float a = rand((ij+vec2(0.,0.)));
          float b = rand((ij+vec2(1.,0.)));
          float c = rand((ij+vec2(0.,1.)));
          float d = rand((ij+vec2(1.,1.)));
          float x1 = mix(a, b, xy.x);
          float x2 = mix(c, d, xy.x);
          return mix(x1, x2, xy.y);
        }

        float pNoise(vec2 p, int res) {
          float persistance = .5;
          float n = 0.;
          float normK = 0.;
          float f = 4.;
          float amp = 1.;
          int iCount = 0;
          for (int i = 0; i<50; i++){
            n+=amp*noise(p, f);
            f*=2.;
            normK+=amp;
            amp*=persistance;
            if (iCount == res) break;
            iCount++;
          }
          float nf = n/normK;
          return nf*nf*nf*nf;
        }

        float getTexture(vec2 uv) {
          float min = min(resolution.x, resolution.y);
          float max = max(resolution.x, resolution.y);
          float xf = resolution.x <= resolution.y ? (min / max) : 1.0;
          float yf = resolution.y <= resolution.x ? (min / max) : 1.0;
          return cos(uv.x * xf) + sin(uv.y * yf);
        }

        void main () {
            float time = time + 20.0;

            vec2 uv1 = gl_FragCoord.xy + vec2(0.0, -time * 100.0);
            vec2 uv2 = gl_FragCoord.yx + vec2(0.0, -time * 100.0);
            float n1 = pNoise(uv1, 100);
            float n2 = pNoise(uv2, 100);
            // float r = pNoise(10.0 * gl_FragCoord.xy + vec2(time * 300.0, -time * 300.0 * n1 * 1.0), 1000);
            // float g = pNoise(10.0 * gl_FragCoord.xy + vec2(time * 300.0, -time * 300.0 * n1 * 1.0), 100);
            // float b = pNoise(10.0 * gl_FragCoord.xy + vec2(time * 300.0, -time * 300.0 * n1 * 1.0), 10);

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

            float x = cos(n1 * gl_FragCoord.y) * 0.005 + sin(gl_FragCoord.x * sin(n2)) - 0.5;
            // gl_FragColor = vec4(vec3(x), 1.0);
            gl_FragColor = vec4(c - sin(n1 + n2), floor(c) + n1, floor(c) + n2, 1.0);
        }
    |]


view3d : Size -> Float -> Html msg
view3d resolution time =
    WebGL.toHtml
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


view : Size -> Float -> Maybe String -> Bool -> Html msg
view resolution time quote available =
    Html.div
        [ A.class "home-container" ]
        [ Html.div
            [ A.class "home-splash-panel" ]
            [ view3d resolution time ]
        , Html.div
            [ A.class "home-about-panel" ]
            [ Html.p
                []
                [ Html.em [] [ Html.text "Yu He" ]
                , Html.text " — Creative Technologist 💖"
                , Html.br [] []
                , Html.span
                    [ A.class "small" ]
                    (case quote of
                        Just quote ->
                            [ Html.text "\""
                            , Html.text quote
                            , Html.text "\""
                            ]

                        Nothing ->
                            []
                    )
                ]
            , Html.p
                []
                [ Html.text "What is art? A "
                , Html.span [ A.class "home-about-em" ] [ Html.text "deliberate act" ]
                , Html.text " of human expression? A "
                , Html.span [ A.class "home-about-em" ] [ Html.text "snapshot" ]
                , Html.text " of the continuum of our common consciousness? Or a "
                , Html.span [ A.class "home-about-em" ] [ Html.text "peek" ]
                , Html.text " into the fabric of existence itself? No clue; I just like to make stuff 😎"
                ]
            , Html.p
                [ A.style [ ( "font-size", "0.8em" ), ( "color", "#e88" ) ] ]
                [ Html.text "Equipped with a broad set of skills in a wide range of fields, including computer graphics, mathematics, AI, hardware, manufacturing and game design, I enjoy working on creating immersive, memorable experiences that make an impact." ]
            , Html.p
                [ A.style [ ( "font-size", "0.8em" ), ( "color", "#e88" ) ] ]
                [ Html.text "Currently "
                , case available of
                    True ->
                        Html.span [ A.class "work-available" ] [ Html.text "available" ]

                    False ->
                        Html.span [ A.class "work-unavailable" ] [ Html.text "unavailable" ]
                , Html.text " for contract work."
                ]
            , Html.p
                []
                [ Html.ul
                    [ A.class "links" ]
                    [ Html.li []
                        [ Html.a
                            [ A.href "https://www.linkedin.com/in/yuhe00", A.class "icon" ]
                            [ Html.span [ A.class "fa fa-linkedin", A.attribute "aria-hidden" "true" ] [] ]
                        ]
                    , Html.li []
                        [ Html.a
                            [ A.href "https://github.com/yuhe00", A.class "icon" ]
                            [ Html.span [ A.class "fa fa-github", A.attribute "aria-hidden" "true" ] [] ]
                        ]
                    , Html.li []
                        [ Html.a
                            [ A.href "https://instagram.com/yuhe7581", A.class "icon" ]
                            [ Html.span [ A.class "fa fa-instagram", A.attribute "aria-hidden" "true" ] [] ]
                        ]
                    , Html.li []
                        [ Html.a
                            [ A.href "https://twitter.com/yuhe00", A.class "icon" ]
                            [ Html.span [ A.class "fa fa-twitter", A.attribute "aria-hidden" "true" ] [] ]
                        ]
                    , Html.li []
                        [ Html.a
                            [ A.href "https://inconspicuous.itch.io", A.class "icon" ]
                            [ Html.span [ A.class "fa fa-gamepad", A.attribute "aria-hidden" "true" ] [] ]
                        ]
                    , Html.li []
                        [ Html.a
                            [ A.href "https://www.youtube.com/channel/UCBh4RZgQqEbfvO5KvDV0Hzw", A.class "icon" ]
                            [ Html.span [ A.class "fa fa-youtube", A.attribute "aria-hidden" "true" ] [] ]
                        ]
                    ]
                ]
            , Html.p
                []
                [ Html.ul
                    [ A.class "links" ]
                    [ Html.li [] [ Html.a [ A.href "/files/cv.pdf", A.target "_blank" ] [ Html.text "CV" ] ]
                    , Html.li [] [ Html.a [ A.href "mailto:yu.he@inconspicuous.no" ] [ Html.text "yu.he@inconspicuous.no" ] ]
                    ]
                ]
            ]
        ]
