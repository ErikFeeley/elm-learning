module Page.Home exposing (Model, init, view)

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
            Request.Match.todaysMatches
                |> Http.toTask

        handleLoadError _ =
            pageLoadError Page.Home "Matches failed to load"
    in
    Task.map Model loadMatches
        |> Task.mapError handleLoadError


view : Model -> Html msg
view model =
    section [ class "section" ]
        [ div [ class "container" ]
            [ viewMatches model.matches
            ]
        ]


viewMatches : List Match -> Html msg
viewMatches matches =
    div [ class "columns is-multiline" ] <| List.map viewMatch matches


viewMatch : Match -> Html msg
viewMatch match =
    div [ class "column is-half" ]
        [ div [ class "card" ]
            [ div [ class "card-content" ]
                [ div
                    [ class "content" ]
                    [ p [ class "title" ] [ text <| "Venue: " ++ match.venue ]
                    , p [ class "subtitle" ] [ text <| "Location: " ++ match.location ]
                    , p [] [ text <| "When: " ++ match.status ]
                    , p [] [ text <| "Time: " ++ match.datetime ]
                    , p [] [ text <| "Home Team: " ++ match.homeTeam.code ]
                    , p [] [ text <| "Home Team Goals: " ++ toString match.homeTeam.goals ]
                    , p [] [ text <| "Away Team: " ++ match.awayTeam.code ]
                    , p [] [ text <| "Away Team Goals: " ++ toString match.awayTeam.goals ]
                    , p [] [ text <| "Winner (if there is yet): " ++ match.winner ]
                    ]
                ]
            ]
        ]
