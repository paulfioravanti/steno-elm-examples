module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Html exposing (Html, button, div, h1, text)
import Html.Events exposing (onClick)
import Random


type alias Model =
    { dieValue : Int }


type Msg
    = Roll
    | Rolled Int


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
    ( { dieValue = 1 }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate Rolled (Random.int 1 6) )

        Rolled value ->
            ( { dieValue = value }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        dieFaces : Dict Int String
        dieFaces =
            Dict.fromList
                [ ( 1, "⚀" )
                , ( 2, "⚁" )
                , ( 3, "⚂" )
                , ( 4, "⚃" )
                , ( 5, "⚄" )
                , ( 6, "⚅" )
                ]

        dieFace : String
        dieFace =
            dieFaces
                |> Dict.get model.dieValue
                |> Maybe.withDefault "□"
    in
    div []
        [ h1 [] [ text dieFace ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
