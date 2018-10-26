module Page.StringReverser exposing (Model, Msg, init, update, view)

import Element exposing (Element, column, el, row, text)
import Element.Input as Input



-- MODEL


type alias Model =
    { theActualString : String
    , theReversedString : String
    }


init : ( Model, Cmd Msg )
init =
    ( { theActualString = ""
      , theReversedString = ""
      }
    , Cmd.none
    )



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
            , Element.link [] { url = "/", label = text "counter" }
            ]
        ]



-- UPDATE


type Msg
    = Input String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input str ->
            ( { model
                | theActualString = str
                , theReversedString = String.reverse str
              }
            , Cmd.none
            )
