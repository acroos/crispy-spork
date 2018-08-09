module Countries.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Msgs exposing (Msg)
import Models exposing (CountryList, CountryName)
import RemoteData exposing (WebData)
import Routing exposing (countryPath)
import Shared.Views.Container exposing (container)
import Shared.Views.Nav exposing (navbar)

view : WebData CountryList -> Html Msg
view response =
    div []
        [ navbar
        , container [ maybeList response ]
        ]

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
    div [ class "list-group" ] (List.map countryListItem countries)

countryListItem : CountryName -> Html Msg
countryListItem country =
    let
        path =
            countryPath country
    in
        a [ class "list-group-item", href path ]
            [ text country ]