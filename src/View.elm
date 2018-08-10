module View exposing (..)

import Html exposing (Html, div, text)
import Msgs exposing (Msg)
import Models exposing (Model)
import Countries.List
import Countries.Show
import Letters.Index
import Shared.Views.Template exposing (template)

view : Model -> Html Msg
view model = 
    page model

page : Model -> Html Msg
page model = 
    case model.route of
        Models.CountriesRoute ->
            template (Countries.List.view model.countries)

        Models.CountryRoute country ->
            template (Countries.Show.view model.populationData model.showGraph)
        
        Models.LettersRoute ->
            template (Letters.Index.view model.accumulatedKeyStrokes)
