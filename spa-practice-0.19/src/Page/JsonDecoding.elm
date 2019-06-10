module Page.JsonDecoding exposing (Model, Msg, init, update, view)

import Element exposing (Element, column, image, row, text)
import Element.Input as Input
import Http
import Json.Decode exposing (Decoder, field, string)



-- MODEL


type Model
    = Failure
    | Loading
    | Success String


init : ( Model, Cmd Msg )
init =
    ( Loading, getRandomCatGif )



-- VIEW


view : Model -> Element Msg
view model =
    case model of
        Failure ->
            row []
                [ column []
                    [ text "Failed to load"
                    , Input.button [] { onPress = Just MorePlease, label = text "Try again" }
                    ]
                ]

        Loading ->
            row []
                [ column []
                    [ text "loading..." ]
                ]

        Success url ->
            row []
                [ column []
                    [ Input.button [] { onPress = Just MorePlease, label = text "More Please" }
                    , image [] { src = url, description = "gifs" }
                    ]
                ]



-- UPDATE


type Msg
    = MorePlease
    | GotGif (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        MorePlease ->
            ( Loading, getRandomCatGif )

        GotGif result ->
            case result of
                Ok url ->
                    ( Success url, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- HTTP


getRandomCatGif : Cmd Msg
getRandomCatGif =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
        , expect = Http.expectJson GotGif gifDecoder
        }


gifDecoder : Decoder String
gifDecoder =
    field "data" (field "image_url" string)
