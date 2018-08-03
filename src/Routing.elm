module Routing exposing (..)

import Http exposing (encodeUri)
import Navigation exposing (Location)
import Models exposing (CountryName, Route(..))
import UrlParser exposing (..)

matchers : Parser (Route -> a) a
matchers = 
    oneOf
        [ map CountriesRoute top
        , map CountriesRoute (s "countries")
        , map CountriesRoute (s "countries/")
        , map PopulationRoute (s "countries" </> string)
        ]

parseLocation : Location -> Route
parseLocation location =
    case (parsePath matchers location) of
        Just route ->
            route
        
        Nothing ->
            NotFoundRoute

countriesPath : String
countriesPath =
    "/countries"

countryPath : CountryName -> String
countryPath name =
    "/countries/" ++ (encodeUri name)
    