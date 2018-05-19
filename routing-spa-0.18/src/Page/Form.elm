module Page.Form exposing (..)

import Html exposing (Html, div, input, text)
import Html.Events exposing (onInput)
import String


-- MODEL --


type alias Model =
    { input : String
    , reversed : String
    }


init : Model
init =
    Model "" ""



-- VIEW --


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ input [ onInput SetInput ] []
            , div []
                [ text "echo: "
                , text model.input
                ]
            , div []
                [ text "reversed: "
                , text model.reversed
                ]
            ]
        ]



-- UPDATE --


type Msg
    = SetInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetInput str ->
            ( { model | input = str, reversed = String.reverse str }, Cmd.none )
