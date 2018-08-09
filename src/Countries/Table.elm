module Countries.Table exposing (maybeTable)

import Html exposing (..)
import Html.Attributes exposing (class, scope, type_)
import Msgs exposing (Msg)
import Models exposing (CountryName, PopulationData)
import RemoteData exposing (WebData)
import Shared.Utils.StringUtils exposing (toCommaString)

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
    table [ class "table table-striped table-hover table-sm" ]
        [ tableHead
        , tbody [] (List.map populationDataRow listPopulationData)
        ]

tableHead : Html Msg
tableHead = 
    thead []
        [ tr []
            [ tableHeadItem "Age"
            , tableHeadItem "Female Population"
            , tableHeadItem "Male Population" 
            , tableHeadItem "Total Population"
            ]
        ]

tableHeadItem : String -> Html Msg
tableHeadItem title =
    th [ scope "col" ] [ text title ]

populationDataRow : PopulationData -> Html Msg
populationDataRow populationData =
    tr []
        [ tableDataItem (intToCommaString populationData.age)
        , tableDataItem (intToCommaString populationData.females)
        , tableDataItem (intToCommaString populationData.males)
        , tableDataItem (intToCommaString populationData.total)
        ]

intToCommaString : Int -> String
intToCommaString num =
    num
    |> toString
    |> toCommaString

tableDataItem : String -> Html Msg
tableDataItem data =
    td [] [ text data ]