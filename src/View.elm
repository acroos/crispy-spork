module View exposing (..)

import Html exposing (Html, div, text)
import Msgs exposing (Msg)
import Models exposing (Model)
import Countries.List
import Countries.PopulationData
import Countries.PopulationGraph
import RemoteData

view : Model -> Html Msg
view model = 
    div []
        [ page model ]

page : Model -> Html Msg
page model = 
    case model.route of
        Models.CountriesRoute ->
            Countries.List.view model.countries

        Models.PopulationRoute country ->
            Countries.PopulationGraph.view model.populationData

        Models.NotFoundRoute ->
            Countries.List.view model.countries
