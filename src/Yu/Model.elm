module Yu.Model exposing (..)

import Http
import Navigation exposing (Location)
import Time exposing (Time)
import Window exposing (Size)
import Yu.Routes exposing (Route(..), parseRoute)


type alias Model =
    { route : Route
    , resolution : Size
    , time : Time
    , data : Maybe Data
    , quote : Maybe String
    }

type alias Data =
    { quotes : List String
    , available : Bool
    }

type Msg
    = OnLocationChange Location
    | OnResolutionChange Size
    | GotoRoute Route
    | UpdateTime Time
    | UpdateData (Result Http.Error Data)
    | SetQuote (Maybe String)
