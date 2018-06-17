module Request.Match exposing (..)

import Data.Match as Match exposing (Match, decodeMatch)
import Http
import Json.Decode as Decode
import Request.Helpers exposing (apiUrl)


list : Http.Request (List Match)
list =
    Http.get (apiUrl "/matches/today") (Decode.list decodeMatch)
