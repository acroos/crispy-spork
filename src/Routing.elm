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
        , map CountryRoute (s "countries" </> string)
        , map LettersRoute (s "letters")
        , map LettersRoute (s "letters/")
        ]

parseLocation : Location -> Route
parseLocation location =
    case (parsePath matchers location) of
        Just route ->
            route
        
        Nothing ->
            CountriesRoute

countriesPath : String
countriesPath = "/countries"

countryPath : CountryName -> String
countryPath name = "/countries/" ++ (encodeUri name)

lettersPath : String
lettersPath = "/letters"