module Page.Counter exposing (Model, Msg, init, update, view)

{-| Me counter page!
-}

import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)


-- MODEL --


type alias Model =
    { counter : Int }


init : Model
init =
    Model 0



-- VIEW --


view : Model -> Html Msg
view model =
    let
        count =
            toString model.counter
    in
        div []
            [ div [] [ text "hi duuude got it hi from counteR!!!!" ]
            , div [] [ text "this is so much more interesting than hello world" ]
            , div []
                [ text "here is the current count: "
                , text count
                ]
            , div [] [ button [ onClick Increment ] [ text "+" ] ]
            , div [] [ button [ onClick Decrement ] [ text "-" ] ]
            ]


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
