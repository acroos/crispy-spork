module Msgs exposing (..)

import Models exposing (CountryList, CountryName, PopulationData)
import Navigation exposing (Location)
import RemoteData exposing (WebData)

type Msg
    = OnFetchCountries (WebData CountryList)
    | OnFetchPopulationData (WebData (List PopulationData))
    | OnLocationChange Location
    | ToggleCountryView Bool
    | OnBodyKeyPress Int