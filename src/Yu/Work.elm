module Yu.Work exposing (Project, projects, view, viewLink, viewProject, viewProjects, viewSidePanelWork)

import Html exposing (Html)
import Html.Attributes as A
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Yu.Splash as Splash
import Yu.Types exposing (Size)


type alias Project =
    { name : String
    , client : String
    , shortDescription : String
    , image : String
    , links : List ( String, String )
    }


projects : List Project
projects =
    [ { name = "Jiggy Bear in Outer Space"
      , client = "Inconspicuous Creations"
      , shortDescription = "Arcade-style mobile game for iOS devices."
      , image = "/images/jiggly-bear-in-outer-space.png"
      , links = [ ( "YouTube", "https://www.youtube.com/watch?v=Sqn_4oJLr9Q" ) ]
      }
    , { name = "Heroes in the Fast Lane"
      , client = "Inconspicuous Creations"
      , shortDescription = "Turn-based multiplayer life simulation game."
      , image = "/images/heroes-in-the-fast-lane.png"
      , links = [ ( "YouTube", "https://www.youtube.com/watch?v=WDQc3If_3H4" ) ]
      }
    , { name = "Santa's Workshop"
      , client = "Inconspicuous Creations"
      , shortDescription = "Christmas-themed 'idle'-game for the browser."
      , image = "/images/santas-workshop.png"
      , links = [ ( "Web", "https://yuhe00.github.io/santas-workshop" ) ]
      }
    , { name = "UE4 customizations for broadcast"
      , client = "The Future Group"
      , shortDescription = "Worked closely with TV/media-creators and VFX artists to make Unreal Engine 4 more suitable for TV- and broadcast-workflow."
      , image = "/images/tfg.png"
      , links = [ ( "Web", "https://www.futureuniverse.com" ) ]
      }
    , { name = "AJA plugin for UE4"
      , client = "The Future Group"
      , shortDescription = "AJA plugin for UE4 that interfaces with their KONA-series SDI cards."
      , image = "/images/tfg-aja.png"
      , links = [ ( "Web", "https://www.futureuniverse.com" ) ]
      }
    , { name = "Xsens MVN plugin for UE4"
      , client = "The Future Group"
      , shortDescription = "Plugin for UE4's animation system that interfaces with Xsens' IMU-based motion capture suits."
      , image = "/images/tfg-xsens.png"
      , links = [ ( "Web", "https://www.futureuniverse.com" ) ]
      }
    , { name = "Ghosts in a Dungeon"
      , client = "Inconspicuous Creations"
      , shortDescription = "A game entry for the yearly 'NM i Gameplay'-competition. The theme was 'fear'."
      , image = "/images/ghosts-in-a-dungeon.png"
      , links =
            [ ( "YouTube", "https://www.youtube.com/watch?v=1n9ZCJTNM00" )
            , ( "Web", "https://inconspicuous.itch.io/ghosts-in-a-dungeon" )
            ]
      }
    , { name = "Floq"
      , client = "Blank"
      , shortDescription = "Internal systems for the consultancy agency I worked at. In particular, I worked on the staffing system and PostgreSQL database."
      , image = "/images/floq.png"
      , links = []
      }
    , { name = "Folq"
      , client = "Blank"
      , shortDescription = "Helped develop the first iteration of Folq - an online portal for finding and hiring independent IT consultants in Norway."
      , image = "/images/folq.png"
      , links = [ ( "Web", "https://www.folq.no" ) ]
      }
    , { name = "Storebrand Pension"
      , client = "Blank, Storebrand"
      , shortDescription = "Frontend web development on a variety of forms and wizards, with focus on user-friendliness and security."
      , image = "/images/storebrand.png"
      , links = [ ( "Web", "https://www.storebrand.no" ) ]
      }
    , { name = "reMarkable store"
      , client = "Blank, reMarkable"
      , shortDescription = "Part of the team that rapidly built the first iteration of this e-commerce site just in time for launch."
      , image = "/images/remarkable.png"
      , links = [ ( "Web", "https://remarkable.com/store" ) ]
      }
    , { name = "JVR"
      , client = "Blank"
      , shortDescription = "An experimental VR game where you milk cows."
      , image = "/images/jvr.png"
      , links =
            [ ( "YouTube", "https://www.youtube.com/watch?v=Gecajm2OPo8" )
            , ( "Web", "https://github.com/yuhe00/Juragard" )
            ]
      }
    , { name = "Never Odd or Even"
      , client = "Inconspicuous Creations"
      , shortDescription = "A game entry for the yearly 'NM i Gameplay'-competition. The theme was 'symmetry'."
      , image = "/images/never-odd-or-even.png"
      , links =
            [ ( "YouTube", "https://www.youtube.com/watch?v=mR2HdR3_eVQ" )
            , ( "Web", "https://inconspicuous.itch.io/never-odd-or-even" )
            ]
      }
    , { name = "Engineerium Energy Lab"
      , client = "Expology, Aker Solutions"
      , shortDescription = "Rebuilt the backend high-score system and remade the two games \"Nuclear\" & \"Oil & Gas\"."
      , image = "/images/engineerium.png"
      , links = [ ( "Web", "https://www.engineerium.no" ) ]
      }
    , { name = "Det Norske Teatret"
      , client = "Expology, Det Norske Teatret"
      , shortDescription = "An installation with miniature scenes. Uses eye tracking to light up text on the wall based on where people are looking."
      , image = "/images/dnt.png"
      , links = []
      }
    , { name = "Waveshift"
      , client = "Inconspicuous Creations"
      , shortDescription = "A game entry for the yearly 'NM i Gameplay'-competition. The theme was 'arcade'."
      , image = "/images/waveshift.png"
      , links = [ ( "YouTube", "https://www.youtube.com/watch?v=vh1-oQncMl8" ) ]
      }
    , { name = "Chemotherapy"
      , client = "Logic Interactive"
      , shortDescription = "A game where you use your hands to mix chemicals and cure cancer. Supports controls by Leap Motion."
      , image = "/images/kfchemo.png"
      , links = [ ( "Web", "https://www.kreftforeningen.no" ) ]
      }
    , { name = "Targeted Medicine / DNA"
      , client = "Logic Interactive"
      , shortDescription = "A game where you find mutations in DNA and cure them by administering the right kind of medicine. The physical structure consists of 2x ~900 controllable RGB LEDs."
      , image = "/images/kfdna.png"
      , links = [ ( "Web", "https://www.kreftforeningen.no" ) ]
      }
    ]


