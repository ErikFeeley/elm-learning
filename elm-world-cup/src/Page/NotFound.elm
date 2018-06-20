module Page.NotFound exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (..)


view : Html msg
view =
    div [ class "container" ] [ text "not found bro" ]
