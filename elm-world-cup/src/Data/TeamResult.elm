module Data.TeamResult exposing (TeamResult, decodeTeamResult)

import Json.Decode as Decode exposing (Decoder, field, int, list, null, string)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)


-- alternateName can be null


type alias TeamResult =
    { id : Int
    , country : String
    , alternateName : String
    , fifaCode : String
    , groupId : Int
    , groupLetter : String
    , wins : Int
    , draws : Int
    , losses : Int
    , gamesPlayed : Int
    , points : Int
    , goalsFor : Int
    , goalsAgainst : Int
    , goalDifferential : Int
    }


decodeTeamResult : Decoder TeamResult
decodeTeamResult =
    decode TeamResult
        |> required "id" int
        |> required "country" string
        |> optional "alternate_name" string ""
        |> required "fifa_code" string
        |> required "group_id" int
        |> required "group_letter" string
        |> required "wins" int
        |> required "draws" int
        |> required "losses" int
        |> required "games_played" int
        |> required "points" int
        |> required "goals_for" int
        |> required "goals_against" int
        |> required "goal_differential" int
