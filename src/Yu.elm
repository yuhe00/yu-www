module Yu exposing (decodeData, getData, init, subscriptions, update, view)

import Array
import Browser
import Browser.Dom as Dom
import Browser.Events
import Browser.Navigation as Navigation exposing (Key)
import Html exposing (Html)
import Html.Attributes as A
import Http
import Json.Decode as Decode
import Random
import Task
import Time
import Url exposing (Url)
import Yu.Home as Home
import Yu.Model exposing (..)
import Yu.Routes as Routes exposing (Route(..))
import Yu.Work as Work


getData : Cmd Msg
getData =
    Http.get
        { url = "https://gist.githubusercontent.com/yuhe00/39e73c95492dcca1446f6f3c79c40d80/raw"
        , expect = Http.expectJson UpdateData decodeData
        }


decodeData : Decode.Decoder Data
decodeData =
    Decode.map2 Data
        (Decode.field "quotes" (Decode.list Decode.string))
        (Decode.field "available" Decode.bool)


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        model =
            { key = key
            , route = Routes.parseRoute url
            , resolution = { width = 1000, height = 1000 }
            , time = 0
            , data = Nothing
            , quote = Nothing
            }
    in
    ( model
    , Cmd.batch
        [ Task.attempt
            (\x ->
                case x of
                    Ok x_ ->
                        OnResolutionChange
                            { width = round x_.viewport.width
                            , height = round x_.viewport.height
                            }

                    _ ->
                        OnResolutionChange
                            model.resolution
            )
            Dom.getViewport
        , getData
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnUrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Navigation.load url
                    )

        OnLocationChange location ->
            ( { model | route = Routes.parseRoute location }, Cmd.none )

        OnResolutionChange resolution ->
            let
                -- This logic is based on styling CSS
                canvasResolution =
                    { width =
                        case resolution.width < 600 of
                            True ->
                                resolution.width

                            False ->
                                resolution.width - max 480 (round (0.3 * toFloat resolution.width))
                    , height =
                        case resolution.width < 600 of
                            True ->
                                480

                            False ->
                                resolution.height
                    }
            in
            ( { model | resolution = canvasResolution }, Cmd.none )

        GotoRoute route ->
            ( model, Navigation.pushUrl model.key (Routes.toString route) )

        UpdateTime deltaTime ->
            ( { model | time = model.time + deltaTime }, Cmd.none )

        UpdateData (Ok data) ->
            let
                quotes =
                    Array.fromList data.quotes

                generateQuoteCmd =
                    Random.generate
                        (SetQuote << (\x -> Array.get x quotes))
                        (Random.int 0 (Array.length quotes - 1))
            in
            ( { model | data = Just data }, generateQuoteCmd )

        UpdateData (Err _) ->
            ( { model | data = Nothing }, Cmd.none )

        SetQuote quote ->
            ( { model | quote = quote }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onAnimationFrameDelta Basics.identity |> Sub.map UpdateTime
        , Browser.Events.onResize
            (\x y ->
                OnResolutionChange
                    { width = x
                    , height = y
                    }
            )
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "Yu"
    , body =
        [ Html.div
            [ A.class "app" ]
            [ case model.route of
                Home ->
                    Home.view
                        model.resolution
                        (model.time / 1000.0)
                        model.quote
                        (Maybe.map .available model.data |> Maybe.withDefault False)

                Work ->
                    Work.view
                        model.resolution
                        (model.time / 1000.0)
                        model.quote
                        (Maybe.map .available model.data |> Maybe.withDefault False)

                NotFound ->
                    Html.div
                        [ A.class "page" ]
                        [ Html.text "404" ]
            ]
        ]
    }
