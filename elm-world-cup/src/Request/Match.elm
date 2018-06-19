module Request.Match exposing (todaysMatches)

import Data.Match as Match exposing (Match, decodeMatch)
import Http
import Json.Decode as Decode
import Request.Helpers exposing (apiUrl)


todaysMatches : Http.Request (List Match)
todaysMatches =
    Http.get (apiUrl "/matches/today") (Decode.list decodeMatch)
