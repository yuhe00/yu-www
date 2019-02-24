module Yu.Model exposing (Data, Flags, Model, Msg(..))

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Http
import Url exposing (Url)
import Yu.Routes exposing (Route(..), parseRoute)
import Yu.Types exposing (Size)


type alias Flags =
    {}


type alias Model =
    { key : Key
    , route : Route
    , resolution : Size
    , time : Float -- Time in millis
    , data : Maybe Data
    , quote : Maybe String
    }


type alias Data =
    { quotes : List String
    , available : Bool
    }


type Msg
    = OnLocationChange Url
    | OnUrlRequest UrlRequest
    | OnResolutionChange Size
    | GotoRoute Route
    | UpdateTime Float
    | UpdateData (Result Http.Error Data)
    | SetQuote (Maybe String)
