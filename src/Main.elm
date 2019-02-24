module Main exposing (..)

import Browser
import Yu exposing (..)
import Yu.Model exposing (..)


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , onUrlChange = OnLocationChange
        , onUrlRequest = OnUrlRequest
        }
