module Main exposing (main)

import Browser exposing (Document, UrlRequest, application)
import Browser.Navigation as Nav exposing (Key)
import Element
import Html exposing (Html)
import Layout
import Page.Counter as Counter
import Page.Form as Form
import Page.Http as PHttp
import Page.JsonDecoding as JsonDecoding
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
    toRoute url { key = key, page = NotFound }


type Page
    = NotFound
    | Counter Counter.Model
    | Form Form.Model
    | Http PHttp.Model
    | JsonDecoding JsonDecoding.Model
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

        Http subModel ->
            Layout.view HttpMsg (PHttp.view subModel)

        JsonDecoding subModel ->
            Layout.view JsonDecodingMsg (JsonDecoding.view subModel)

        StringReverser subModel ->
            Layout.view StringReverserMsg (StringReverser.view subModel)



-- UPDATE


type Msg
    = LinkClicked UrlRequest
    | CounterMsg Counter.Msg
    | FormMsg Form.Msg
    | HttpMsg PHttp.Msg
    | JsonDecodingMsg JsonDecoding.Msg
    | StringReverserMsg StringReverser.Msg
    | UrlChanged Url


routeParser : Model -> Parser (( Model, Cmd Msg ) -> a) a
routeParser model =
    oneOf
        [ Parser.map (Counter.init |> updateWithNoCmd Counter model) Parser.top
        , Parser.map (Form.init |> updateWithNoCmd Form model) <| s "form"
        , Parser.map (PHttp.init |> updateWith Http HttpMsg model) <| s "phttp"
        , Parser.map (JsonDecoding.init |> updateWith JsonDecoding JsonDecodingMsg model) <| s "jsondecoding"
        , Parser.map (StringReverser.init |> updateWithNoCmd StringReverser model) <| s "stringreverser"
        ]


toRoute : Url -> Model -> ( Model, Cmd Msg )
toRoute url model =
    Maybe.withDefault ( { model | page = NotFound }, Cmd.none ) <| Parser.parse (routeParser model) url


updateWith : (subModel -> Page) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toPage toMsg model ( subModel, subMsg ) =
    ( { model | page = toPage subModel }
    , Cmd.map toMsg subMsg
    )


updateWithNoCmd : (subModel -> Page) -> Model -> subModel -> ( Model, Cmd Msg )
updateWithNoCmd toPage model subModel =
    ( { model | page = toPage subModel }, Cmd.none )


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
                    Counter.update subMsg subModel
                        |> updateWithNoCmd Counter model

                _ ->
                    ( model, Cmd.none )

        FormMsg subMsg ->
            case model.page of
                Form subModel ->
                    Form.update subMsg subModel
                        |> updateWithNoCmd Form model

                _ ->
                    ( model, Cmd.none )

        HttpMsg subMsg ->
            case model.page of
                Http subModel ->
                    PHttp.update subMsg subModel
                        |> updateWith Http HttpMsg model

                _ ->
                    ( model, Cmd.none )

        JsonDecodingMsg subMsg ->
            case model.page of
                JsonDecoding subModel ->
                    JsonDecoding.update subMsg subModel
                        |> updateWith JsonDecoding JsonDecodingMsg model

                _ ->
                    ( model, Cmd.none )

        StringReverserMsg subMsg ->
            case model.page of
                StringReverser subModel ->
                    StringReverser.update subMsg subModel
                        |> updateWithNoCmd StringReverser model

                _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
