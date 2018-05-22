module Page.Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String


-- MODEL --


type alias Model =
    { input : String }


init : Model
init =
    Model ""



-- VIEW --


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ input [ onInput SetStr, value model.input ] []
            , div []
                [ text "echo: "
                , text model.input
                ]
            , div []
                [ text "reversed: "
                , text (String.reverse model.input)
                ]
            , div [] [ button [ onClick Reset ] [ text "Reset" ] ]
            ]
        ]



-- UPDATE --


type Msg
    = SetStr String
    | Reset


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetStr str ->
            { model | input = str }
                |> withoutCmd

        Reset ->
            ( { model | input = "" }, Cmd.none )



{-
   eh kinda fun i guess
   so instead of doing

   ( { model | input = str, reversed = String.reverse str }, Cmd.none )
   you can do
   { model | input = str, reversed = String.reverse str }
        |> withoutCmd
-}


withoutCmd : Model -> ( Model, Cmd Msg )
withoutCmd model =
    ( model, Cmd.none )
