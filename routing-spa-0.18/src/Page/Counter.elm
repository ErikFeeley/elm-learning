module Page.Counter exposing (Model, Msg, init, update, view)

{-| Me counter page!
-}

import Html exposing (..)


-- MODEL --


type alias Model =
    { counter : Int }


init : Model
init =
    Model 0



-- VIEW --


view : Model -> Html Msg
view model =
    div [] [ text "hi" ]


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | counter = model.counter + 1 }, Cmd.none )

        Decrement ->
            ( { model | counter = model.counter - 1 }, Cmd.none )
