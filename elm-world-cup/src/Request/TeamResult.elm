module Request.TeamResult exposing (..)

import Data.TeamResult as TeamResult exposing (TeamResult, decodeTeamResult)
import Http exposing (Request, get)
import Json.Decode as Decode exposing (list)
import Request.Helpers exposing (apiUrl)


getTeamResults : Request (List TeamResult)
getTeamResults =
    get (apiUrl "/teams/results") (list decodeTeamResult)
