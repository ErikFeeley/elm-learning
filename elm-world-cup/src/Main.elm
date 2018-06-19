module Main exposing (..)

import Html exposing (Html, text)
import Navigation exposing (Location)
import Page.Errored as Errored exposing (PageLoadError)
import Page.Home as Home
import Page.NotFound as NotFound
import Page.TeamResult as TeamResult
import Route exposing (Route)
import Task
import Views.Page as Page exposing (ActivePage, frame)


-- MODEL


type Page
    = Blank
    | NotFound
    | Errored PageLoadError
    | Home Home.Model
    | TeamResult TeamResult.Model


type PageState
    = Loaded Page
    | TransitioningFrom Page


type alias Model =
    { pageState : PageState }


init : Location -> ( Model, Cmd Msg )
init location =
    setRoute (Route.fromLocation location)
        { pageState = Loaded initialPage }


initialPage : Page
initialPage =
    Blank



-- VIEW


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
                |> frame Page.Other isLoading

        NotFound ->
            NotFound.view
                |> frame Page.Other isLoading

        Errored subModel ->
            Errored.view subModel
                |> frame Page.Other isLoading

        Home subModel ->
            Home.view subModel
                |> frame Page.Home isLoading

        TeamResult subModel ->
            TeamResult.view subModel
                |> frame Page.TeamResult isLoading
                |> Html.map TeamMsg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ pageSubscriptions (getPage model.pageState) ]


pageSubscriptions : Page -> Sub Msg
pageSubscriptions page =
    case page of
        Blank ->
            Sub.none

        NotFound ->
            Sub.none

        Errored _ ->
            Sub.none

        Home _ ->
            Sub.none

        TeamResult _ ->
            Sub.none



-- UPDATE


type Msg
    = SetRoute (Maybe Route)
    | HomeLoaded (Result PageLoadError Home.Model)
    | TeamResultLoaded (Result PageLoadError TeamResult.Model)
    | TeamMsg TeamResult.Msg


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        transition toMsg task =
            ( { model | pageState = TransitioningFrom (getPage model.pageState) }
            , Task.attempt toMsg task
            )
    in
    case maybeRoute of
        Nothing ->
            ( { model | pageState = Loaded NotFound }, Cmd.none )

        Just Route.Home ->
            transition HomeLoaded Home.init

        Just Route.Root ->
            ( model, Route.modifyUrl Route.Home )

        Just Route.TeamResult ->
            transition TeamResultLoaded TeamResult.init


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
    let
        toPage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
            ( { model | pageState = Loaded (toModel newModel) }, Cmd.map toMsg newCmd )
    in
    case ( msg, page ) of
        ( SetRoute route, _ ) ->
            setRoute route model

        ( HomeLoaded (Ok subModel), _ ) ->
            ( { model | pageState = Loaded (Home subModel) }, Cmd.none )

        ( HomeLoaded (Err error), _ ) ->
            ( { model | pageState = Loaded (Errored error) }, Cmd.none )

        ( TeamResultLoaded (Ok subModel), _ ) ->
            ( { model | pageState = Loaded (TeamResult subModel) }, Cmd.none )

        ( TeamResultLoaded (Err error), _ ) ->
            ( { model | pageState = Loaded (Errored error) }, Cmd.none )

        ( TeamMsg subMsg, TeamResult subModel ) ->
            toPage TeamResult TeamMsg TeamResult.update subMsg subModel

        ( TeamMsg subMsg, _ ) ->
            ( model, Cmd.none )


main : Program Never Model Msg
main =
    Navigation.program (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
