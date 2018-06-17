module Data.Match
    exposing
        ( Event
        , Match
        , Team
        , decodeMatch
        )

import Json.Decode exposing (field, null)
import Json.Decode.Pipeline
import Json.Encode


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


decodeMatch : Json.Decode.Decoder Match
decodeMatch =
    Json.Decode.Pipeline.decode Match
        |> Json.Decode.Pipeline.required "venue" Json.Decode.string
        |> Json.Decode.Pipeline.required "location" Json.Decode.string
        |> Json.Decode.Pipeline.required "status" Json.Decode.string
        |> Json.Decode.Pipeline.optional "time" Json.Decode.string ""
        |> Json.Decode.Pipeline.required "fifa_id" Json.Decode.string
        |> Json.Decode.Pipeline.required "datetime" Json.Decode.string
        |> Json.Decode.Pipeline.optional "last_event_update_at" Json.Decode.string ""
        |> Json.Decode.Pipeline.required "last_score_update_at" Json.Decode.string
        |> Json.Decode.Pipeline.required "home_team" decodeMatchHome_team
        |> Json.Decode.Pipeline.required "away_team" decodeMatchAway_team
        |> Json.Decode.Pipeline.optional "winner" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "winner_code" Json.Decode.string ""
        |> Json.Decode.Pipeline.required "home_team_events" (Json.Decode.list decodeEvent)
        |> Json.Decode.Pipeline.required "away_team_events" (Json.Decode.list decodeEvent)


decodeMatchHome_team : Json.Decode.Decoder Team
decodeMatchHome_team =
    Json.Decode.map3 Team
        (field "country" Json.Decode.string)
        (field "code" Json.Decode.string)
        (field "goals" Json.Decode.int)


decodeMatchAway_team : Json.Decode.Decoder Team
decodeMatchAway_team =
    Json.Decode.map3 Team
        (field "country" Json.Decode.string)
        (field "code" Json.Decode.string)
        (field "goals" Json.Decode.int)


decodeEvent : Json.Decode.Decoder Event
decodeEvent =
    Json.Decode.map4 Event
        (field "id" Json.Decode.int)
        (field "type_of_event" Json.Decode.string)
        (field "player" Json.Decode.string)
        (field "time" Json.Decode.string)


encodeMatch : Match -> Json.Encode.Value
encodeMatch record =
    Json.Encode.object
        [ ( "venue", Json.Encode.string <| record.venue )
        , ( "location", Json.Encode.string <| record.location )
        , ( "status", Json.Encode.string <| record.status )
        , ( "time", Json.Encode.string <| record.time )
        , ( "fifaId", Json.Encode.string <| record.fifaId )
        , ( "datetime", Json.Encode.string <| record.datetime )
        , ( "lastEventUpdateAt", Json.Encode.string <| record.lastEventUpdateAt )
        , ( "lastScoreUpdateAt", Json.Encode.string <| record.lastScoreUpdateAt )
        , ( "homeTeam", encodeMatchHome_team <| record.homeTeam )
        , ( "awayTeam", encodeMatchAway_team <| record.awayTeam )
        , ( "winner", Json.Encode.string <| record.winner )
        , ( "winnerCode", Json.Encode.string <| record.winnerCode )
        , ( "homeTeamEvents", Json.Encode.list <| List.map encodeEvent <| record.homeTeamEvents )
        , ( "awayTeamEvents", Json.Encode.list <| List.map encodeEvent <| record.awayTeamEvents )
        ]


encodeMatchHome_team : Team -> Json.Encode.Value
encodeMatchHome_team record =
    Json.Encode.object
        [ ( "country", Json.Encode.string <| record.country )
        , ( "code", Json.Encode.string <| record.code )
        , ( "goals", Json.Encode.int <| record.goals )
        ]


encodeMatchAway_team : Team -> Json.Encode.Value
encodeMatchAway_team record =
    Json.Encode.object
        [ ( "country", Json.Encode.string <| record.country )
        , ( "code", Json.Encode.string <| record.code )
        , ( "goals", Json.Encode.int <| record.goals )
        ]


encodeEvent : Event -> Json.Encode.Value
encodeEvent record =
    Json.Encode.object
        [ ( "id", Json.Encode.int <| record.id )
        , ( "typeOfEvent", Json.Encode.string <| record.typeOfEvent )
        , ( "player", Json.Encode.string <| record.player )
        , ( "time", Json.Encode.string <| record.time )
        ]
