module Main exposing (..)

import Commands exposing (fetchCountries, fetchPopulationForCountry)
import Models exposing (Model, initialModel)
import Msgs exposing (Msg)
import Navigation exposing (Location)
import Routing
import Update exposing (update)
import View exposing (view)

init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute = 
            Routing.parseLocation location
        currentCommand =
            case currentRoute of
                Models.CountryRoute country ->
                    fetchPopulationForCountry country

                Models.CountriesRoute ->
                    fetchCountries
    in
        ( initialModel currentRoute, currentCommand )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- MAIN

main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }