module Page.Time exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (Element, text)
import Task
import Time



-- MODEL


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    }


init : ( Model, Cmd Msg )
init =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )



-- VIEW


view : Model -> Element Msg
view model =
    let
        hour =
            String.fromInt (Time.toHour model.zone model.time)

        minute =
            String.fromInt (Time.toMinute model.zone model.time)

        second =
            String.fromInt (Time.toSecond model.zone model.time)
    in
    text <| hour ++ ":" ++ minute ++ ":" ++ second



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )



-- SUBSCRIPTIONS


{-| there may be a bug with time subscriptions see core issue 980
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick
