port module Page.LocalStorage exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (Element, column, row, text)
import Element.Input as Input



-- MODEL


type alias Model =
    String


init : ( Model, Cmd Msg )
init =
    ( "", Cmd.none )



-- VIEW


view : Model -> Element Msg
view model =
    row []
        [ column [ Element.width Element.fill ]
            [ text "hi"
            , Input.text []
                { onChange = UserTyped
                , text = model
                , placeholder = Nothing
                , label = Input.labelLeft [] <| text "local storage"
                }
            , Input.button []
                { onPress = Just GotSave, label = text "Save" }
            , Input.button []
                { onPress = Just LoadStarted, label = text "Load" }
            ]
        ]



--UPDATE


type Msg
    = UserTyped String
    | GotSave
    | LoadStarted
    | LoadCompleted String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserTyped content ->
            ( content, Cmd.none )

        GotSave ->
            ( model, saveText model )

        LoadStarted ->
            ( model, loadText () )

        LoadCompleted content ->
            ( content, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    textLoaded LoadCompleted


port saveText : String -> Cmd msg


port loadText : () -> Cmd msg


port textLoaded : (String -> msg) -> Sub msg
