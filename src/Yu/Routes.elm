module Yu.Routes exposing (..)

import Navigation exposing (Location)
import UrlParser as Parser exposing (Parser, (</>), (<?>), top, s, stringParam)


type Route
    = Home
    | NotFound


route : Parser (Route -> a) a
route =
    Parser.oneOf
        [ Parser.map Home top
        ]


toString : Route -> String
toString route =
    case route of
        Home ->
            "/"

        _ ->
            "/404"


parseRoute : Location -> Route
parseRoute location =
    Parser.parsePath route location
        |> Maybe.withDefault NotFound
