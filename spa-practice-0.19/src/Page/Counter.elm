module Page.Counter exposing (Model, Msg, init, update, view)

import Element exposing (Element, column, el, padding, row, spacing, text)
import Element.Input as Input



-- MODEL


type alias Model =
    { count : Int }


init : ( Model, Cmd Msg )
init =
    ( { count = 0 }, Cmd.none )



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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )

        Reset ->
            ( { model | count = 0 }, Cmd.none )
