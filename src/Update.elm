module Update exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model, Route(..))
import Routing exposing (parseLocation)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnFetchCountries response ->
            ( { model | countries = response }, Cmd.none )

        Msgs.OnFetchPopulationData response ->
            ( { model | populationData = response }, Cmd.none)

        Msgs.OnLocationChange location ->
            let
                newRoute = 
                    parseLocation location
            in
                ( { model | route = newRoute },  Cmd.none)
        
        Msgs.ToggleCountryView shouldShowGraph ->
            ( { model | showGraph = shouldShowGraph }, Cmd.none)