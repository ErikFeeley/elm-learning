module Page.TeamResult exposing (Model, Msg, init, update, view)

import Data.TeamResult as TeamResult exposing (TeamResult)
import Html exposing (..)
import Http
import Page.Errored exposing (PageLoadError, pageLoadError)
import Request.TeamResult exposing (getTeamResults)
import Task exposing (Task)
import Views.Page as Page


-- MODEL


type alias Model =
    { searchInput : String
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
    Task.map (Model "") loadTeamResults
        |> Task.mapError handleLoadError



-- VIEW


view : Model -> Html Msg
view model =
    text "team results page"



-- UPDATE


type Msg
    = SetSearch String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
