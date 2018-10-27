module Yu exposing (..)

import AnimationFrame
import Array
import Html exposing (Html)
import Html.Attributes as A
import Http
import Json.Decode as Decode
import Navigation exposing (Location)
import Random
import Task
import Time
import Window exposing (Size)
import Yu.Home as Home
import Yu.Work as Work
import Yu.Model exposing (..)
import Yu.Routes as Routes exposing (Route(..))


getData : Http.Request Data
getData =
    Http.get
        "https://gist.githubusercontent.com/yuhe00/39e73c95492dcca1446f6f3c79c40d80/raw/yu-www-data.json"
        decodeData


decodeData : Decode.Decoder Data
decodeData =
    Decode.map2 Data
        (Decode.field "quotes" (Decode.list Decode.string))
        (Decode.field "available" Decode.bool)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        model =
            { route = Routes.parseRoute location
            , resolution = Size 1000 1000
            , time = 0
            , data = Nothing
            , quote = Nothing
            }
    in
        model
            ! [ Task.perform OnResolutionChange Window.size
              , Http.send UpdateData getData
              ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            { model | route = Routes.parseRoute location } ! []

        OnResolutionChange resolution ->
            let
                -- This logic is based on styling CSS
                canvasResolution =
                    { width =
                        case resolution.width < 600 of
                            True ->
                                resolution.width

                            False ->
                                resolution.width - (max 480 (round (0.3 * toFloat resolution.width)))
                    , height =
                        case resolution.width < 600 of
                            True ->
                                480

                            False ->
                                resolution.height
                    }
            in
                { model | resolution = canvasResolution } ! []

        GotoRoute route ->
            model ! [ Navigation.newUrl (Routes.toString route) ]

        UpdateTime deltaTime ->
            { model | time = model.time + deltaTime } ! []

        UpdateData (Ok data) ->
            let
                quotes =
                    Array.fromList data.quotes

                generateQuoteCmd =
                    Random.generate
                        (SetQuote << flip Array.get quotes)
                        (Random.int 0 ((Array.length quotes) - 1))
            in
                { model | data = Just data } ! [ generateQuoteCmd ]

        UpdateData (Err _) ->
            { model | data = Nothing } ! []

        SetQuote quote ->
            { model | quote = quote } ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs Basics.identity |> Sub.map UpdateTime
        , Window.resizes OnResolutionChange
        ]


view : Model -> Html Msg
view model =
    Html.div
        [ A.class "app" ]
        [ case model.route of
            Home ->
                Home.view
                    model.resolution
                    (Time.inSeconds model.time)
                    model.quote
                    (Maybe.map .available model.data |> Maybe.withDefault False)

            Work ->
                Work.view
                    model.resolution
                    (Time.inSeconds model.time)
                    model.quote
                    (Maybe.map .available model.data |> Maybe.withDefault False)

            NotFound ->
                Html.div
                    [ A.class "page" ]
                    [ Html.text "404" ]
        ]
