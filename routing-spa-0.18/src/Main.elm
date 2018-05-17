module Main exposing (..)

import Page.Home as Home
import Page.NotFound as NotFound
import Navigation exposing (Location)
import Html exposing (..)
import Route exposing (Route)


type Page
    = Blank
    | Home
    | NotFound


type PageState
    = Loaded Page
    | TransitioningFrom Page



-- MODEL --


type alias Model =
    { pageState : PageState }


init : Location -> ( Model, Cmd Msg )
init location =
    setRoute (Route.fromLocation location)
        { pageState = Loaded initialPage }


initialPage : Page
initialPage =
    Blank



-- VIEW --


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage False page

        TransitioningFrom page ->
            viewPage True page


viewPage : Bool -> Page -> Html Msg
viewPage isLoading page =
    case page of
        Blank ->
            Html.text ""

        Home ->
            Home.view

        NotFound ->
            NotFound.view



-- UPDATE --


type Msg
    = SetRoute (Maybe Route)


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | pageState = Loaded NotFound }, Cmd.none )

        Just Route.Home ->
            ( { model | pageState = Loaded Home }, Cmd.none )

        Just Route.Root ->
            ( model, Route.modifyUrl Route.Home )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    case ( msg, page ) of
        ( SetRoute route, _ ) ->
            setRoute route model



-- MAIN --


main : Program Never Model Msg
main =
    Navigation.program (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
