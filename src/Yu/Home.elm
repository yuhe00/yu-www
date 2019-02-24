module Yu.Home exposing (view, viewSidePanelAbout)

import Html exposing (Html)
import Html.Attributes as A
import Yu.Splash as Splash
import Yu.Types exposing (Size)


viewSidePanelAbout : Maybe String -> Bool -> Html msg
viewSidePanelAbout quote available =
    Html.div
        [ A.id "side-panel"
        , A.class "home-about-panel"
        ]
        [ Html.a
            [ A.class "home-about-work-link"
            , A.href "/work#side-panel"
            ]
            [ Html.text "Work »" ]
        , Html.p
            []
            [ Html.em [] [ Html.text "Yu He" ]
            , Html.text " — Creative Technologist 💖"
            , Html.br [] []
            , Html.span
                [ A.class "small" ]
                (case quote of
                    Just quote_ ->
                        [ Html.text "\""
                        , Html.text quote_
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
            [ A.style "font-size" "0.8em"
            , A.style "color" "#e88"
            ]
            [ Html.text "Equipped with a broad set of skills in a wide range of fields, including computer graphics, mathematics, AI, hardware, manufacturing and game design, I enjoy working with passionate people to create immersive, memorable experiences that make an impact." ]
        , Html.p
            [ A.style "font-size" "0.8em"
            , A.style "color" "#e88"
            ]
            [ Html.text "Working on an interesting project? "
            , Html.a
                [ A.class "no-underline"
                , A.href "mailto:yu.he@inconspicuous.no"
                ]
                [ Html.span
                    [ A.class "work-available" ]
                    [ Html.text "Get in touch!" ]
                ]
            ]
        , Html.p
            []
            [ Html.ul
                [ A.class "links" ]
                [ Html.li []
                    [ Html.a
                        [ A.href "https://www.linkedin.com/in/yuhe00", A.class "icon" ]
                        [ Html.span [ A.class "fab fa-linkedin", A.attribute "aria-hidden" "true" ] [] ]
                    ]
                , Html.li []
                    [ Html.a
                        [ A.href "https://github.com/yuhe00", A.class "icon" ]
                        [ Html.span [ A.class "fab fa-github", A.attribute "aria-hidden" "true" ] [] ]
                    ]
                , Html.li []
                    [ Html.a
                        [ A.href "https://instagram.com/yuhe7581", A.class "icon" ]
                        [ Html.span [ A.class "fab fa-instagram", A.attribute "aria-hidden" "true" ] [] ]
                    ]
                , Html.li []
                    [ Html.a
                        [ A.href "https://twitter.com/yuhe00", A.class "icon" ]
                        [ Html.span [ A.class "fab fa-twitter", A.attribute "aria-hidden" "true" ] [] ]
                    ]
                , Html.li []
                    [ Html.a
                        [ A.href "https://inconspicuous.itch.io", A.class "icon" ]
                        [ Html.span [ A.class "fas fa-gamepad", A.attribute "aria-hidden" "true" ] [] ]
                    ]
                , Html.li []
                    [ Html.a
                        [ A.href "https://www.youtube.com/channel/UCBh4RZgQqEbfvO5KvDV0Hzw", A.class "icon" ]
                        [ Html.span [ A.class "fab fa-youtube", A.attribute "aria-hidden" "true" ] [] ]
                    ]
                ]
            ]
        , Html.p
            []
            [ Html.ul
                [ A.class "links" ]
                [ Html.li
                    []
                    [ Html.a
                        [ A.href "/files/cv.pdf", A.target "_blank" ]
                        [ Html.text "CV" ]
                    ]
                , Html.li
                    []
                    [ Html.a
                        [ A.href "mailto:yu.he@inconspicuous.no" ]
                        [ Html.text "yu.he@inconspicuous.no" ]
                    ]
                ]
            ]
        ]


view : Size -> Float -> Maybe String -> Bool -> Html msg
view resolution time quote available =
    Html.div
        [ A.class "home-container" ]
        [ Html.div
            [ A.class "home-splash-panel" ]
            [ Splash.view resolution time
            ]
        , viewSidePanelAbout quote available
        ]
