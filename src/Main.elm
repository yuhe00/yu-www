module Main exposing (..)

import Navigation
import Yu exposing (..)
import Yu.Model exposing (..)


main : Program Never Model Msg
main =
    Navigation.program
        OnLocationChange
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
