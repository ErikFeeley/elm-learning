module Page.Sammich exposing (Model, Msg, init, update, view)

import Element exposing (Element, column, el, padding, row, spacing, text)
import Element.Input as Input



-- MODEL


type alias Model =
    { sammichs : Int }


init : Model
init =
    Model 1



-- VIEW


view : Model -> Element Msg
view model =
    row
        [ spacing 5, padding 5 ]
        [ column
            [ spacing 5, padding 5 ]
            [ el [] <| text <| String.fromInt model.sammichs
            , Input.button [] { onPress = Just MakeSammich, label = text "make sammich" }
            ]
        ]



--UPDATE


type Msg
    = MakeSammich


update : Msg -> Model -> Model
update msg model =
    case msg of
        MakeSammich ->
            { model | sammichs = model.sammichs + 1 }
