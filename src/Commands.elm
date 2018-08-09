module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Msgs exposing (Msg)
import Models exposing (CountryList, PopulationData, CountryName)
import RemoteData

fetchCountries : Cmd Msg
fetchCountries =
    let
        request = Http.request
            { body = Http.emptyBody
            , headers = [Http.header "Accept" "application/json"]
            , method = "GET"
            , timeout = Nothing
            , url = fetchCountriesUrl
            , withCredentials = False
            , expect = Http.expectJson countriesDecoder
            }
    in
        RemoteData.sendRequest request
        |> Cmd.map Msgs.OnFetchCountries

fetchCountriesUrl : String
fetchCountriesUrl = 
    "http://api.population.io/1.0/countries/"

countriesDecoder : Decode.Decoder CountryList
countriesDecoder =
    decode CountryList
        |> required "countries" (Decode.list Decode.string)

fetchPopulationForCountry : CountryName -> Cmd Msg
fetchPopulationForCountry country =
    let
        request = 
        Http.request
            { body = Http.emptyBody
            , headers = [Http.header "Accept" "application/json"]
            , method = "GET"
            , timeout = Nothing
            , url = fetchPopulationDataUrl country
            , withCredentials = False
            , expect = Http.expectJson populationDataListDecoder
            }
    in
        RemoteData.sendRequest request
        |> Cmd.map Msgs.OnFetchPopulationData

fetchPopulationDataUrl : CountryName -> String
fetchPopulationDataUrl country = 
    "http://api.population.io/1.0/population/2018/" ++ country

populationDataDecoder : Decode.Decoder PopulationData
populationDataDecoder =
    decode PopulationData
        |> required "females" Decode.int
        |> required "country" Decode.string
        |> required "age" Decode.int
        |> required "males" Decode.int
        |> required "year" Decode.int
        |> required "total" Decode.int

populationDataListDecoder : Decode.Decoder (List PopulationData)
populationDataListDecoder =
    Decode.list populationDataDecoder