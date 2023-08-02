module Main exposing (main)

import Browser
import Html exposing (Html, blockquote, button, cite, div, h2, p, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http exposing (Error, Expect)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import RemoteData exposing (WebData)
import Task


type alias Model =
    WebData Quote


type alias Quote =
    { author : String
    , source : String
    , quote : String
    , year : Int
    }


type Msg
    = FetchQuote
    | FetchedQuote Model


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }


init : () -> ( Model, Cmd Msg )
init () =
    ( RemoteData.NotAsked
    , Task.perform identity (Task.succeed FetchQuote)
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchQuote ->
            let
                getRandomQuote : Cmd Msg
                getRandomQuote =
                    Http.get
                        { url = "https://elm-lang.org/api/random-quotes"
                        , expect = response
                        }

                response : Expect Msg
                response =
                    Http.expectJson
                        (\result -> FetchedQuote (RemoteData.fromResult result))
                        quoteDecoder

                quoteDecoder : Decoder Quote
                quoteDecoder =
                    Decode.succeed Quote
                        |> Pipeline.required "author" Decode.string
                        |> Pipeline.required "source" Decode.string
                        |> Pipeline.required "quote" Decode.string
                        |> Pipeline.required "year" Decode.int
            in
            ( RemoteData.Loading, getRandomQuote )

        FetchedQuote remoteData ->
            ( remoteData, Cmd.none )


view : Model -> Html Msg
view model =
    let
        viewQuote : Html Msg
        viewQuote =
            case model of
                RemoteData.NotAsked ->
                    text ""

                RemoteData.Loading ->
                    text "Loading..."

                RemoteData.Failure _ ->
                    div []
                        [ button [ onClick FetchQuote ] [ text "Try Again!" ]
                        , p [] [ text "Loading a random quote failed." ]
                        ]

                RemoteData.Success quote ->
                    let
                        author : String
                        author =
                            " by "
                                ++ quote.author
                                ++ " ("
                                ++ String.fromInt quote.year
                                ++ ")"
                    in
                    div []
                        [ button [ onClick FetchQuote, style "display" "block" ]
                            [ text "More Please!" ]
                        , blockquote [] [ text quote.quote ]
                        , p [ style "text-align" "right" ]
                            [ text "— "
                            , cite [] [ text quote.source ]
                            , text author
                            ]
                        ]
    in
    div []
        [ h2 [] [ text "Random Quotes" ]
        , viewQuote
        ]
