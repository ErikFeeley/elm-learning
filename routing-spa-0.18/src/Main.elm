module Main exposing (..)

import Page.Counter as Counter
import Page.Home as Home
import Page.NotFound as NotFound
import Navigation exposing (Location)
import Html exposing (..)
import Route exposing (Route)


{-
   literally a page type that describes every page in our SPA
-}


type Page
    = Blank
    | Counter Counter.Model
    | Home
    | NotFound



{-
   can use this pageState type in order to
   represent a loading state during a page transition
   such as the next page requiring some data from zee ajax
-}


type PageState
    = Loaded Page
    | TransitioningFrom Page



-- MODEL --
{-
   ok so top level model for our program.
   all we care about right now is the pagestate
-}


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
{-
   ok not using it just yet but this top level
   view function is about taking our pageState
   and then passing on a Bool for isLoading
   to the viewPage function
-}


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage False page

        TransitioningFrom page ->
            viewPage True page



{-
   ok viewpage, simpleish for now
   take a Bool for isloading and a page to render
   then return the Html Msg currently not touching the
   isloading bits

   da heck is going on with subModel...
-}


viewPage : Bool -> Page -> Html Msg
viewPage isLoading page =
    case page of
        Blank ->
            Html.text ""

        Counter subModel ->
            Counter.view subModel
                |> Html.map CounterMsg

        Home ->
            Home.view

        NotFound ->
            NotFound.view



-- UPDATE --
{-
   in richards example this gets a lot bigger.
   for now im just worried about setting the route
   later on i can use this for other messages which
   could be Results are just regular messages from
   looking at the example
-}


type Msg
    = SetRoute (Maybe Route)
    | CounterMsg Counter.Msg



{-
   helper function for well... setting the route..
-}


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | pageState = Loaded NotFound }, Cmd.none )

        Just Route.Home ->
            ( { model | pageState = Loaded Home }, Cmd.none )

        Just Route.Root ->
            ( model, Route.modifyUrl Route.Home )



{-
   top level update get the top level page state
   then pass down the msg and model to the update page function
   which should actually take care of the msg for setting the
   route and other things... i think..
-}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model



{-
   not super clear... on what this guy is doin...
   maybe just matching up types from update to updatepage?
-}


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page



{-
   where the magic be happenin...
   interesting i wanted to include this because its in the
   spa-exapmle-app however it says the pattern is redundant
   with the above pattern

    actually both of these patterns were redundant
   ( _, NotFound ) ->
       ( model, Cmd.none )
       ( _, _ ) ->
    ( model, Cmd.none )

    DUUUUUUUDDDEEEE SUPER INTERESTING
    ok so... before i had a thingy that had to use that toPage
    function to Cmd.map the message over the above patterns were
    not useful... but when i added that case to match teh counterMsg
    tree it then complained about unmatched patterns therefore i had
    to add them back in...

    technically i only needed to add the empty empty tuple back in but
    im doing both not because it is allowing it and compile

    something is wrong it wont go to teh counter page..
    i think i need to add something in the Route.elm
    it keeps going to not found.
-}


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

            ( CounterMsg subMsg, Counter subModel ) ->
                toPage Counter CounterMsg Counter.update subMsg subModel

            ( _, NotFound ) ->
                ( model, Cmd.none )

            ( _, _ ) ->
                ( model, Cmd.none )


main : Program Never Model Msg
main =
    Navigation.program (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
