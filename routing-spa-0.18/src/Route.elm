module Route exposing (Route(..), fromLocation, href, modifyUrl)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Navigation exposing (Location)
import UrlParser exposing (Parser, map, oneOf, parseHash, s)


-- ROUTING --
{-
   i think these are going to match up  with
   all of the possible page routes
-}


type Route
    = Counter
    | Form
    | Home
    | Root



{-
   using the UrlParser library here to describe routes
   it actually kinda looks similar to how i saw it in servant
   using combinators to build up a a route
-}


route : Parser (Route -> a) a
route =
    oneOf
        [ map Home (s "")
        , map Counter (s "counter")
        , map Form (s "form")
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
                Counter ->
                    [ "counter" ]

                Form ->
                    [ "form" ]

                Home ->
                    []

                Root ->
                    []
    in
    "#/" ++ String.join "/" pieces



-- PUBLIC HELPERS --
{-
   not super clear on the usage of the following yet

   ok got kinda got it now so href is literally
   a helper for setting href attribute for a link
   modifyUrl is for changing the url for whatever reason
   like in Main right now if i see root i change it to home

   i think im using fromlocation yet
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