viewLink : ( String, String ) -> Html msg
viewLink ( name, url ) =
    let
        faName =
            case name of
                "YouTube" ->
                    "fab fa-youtube"

                _ ->
                    "fas fa-external-link-alt"
    in
    Html.a
        [ A.class "project-link", A.href url ]
        [ Html.i [ A.class faName ] [] ]


viewProject : Project -> Html msg
viewProject project =
    Html.li
        [ A.class "work-panel-project" ]
        [ Html.div
            []
            [ Html.span [ A.class "work-em" ] [ Html.text project.name ]
            , Html.span [] (List.map viewLink project.links)
            , Html.div
                [ A.class "small"
                , A.style "font-size" "0.7em"
                , A.style "color" "#88e"
                ]
                [ Html.text project.client ]
            , Html.p [] [ Html.text project.shortDescription ]

            -- , Html.p [ A.class "small" ]
            --     ((Html.text "In collaboration with: ")
            --         :: (List.map Html.text [ project.client ])
            --     )
            ]
        , Html.img [ A.src project.image ] []
        ]


viewProjects : Html msg
viewProjects =
    Html.ul
        [ A.class "work-panel-projects" ]
        (List.map viewProject (List.reverse projects))


viewSidePanelWork : Maybe String -> Html msg
viewSidePanelWork quote =
    Html.div
        [ A.id "side-panel"
        , A.class "work-panel"
        ]
        [ Html.a
            [ A.class "home-about-work-link"
            , A.href "/#side-panel"
            ]
            [ Html.text "« Back" ]
        , Html.p
            []
            [ Html.em [] [ Html.text "Work" ]
            , Html.text " — Stuff I've worked on"
            ]
        , viewProjects
        , Html.p
            [ A.class "work-footer" ]
            [ Html.text "Like what you see?"
            , Html.br [] []
            , Html.a
                [ A.href "mailto:yu.he@inconspicuous.no" ]
                [ Html.text "Contact me" ]
            , Html.text " to find out what I could do for you."
            , Html.br [] []
            , Html.br [] []
            , Html.a
                [ A.href "/#side-panel" ]
                [ Html.text "« Back" ]
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
        , viewSidePanelWork quote
        ]
