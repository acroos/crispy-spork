module Countries.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
-- import Html.Events exposing (onClick)
import Msgs exposing (Msg)
import Models exposing (CountryList, CountryName)
import RemoteData exposing (WebData)
import Routing exposing (countryPath)

view : WebData CountryList -> Html Msg
view response =
    div []
        [ nav
        , maybeList response
        ]
    
nav : Html Msg
nav = 
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Countries" ] ]

maybeList : WebData CountryList -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""
        
        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success countryList ->
            list countryList.countries

        RemoteData.Failure error ->
            text (toString error)

list : List CountryName -> Html Msg
list countries =
    div [ class "p2" ]
        [ ul []
            (
                countries
                |> filterContinents
                |> List.map countryListItem
            )
        ]

countryListItem : CountryName -> Html Msg
countryListItem country =
    let
        path =
            countryPath country
    in
        li []
            [ a [ href path ] [ text country ] ]

filterContinents : List CountryName -> List CountryName
filterContinents countries =
    countries
    |> List.filter(isNotContinent)

isNotContinent : CountryName -> Bool
isNotContinent name =
    (String.toUpper name) /= name