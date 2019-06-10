module Page.Http exposing (Model, Msg, init, update, view)

import ApplicationUser exposing (ApplicationUser, isAuthenticated)
import Browser.Navigation exposing (load)
import Element exposing (Element, text)
import Http
import Url.Builder exposing (relative)



-- MODEL


type Model
    = Failure
    | NotAllowed
    | Loading
    | Success String


init : ApplicationUser -> ( Model, Cmd Msg )
init applicationUser =
    if isAuthenticated applicationUser then
        ( Loading
        , Http.get
            { url = "https://elm-lang.org/assets/public-opinion.txt"
            , expect = Http.expectString GotText
            }
        )

    else
        ( NotAllowed, relative [ "form" ] [] |> load )



-- VIEW


view : Model -> Element Msg
view model =
    case model of
        Failure ->
            text "unable to load text"

        NotAllowed ->
            text "you cant put that there!"

        Loading ->
            text "loading text"

        Success textFromServer ->
            text textFromServer



-- UPDATE


type Msg
    = GotText (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )
