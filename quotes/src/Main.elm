module Main exposing (main)

import Browser
import Html exposing (Html, blockquote, button, cite, div, h2, p, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http exposing (Error)
import Json.Decode as Decode exposing (Decoder)
import Task


type Model
    = NotRequested
    | Requesting
    | Failure Error
    | Success Quote


type alias Quote =
    { author : String
    , source : String
    , quote : String
    , year : Int
    }


type Msg
    = FetchQuote
    | FetchedQuote (Result Error Quote)


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
    ( NotRequested
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
                        , expect = Http.expectJson FetchedQuote quoteDecoder
                        }

                quoteDecoder : Decoder Quote
                quoteDecoder =
                    Decode.map4 Quote
                        (Decode.field "author" Decode.string)
                        (Decode.field "source" Decode.string)
                        (Decode.field "quote" Decode.string)
                        (Decode.field "year" Decode.int)
            in
            ( Requesting, getRandomQuote )

        FetchedQuote result ->
            case result of
                Ok quote ->
                    ( Success quote, Cmd.none )

                Err error ->
                    ( Failure error, Cmd.none )


view : Model -> Html Msg
view model =
    let
        viewQuote : Html Msg
        viewQuote =
            case model of
                NotRequested ->
                    text ""

                Requesting ->
                    text "Loading..."

                Failure _ ->
                    div []
                        [ button [ onClick FetchQuote ] [ text "Try Again" ]
                        , p [] [ text "Loading a random quote failed." ]
                        ]

                Success quote ->
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
