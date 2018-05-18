module Route exposing (Route(..), fromLocation, href, modifyUrl)

import Html exposing (Attribute)
import Navigation exposing (Location)
import Html.Attributes as Attr
import UrlParser exposing (Parser, oneOf, parseHash, s)


-- ROUTING --
{-
   i think these are going to match up literally with
   all of the possible page routes
-}


type Route
    = Home
    | Root
    | Counter



{-
   using the UrlParser library here to describe routes
   it actually kinda looks similar to how i saw it in servant
   using combinators to build up a a route
-}


route : Parser (Route -> a) a
route =
    oneOf
        [ UrlParser.map Home (s "")
        , UrlParser.map Counter (s "counter")
        ]



-- INTERNAL --
{-
   constructing a string representation
   of our route here using a hash symbol
-}


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Root ->
                    []

                Counter ->
                    [ "counter" ]
    in
        "#/" ++ String.join "/" pieces



-- PUBLIC HELPERS --
{-
   not super clear on the usage of the following yet
-}


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Root
    else
        parseHash route location
