module Main exposing (main)

import Browser exposing (Document, UrlRequest, application)
import Browser.Navigation as Nav exposing (Key)
import Element
import Html exposing (Html)
import Layout
import Page.Counter as Counter
import Page.NotFound as NotFound
import Page.StringReverser as StringReverser
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)



-- MAIN


main : Program () Model Msg
main =
    application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { page : Page
    , key : Key
    }


init : () -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    mapToRoute url { key = key, page = NotFound }


type Page
    = NotFound
    | Counter Counter.Model
    | StringReverser StringReverser.Model



-- VIEW


view : Model -> Document Msg
view model =
    case model.page of
        NotFound ->
            Layout.view never NotFound.view

        Counter subModel ->
            Layout.view CounterMsg (Counter.view subModel)

        StringReverser subModel ->
            Layout.view StringReverserMsg (StringReverser.view subModel)



-- UPDATE


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url
    | CounterMsg Counter.Msg
    | StringReverserMsg StringReverser.Msg


routeParser : Model -> Parser (( Model, Cmd Msg ) -> a) a
routeParser model =
    oneOf
        [ Parser.map (passToCounter model Counter.init) Parser.top
        , Parser.map (passToStringReverser model StringReverser.init) <| s "stringreverser"
        ]


mapToRoute : Url -> Model -> ( Model, Cmd Msg )
mapToRoute url model =
    case Parser.parse (routeParser model) url of
        Just answer ->
            answer

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )


passToCounter : Model -> ( Counter.Model, Cmd Counter.Msg ) -> ( Model, Cmd Msg )
passToCounter model ( counterModel, counterCmds ) =
    ( { model | page = Counter counterModel }
    , Cmd.map CounterMsg counterCmds
    )


passToStringReverser : Model -> ( StringReverser.Model, Cmd StringReverser.Msg ) -> ( Model, Cmd Msg )
passToStringReverser model ( stringReverserModel, stringReverserCmds ) =
    ( { model | page = StringReverser stringReverserModel }
    , Cmd.map StringReverserMsg stringReverserCmds
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            mapToRoute url model

        CounterMsg subMsg ->
            case model.page of
                Counter counter ->
                    passToCounter model (Counter.update subMsg counter)

                _ ->
                    ( model, Cmd.none )

        StringReverserMsg subMsg ->
            case model.page of
                StringReverser stringReverser ->
                    passToStringReverser model (StringReverser.update subMsg stringReverser)

                _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
