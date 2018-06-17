module Page.Home exposing (..)

import Data.Match exposing (Match)
import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Page.Errored exposing (PageLoadError, pageLoadError)
import Request.Match
import Task exposing (Task)
import Views.Page as Page


type alias Model =
    { matches : List Match }


init : Task PageLoadError Model
init =
    let
        loadMatches =
            Request.Match.list
                |> Http.toTask

        handleLoadError _ =
            pageLoadError Page.Home "Matches failed to load"
    in
    Task.map Model loadMatches
        |> Task.mapError handleLoadError


view : Model -> Html msg
view model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ h1 [ class "display-4" ] [ text "Todays Matches" ] ]
        , div [ class "row" ]
            [ div [ class "col" ] [ viewMatches model.matches ]
            ]
        ]


viewMatches : List Match -> Html msg
viewMatches matches =
    div [] (List.map viewMatch matches)


viewMatch : Match -> Html msg
viewMatch match =
    div [ class "card" ]
        [ h5 [ class "card-header" ] [ text "wat" ] ]
