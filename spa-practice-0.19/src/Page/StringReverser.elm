module Page.StringReverser exposing (Model, Msg, init, update, view)

import Element exposing (Element, column, el, row, text)
import Element.Input as Input



-- MODEL


type alias Model =
    { theActualString : String
    , theReversedString : String
    }


init : Model
init =
    { theActualString = ""
    , theReversedString = ""
    }



-- VIEW


view : Model -> Element Msg
view model =
    row [ Element.centerX ]
        [ column []
            [ el [] <| text <| "you input: " ++ model.theActualString
            , el [] <| text <| "reversed: " ++ model.theReversedString
            , Input.text []
                { onChange = Input
                , text = model.theActualString
                , placeholder = Nothing
                , label = Input.labelLeft [] <| text "label"
                }
            ]
        ]



-- UPDATE


type Msg
    = Input String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input str ->
            { model
                | theActualString = str
                , theReversedString = String.reverse str
            }
