module Countries.PopulationData exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Msgs exposing (Msg)
import Models exposing (CountryName, PopulationData)
import RemoteData exposing (WebData)
import Routing exposing (countriesPath)

view : WebData (List PopulationData) -> Html Msg
view response =
    div []
        [ nav
        , maybeTable response
        ]
    
nav : Html Msg
nav = 
    div [ class "clearfix mb2 white bg-black" ]
        [ listBtn ]

listBtn : Html Msg
listBtn =
    a
        [ class "btn regular"
        , href countriesPath
        ]
        [ text "< Back" ]

maybeTable : WebData (List PopulationData) -> Html Msg
maybeTable response =
    case response of
        RemoteData.NotAsked ->
            text ""
            
        RemoteData.Loading ->
            text "Loading..."
        
        RemoteData.Success populationData ->
            dataTable populationData

        RemoteData.Failure error ->
            text (toString error)

dataTable : List PopulationData -> Html Msg
dataTable listPopulationData =
    div [ class "p2" ]
        [ table []
            [ thead []
                [ tr []
                    [ th [] [ text "Age" ]
                    , th [] [ text "Female Population" ]
                    , th [] [ text "Male Population" ]
                    , th [] [ text "Total Population"]
                    ]
                ]
            , tbody [] (List.map populationDataRow listPopulationData)
            ]
        ]

populationDataRow : PopulationData -> Html Msg
populationDataRow populationData =
    tr []
        [ td [] [ text (toString populationData.age) ]
        , td [] [ text (toString populationData.females) ]
        , td [] [ text (toString populationData.males) ]
        , td [] [ text (toString populationData.total) ]
        ]