module Page.TeamResult exposing (Model, Msg, init, update, view)

import Data.TeamResult as TeamResult exposing (TeamResult)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import List.Extra
import Page.Errored exposing (PageLoadError, pageLoadError)
import Request.TeamResult exposing (getTeamResults)
import Task exposing (Task)
import Views.Page as Page


-- MODEL


type alias Model =
    { searchInput : String
    , searchResults : List TeamResult
    , selectedTeam : Maybe TeamResult
    , teamResults : List TeamResult
    }


init : Task PageLoadError Model
init =
    let
        loadTeamResults =
            getTeamResults
                |> Http.toTask

        handleLoadError _ =
            pageLoadError Page.TeamResult "Team results failed to load"
    in
    Task.map (Model "" [] Nothing) loadTeamResults
        |> Task.mapError handleLoadError



-- VIEW


viewSearchArea : Html Msg
viewSearchArea =
    div [ class "columns" ]
        [ div [ class "column" ]
            [ div [ class "field" ]
                [ label [ class "label" ]
                    [ text "Search For A Team" ]
                , div [ class "control" ]
                    [ input
                        [ class "input"
                        , onInput SetSearch
                        , placeholder "Text input"
                        , type_ "text"
                        ]
                        []
                    ]
                , p [ class "help" ]
                    [ text "Search by country or FIFA code" ]
                ]
            ]
        ]


viewResults : List TeamResult -> List (Html Msg)
viewResults searchResults =
    searchResults
        |> List.map (\r -> a [ class "panel-block", onClick (SetSelectedTeam r.id) ] [ text r.country ])


viewSearchResults : List TeamResult -> Html Msg
viewSearchResults searchResults =
    case searchResults of
        [] ->
            text ""

        x :: _ ->
            div [ class "columns" ]
                [ div [ class "column" ]
                    [ div [ class "panel" ]
                        [ p [ class "panel-heading" ] [ text "Found Teams" ]
                        , div [] (viewResults searchResults)
                        ]
                    ]
                ]


viewSelectedTeam : Maybe TeamResult -> Html Msg
viewSelectedTeam team =
    case team of
        Nothing ->
            span [] [ text "" ]

        Just team ->
            div [ class "card" ]
                [ div [ class "card-content" ]
                    [ p [ class "title" ] [ text <| "Country: " ++ team.country ]
                    , p [ class "subtitle" ] [ text <| "FIFA Code: " ++ team.fifaCode ]
                    , p [] [ text <| "Games Played: " ++ toString team.gamesPlayed ]
                    , p [] [ text <| "Wins: " ++ toString team.wins ]
                    , p [] [ text <| "Losses: " ++ toString team.losses ]
                    , p [] [ text <| "Goals For: " ++ toString team.goalsFor ]
                    , p [] [ text <| "Goals Agains: " ++ toString team.goalsAgainst ]
                    , p [] [ text <| "Goal Differential: " ++ toString team.goalDifferential ]
                    ]
                ]


view : Model -> Html Msg
view model =
    section [ class "section" ]
        [ div [ class "container" ]
            [ viewSearchArea
            , viewSearchResults model.searchResults
            , viewSelectedTeam model.selectedTeam
            ]
        ]



-- UPDATE


type Msg
    = SetSearch String
    | SetSelectedTeam Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSearch search ->
            ( { model
                | searchInput = search
                , searchResults =
                    List.filter
                        (\r ->
                            String.contains (String.toLower search) (String.toLower r.fifaCode)
                                || String.contains (String.toLower search) (String.toLower r.country)
                        )
                        model.teamResults
              }
            , Cmd.none
            )

        SetSelectedTeam id ->
            let
                selectedTeam =
                    List.Extra.find (\e -> e.id == id) model.searchResults
            in
            ( { model | selectedTeam = selectedTeam }, Cmd.none )
