module Main exposing (main)

import Browser exposing (Document, UrlRequest, application)
import Browser.Navigation as Nav exposing (Key)
import Element
import Html exposing (Html)
import Layout
import Page.Counter as Counter
import Page.NotFound as NotFound
import Page.Sammich as Sammich
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
    | Sammich Sammich.Model
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

        Sammich subModel ->
            Layout.view SammichMsg (Sammich.view subModel)



-- UPDATE


type Msg
    = LinkClicked UrlRequest
    | SammichMsg Sammich.Msg
    | UrlChanged Url
    | CounterMsg Counter.Msg
    | StringReverserMsg StringReverser.Msg


routeParser : Model -> Parser (( Model, Cmd Msg ) -> a) a
routeParser model =
    oneOf
        [ Parser.map (passToCounter model Counter.init) Parser.top
        , Parser.map (passToStringReverser model StringReverser.init) <| s "stringreverser"
        , Parser.map (passToSammich model Sammich.init) <| s "sammich"
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


passToSammich : Model -> ( Sammich.Model, Cmd Sammich.Msg ) -> ( Model, Cmd Msg )
passToSammich model ( sammichModel, sammichCmds ) =
    ( { model | page = Sammich sammichModel }
    , Cmd.map SammichMsg sammichCmds
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

        SammichMsg subMsg ->
            case model.page of
                Sammich sammich ->
                    passToSammich model (Sammich.update subMsg sammich)

                _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
