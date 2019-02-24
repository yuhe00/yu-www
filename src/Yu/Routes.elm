module Yu.Routes exposing (Route(..), parseRoute, routeParser, toString)

import Browser.Navigation exposing (Key)
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser)


type Route
    = Home
    | Work
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Work (Parser.s "work")
        ]


toString : Route -> String
toString route =
    case route of
        Home ->
            "/"

        Work ->
            "/work"

        _ ->
            "/404"


parseRoute : Url -> Route
parseRoute url =
    Parser.parse routeParser url
        |> Maybe.withDefault NotFound
