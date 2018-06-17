module Views.Page exposing (ActivePage(..), frame)

{-| The frame around a typical page - that is, the header and footer.
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route)


{-| Determines which navbar link (if any) will be rendered as active.

Note that we don't enumerate every page here, because the navbar doesn't
have links for every page. Anything that's not part of the navbar falls
under Other.

ok cool looking at this a bit more i dont actually need to use the
concept of an active page yet, it is mainly being used in
the spa example for styling the active link

-}
type ActivePage
    = Home
    | Other



{-
   ok cool so frame function frames the page with stuff
   that we want everywhere such as a header or footer.
   in the spa example case the type sig is a bit more complex
   for things like handling if we have a Maybe User and a Bool for whether or
   not were loading because the loading spinner renders in the navbar
   in that example

   for now just gonna go as simple as i can to get some links up there.

   ok cool removed active page for now but if i needed to style a link
   or something based on the current page thats how i could do it.
-}


frame : ActivePage -> Html msg -> Html msg
frame page content =
    div []
        [ viewNavbar page
        , content
        ]


viewNavbar : ActivePage -> Html msg
viewNavbar page =
    let
        linkTo =
            navBarLink page
    in
    nav [ class "nav navbar-light bg-light" ]
        [ a [ class "navbar-brand", Route.href Route.Home ]
            [ text "Elm World Cup" ]
        , linkTo Route.Home [ text "Todays Matches" ]
        ]


navBarLink : ActivePage -> Route -> List (Html msg) -> Html msg
navBarLink page route linkContent =
    a
        [ classList
            [ ( "nav-item", True )
            , ( "nav-link", True )
            , ( "active", isActive page route )
            ]
        , Route.href route
        ]
        linkContent


isActive : ActivePage -> Route -> Bool
isActive page route =
    case ( page, route ) of
        ( Home, Route.Home ) ->
            True

        _ ->
            False
