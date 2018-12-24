module Main exposing (main)

import Browser exposing (Document, UrlRequest, application)
import Browser.Navigation as Nav exposing (Key)
import Element
import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder)
import Layout
import Page.Counter as Counter
import Page.Form as Form
import Page.Http as PHttp
import Page.JsonDecoding as JsonDecoding
import Page.LocalStorage as LocalStorage
import Page.NotFound as NotFound
import Page.StringReverser as StringReverser
import Page.Time as Time
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)



-- MAIN


main : Program Decode.Value Model Msg
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
    , flags : Flags
    }


type alias Flags =
    { herp : String }


flagsDecoder : Decoder Flags
flagsDecoder =
    Decode.field "herp" Decode.string
        |> Decode.map Flags


init : Decode.Value -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    toRoute url
        { flags =
            Decode.decodeValue flagsDecoder flags
                |> Result.withDefault (Flags "something broke")
        , key = key
        , page = NotFound
        }


type Page
    = NotFound
    | Counter Counter.Model
    | Form Form.Model
    | Http PHttp.Model
    | JsonDecoding JsonDecoding.Model
    | LocalStorage LocalStorage.Model
    | StringReverser StringReverser.Model
    | Time Time.Model



-- VIEW


view : Model -> Document Msg
view model =
    case model.page of
        NotFound ->
            Layout.view never NotFound.view

        Counter subModel ->
            Layout.view GotCounterMsg (Counter.view subModel)

        Form subModel ->
            Layout.view GotFormMsg (Form.view subModel)

        Http subModel ->
            Layout.view GotHttpMsg (PHttp.view subModel)

        JsonDecoding subModel ->
            Layout.view GotJsonDecodingMsg (JsonDecoding.view subModel)

        LocalStorage subModel ->
            Layout.view GotLocalStorageMsg (LocalStorage.view subModel)

        StringReverser subModel ->
            Layout.view GotStringReverserMsg (StringReverser.view subModel)

        Time subModel ->
            Layout.view GotTimeMsg (Time.view subModel)



-- UPDATE


type Msg
    = LinkClicked UrlRequest
    | GotCounterMsg Counter.Msg
    | GotFormMsg Form.Msg
    | GotHttpMsg PHttp.Msg
    | GotJsonDecodingMsg JsonDecoding.Msg
    | GotLocalStorageMsg LocalStorage.Msg
    | GotStringReverserMsg StringReverser.Msg
    | GotTimeMsg Time.Msg
    | UrlChanged Url


routeParser : Model -> Parser (( Model, Cmd Msg ) -> a) a
routeParser model =
    oneOf
        [ Parser.map (Counter.init |> updateWithNoCmd Counter model) Parser.top
        , Parser.map (Form.init |> updateWithNoCmd Form model) <| s "form"
        , Parser.map (PHttp.init |> updateWith Http GotHttpMsg model) <| s "phttp"
        , Parser.map (JsonDecoding.init |> updateWith JsonDecoding GotJsonDecodingMsg model) <| s "jsondecoding"
        , Parser.map (LocalStorage.init |> updateWith LocalStorage GotLocalStorageMsg model) <| s "localstorage"
        , Parser.map (StringReverser.init |> updateWithNoCmd StringReverser model) <| s "stringreverser"
        , Parser.map (Time.init |> updateWith Time GotTimeMsg model) <| s "time"
        ]


toRoute : Url -> Model -> ( Model, Cmd Msg )
toRoute url model =
    Parser.parse (routeParser model) url
        |> Maybe.withDefault ( { model | page = NotFound }, Cmd.none )


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

        GotCounterMsg subMsg ->
            case model.page of
                Counter subModel ->
                    Counter.update subMsg subModel
                        |> updateWithNoCmd Counter model

                _ ->
                    ( model, Cmd.none )

        GotFormMsg subMsg ->
            case model.page of
                Form subModel ->
                    Form.update subMsg subModel
                        |> updateWithNoCmd Form model

                _ ->
                    ( model, Cmd.none )

        GotHttpMsg subMsg ->
            case model.page of
                Http subModel ->
                    PHttp.update subMsg subModel
                        |> updateWith Http GotHttpMsg model

                _ ->
                    ( model, Cmd.none )

        GotJsonDecodingMsg subMsg ->
            case model.page of
                JsonDecoding subModel ->
                    JsonDecoding.update subMsg subModel
                        |> updateWith JsonDecoding GotJsonDecodingMsg model

                _ ->
                    ( model, Cmd.none )

        GotLocalStorageMsg subMsg ->
            case model.page of
                LocalStorage subModel ->
                    LocalStorage.update subMsg subModel
                        |> updateWith LocalStorage GotLocalStorageMsg model

                _ ->
                    ( model, Cmd.none )

        GotStringReverserMsg subMsg ->
            case model.page of
                StringReverser subModel ->
                    StringReverser.update subMsg subModel
                        |> updateWithNoCmd StringReverser model

                _ ->
                    ( model, Cmd.none )

        GotTimeMsg subMsg ->
            case model.page of
                Time subModel ->
                    Time.update subMsg subModel
                        |> updateWith Time GotTimeMsg model

                _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        LocalStorage localStorage ->
            Sub.map GotLocalStorageMsg (LocalStorage.subscriptions localStorage)

        Time time ->
            Sub.map GotTimeMsg (Time.subscriptions time)

        _ ->
            Sub.none
