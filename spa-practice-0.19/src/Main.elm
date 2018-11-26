module Main exposing (main)

import Browser exposing (Document, UrlRequest, application)
import Browser.Navigation as Nav exposing (Key)
import Element
import Html exposing (Html)
import Layout
import Page.Counter as Counter
import Page.Form as Form
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
    toRoute url { key = key, page = NotFound }


type Page
    = NotFound
    | Counter Counter.Model
    | Form Form.Model
    | Sammich Sammich.Model
    | StringReverser StringReverser.Model



-- VIEW


view : Model -> Document Msg
view model =
    case model.page of
        NotFound ->
            Layout.view never NotFound.view

        Counter subModel ->
            Layout.view CounterMsg (Counter.view subModel)

        Form subModel ->
            Layout.view FormMsg (Form.view subModel)

        StringReverser subModel ->
            Layout.view StringReverserMsg (StringReverser.view subModel)

        Sammich subModel ->
            Layout.view SammichMsg (Sammich.view subModel)



-- UPDATE


type Msg
    = LinkClicked UrlRequest
    | CounterMsg Counter.Msg
    | FormMsg Form.Msg
    | SammichMsg Sammich.Msg
    | StringReverserMsg StringReverser.Msg
    | UrlChanged Url


routeParser : Model -> Parser (( Model, Cmd Msg ) -> a) a
routeParser model =
    oneOf
        [ Parser.map (passToCounter2 model Counter.init) Parser.top
        , Parser.map (Form.init |> (\x -> ( x, Cmd.none )) |> updateWith Form FormMsg model) <| s "form"

        -- , Parser.map (passToStringReverser model StringReverser.init) <| s "stringreverser"
        , Parser.map (StringReverser.init |> updateWith StringReverser StringReverserMsg model) <| s "stringreverser"
        , Parser.map (passToSammich model Sammich.init) <| s "sammich"
        ]


toRoute : Url -> Model -> ( Model, Cmd Msg )
toRoute url model =
    Maybe.withDefault ( { model | page = NotFound }, Cmd.none ) <| Parser.parse (routeParser model) url


passToCounter : Model -> ( Counter.Model, Cmd Counter.Msg ) -> ( Model, Cmd Msg )
passToCounter model ( counterModel, counterCmds ) =
    ( { model | page = Counter counterModel }
    , Cmd.map CounterMsg counterCmds
    )


passToCounter2 : Model -> ( Counter.Model, Cmd Counter.Msg ) -> ( Model, Cmd Msg )
passToCounter2 model ( counterModel, counterCmds ) =
    updateWith Counter CounterMsg model ( counterModel, counterCmds )


updateWith : (subModel -> Page) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toPage toMsg model ( subModel, subMsg ) =
    ( { model | page = toPage subModel }
    , Cmd.map toMsg subMsg
    )


passToStringReverser : Model -> ( StringReverser.Model, Cmd StringReverser.Msg ) -> ( Model, Cmd Msg )
passToStringReverser model ( stringReverserModel, stringReverserCmds ) =
    ( { model | page = StringReverser stringReverserModel }
    , Cmd.map StringReverserMsg stringReverserCmds
    )


passToSammich : Model -> Sammich.Model -> ( Model, Cmd Msg )
passToSammich model sammichModel =
    ( { model | page = Sammich sammichModel }
    , Cmd.none
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
            toRoute url model

        CounterMsg subMsg ->
            case model.page of
                Counter subModel ->
                    -- Counter.update subMsg subModel |> updateWith Counter CounterMsg model
                    passToCounter2 model <| Counter.update subMsg subModel

                _ ->
                    ( model, Cmd.none )

        FormMsg subMsg ->
            case model.page of
                Form subModel ->
                    Form.update subMsg subModel
                        |> (\x -> ( x, Cmd.none ))
                        |> updateWith Form FormMsg model

                _ ->
                    ( model, Cmd.none )

        StringReverserMsg subMsg ->
            case model.page of
                StringReverser subModel ->
                    -- passToStringReverser model (StringReverser.update subMsg stringReverser)
                    StringReverser.update subMsg subModel |> updateWith StringReverser StringReverserMsg model

                _ ->
                    ( model, Cmd.none )

        SammichMsg subMsg ->
            case model.page of
                Sammich subModel ->
                    -- passToSammich model (Sammich.update subMsg sammich)
                    Sammich.update subMsg subModel
                        |> (\x -> ( x, Cmd.none ))
                        |> updateWith Sammich SammichMsg model

                _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
