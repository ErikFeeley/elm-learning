module Page.Form exposing (Model, Msg, init, update, view)

import Element exposing (Element, column, el, row, text)
import Element.Input as Input



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


type alias Validation =
    { condition : Bool, errorMessage : String }


validatePassword : String -> String -> List String
validatePassword pass passAgain =
    let
        validations =
            [ Validation (pass /= passAgain) "Passwords must match"
            , Validation (String.length pass == 0) "You must enter a password"
            , Validation (String.length passAgain == 0) "You must confirm your password"
            ]
    in
    validations
        |> List.filterMap
            (\val ->
                if val.condition then
                    Just val.errorMessage

                else
                    Nothing
            )


init : Model
init =
    Model "" "" ""



-- VIEW


view : Model -> Element Msg
view model =
    row []
        [ column [ Element.width Element.fill ]
            [ viewInput "name" model.name NameUpdated
            , viewInput "Password" model.password PasswordUpdated
            , viewInput "Password Again" model.passwordAgain PasswordAgainUpdated
            , viewValidation model
            ]
        ]


viewInput : String -> String -> (String -> msg) -> Element msg
viewInput p v toMsg =
    Input.text []
        { onChange = toMsg
        , text = v
        , placeholder = Just (Input.placeholder [] <| text p)
        , label = Input.labelLeft [] <| text "label"
        }


viewValidation : Model -> Element msg
viewValidation model =
    validatePassword model.password model.passwordAgain
        |> (\x ->
                column [] <| List.map (\y -> el [] <| text y) x
           )



-- UPDATE


type Msg
    = NameUpdated String
    | PasswordUpdated String
    | PasswordAgainUpdated String


update : Msg -> Model -> Model
update msg model =
    case msg of
        NameUpdated name ->
            { model | name = name }

        PasswordUpdated password ->
            { model | password = password }

        PasswordAgainUpdated passwordAgain ->
            { model | passwordAgain = passwordAgain }
