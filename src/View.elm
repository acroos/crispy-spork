module View exposing (..)

import Html exposing (Html, div, text)
import Msgs exposing (Msg)
import Models exposing (Model)
import Countries.List
import Countries.Show

view : Model -> Html Msg
view model = 
    page model

page : Model -> Html Msg
page model = 
    case model.route of
        Models.CountriesRoute ->
            Countries.List.view model.countries

        Models.CountryRoute country ->
            Countries.Show.view model.populationData model.showGraph
