module Data.Match
    exposing
        ( Event
        , Match
        , Team
        , decodeMatch
        )

import Json.Decode as Decode exposing (field, int, list, null, string)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)


type alias Match =
    { venue : String
    , location : String
    , status : String
    , time : String
    , fifaId : String
    , datetime : String
    , lastEventUpdateAt : String
    , lastScoreUpdateAt : String
    , homeTeam : Team
    , awayTeam : Team
    , winner : String
    , winnerCode : String
    , homeTeamEvents : List Event
    , awayTeamEvents : List Event
    }


type alias Team =
    { country : String
    , code : String
    , goals : Int
    }


type alias Event =
    { id : Int
    , typeOfEvent : String
    , player : String
    , time : String
    }


decodeMatch : Decode.Decoder Match
decodeMatch =
    decode Match
        |> required "venue" string
        |> required "location" string
        |> required "status" string
        |> optional "time" string ""
        |> required "fifa_id" string
        |> required "datetime" string
        |> optional "last_event_update_at" string ""
        |> required "last_score_update_at" string
        |> required "home_team" decodeMatchHome_team
        |> required "away_team" decodeMatchAway_team
        |> optional "winner" string ""
        |> optional "winner_code" string ""
        |> required "home_team_events" (list decodeEvent)
        |> required "away_team_events" (list decodeEvent)


decodeMatchHome_team : Decode.Decoder Team
decodeMatchHome_team =
    Decode.map3 Team
        (field "country" string)
        (field "code" string)
        (field "goals" int)


decodeMatchAway_team : Decode.Decoder Team
decodeMatchAway_team =
    Decode.map3 Team
        (field "country" string)
        (field "code" string)
        (field "goals" int)


decodeEvent : Decode.Decoder Event
decodeEvent =
    Decode.map4 Event
        (field "id" int)
        (field "type_of_event" string)
        (field "player" string)
        (field "time" string)



-- encodeMatch : Match -> Json.Encode.Value
-- encodeMatch record =
--     Json.Encode.object
--         [ ( "venue", Json.Encode.string <| record.venue )
--         , ( "location", Json.Encode.string <| record.location )
--         , ( "status", Json.Encode.string <| record.status )
--         , ( "time", Json.Encode.string <| record.time )
--         , ( "fifaId", Json.Encode.string <| record.fifaId )
--         , ( "datetime", Json.Encode.string <| record.datetime )
--         , ( "lastEventUpdateAt", Json.Encode.string <| record.lastEventUpdateAt )
--         , ( "lastScoreUpdateAt", Json.Encode.string <| record.lastScoreUpdateAt )
--         , ( "homeTeam", encodeMatchHome_team <| record.homeTeam )
--         , ( "awayTeam", encodeMatchAway_team <| record.awayTeam )
--         , ( "winner", Json.Encode.string <| record.winner )
--         , ( "winnerCode", Json.Encode.string <| record.winnerCode )
--         , ( "homeTeamEvents", Json.Encode.list <| List.map encodeEvent <| record.homeTeamEvents )
--         , ( "awayTeamEvents", Json.Encode.list <| List.map encodeEvent <| record.awayTeamEvents )
--         ]
-- encodeMatchHome_team : Team -> Json.Encode.Value
-- encodeMatchHome_team record =
--     Json.Encode.object
--         [ ( "country", Json.Encode.string <| record.country )
--         , ( "code", Json.Encode.string <| record.code )
--         , ( "goals", Json.Encode.int <| record.goals )
--         ]
-- encodeMatchAway_team : Team -> Json.Encode.Value
-- encodeMatchAway_team record =
--     Json.Encode.object
--         [ ( "country", Json.Encode.string <| record.country )
--         , ( "code", Json.Encode.string <| record.code )
--         , ( "goals", Json.Encode.int <| record.goals )
--         ]
-- encodeEvent : Event -> Json.Encode.Value
-- encodeEvent record =
--     Json.Encode.object
--         [ ( "id", Json.Encode.int <| record.id )
--         , ( "typeOfEvent", Json.Encode.string <| record.typeOfEvent )
--         , ( "player", Json.Encode.string <| record.player )
--         , ( "time", Json.Encode.string <| record.time )
--         ]
