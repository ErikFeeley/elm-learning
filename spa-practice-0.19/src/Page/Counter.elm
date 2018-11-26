module Page.Counter exposing (Model, Msg, init, update, view)

import Element exposing (Element, column, el, padding, row, spacing, text)
import Element.Input as Input



-- MODEL


type alias Model =
    { count : Int }


init : Model
init =
    Model 0



-- VIEW


view : Model -> Element Msg
view model =
    row
        [ spacing 5, padding 5 ]
        [ column
            [ spacing 5, padding 5 ]
            [ el [] <| text <| String.fromInt model.count
            , Input.button [] { onPress = Just Increment, label = text "Increment" }
            , Input.button [] { onPress = Just Decrement, label = text "Decrement" }
            , Input.button [] { onPress = Just Reset, label = text "Reset" }
            ]
        ]



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }

        Reset ->
            { model | count = 0 }
