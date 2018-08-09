module Models exposing (..)

import RemoteData exposing (WebData)

type alias Model =
    { countries : WebData CountryList
    , populationData : WebData (List PopulationData)
    , route : Route
    , showGraph : Bool
    }

initialModel : Route -> Model
initialModel route = 
    { countries = RemoteData.Loading
    , populationData = RemoteData.Loading
    , route = route
    , showGraph = True
    }

type alias CountryName =
    String

type alias CountryList =
    { countries : List CountryName
    }

type alias PopulationData =
    {
        females : Int,
        country : CountryName,
        age : Int,
        males : Int,
        year : Int,
        total : Int
    }

type Route
    = CountriesRoute
    | CountryRoute CountryName