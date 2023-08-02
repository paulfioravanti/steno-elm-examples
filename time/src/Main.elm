module Main exposing (main)

import Browser
import Html exposing (Html, h1, text)
import Task
import Time exposing (Posix, Zone)


type alias Model =
    { time : Posix
    , zone : Zone
    }


type Msg
    = FetchedZone Zone
    | Tick Posix


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init () =
    ( { time = Time.millisToPosix 0
      , zone = Time.utc
      }
    , Task.perform FetchedZone Time.here
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchedZone zone ->
            ( { model | zone = zone }, Cmd.none )

        Tick time ->
            ( { model | time = time }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick


view : Model -> Html Msg
view { time, zone } =
    let
        hour : String
        hour =
            toHumanTime (Time.toHour zone time)

        minute : String
        minute =
            toHumanTime (Time.toMinute zone time)

        second : String
        second =
            toHumanTime (Time.toSecond zone time)

        toHumanTime : Int -> String
        toHumanTime timeInt =
            timeInt
                |> String.fromInt
                |> String.padLeft 2 '0'
    in
    h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
