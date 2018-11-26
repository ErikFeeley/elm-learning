module Page.Http exposing (Model, Msg, init, update, view)

import Element exposing (Element, column, el, row, text)
import Http



-- MODEL


type Model
    = Failure
    | Loading
    | Success String


init : ( Model, Cmd Msg )
init =
    ( Loading
    , Http.get
        { url = "https://elm-lang.org/assets/public-opinion.txt"
        , expect = Http.expectString GotText
        }
    )



-- VIEW


view : Model -> Element Msg
view model =
    case model of
        Failure ->
            text "unable to load text"

        Loading ->
            text "loading text"

        Success textFromServer ->
            text textFromServer



-- UPDATE


type Msg
    = GotText (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )
