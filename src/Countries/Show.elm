module Countries.Show exposing (view)

import Countries.Graph exposing (maybeGraph)
import Countries.Table exposing (maybeTable)
import Html exposing (..)
import Html.Attributes exposing (class, href, type_)
import Html.Events exposing (onClick)
import Models exposing (PopulationData)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)

view : WebData (List PopulationData) -> Bool -> List (Html Msg)
view data showGraph =  [ (toggleViewButton showGraph), (dataView data showGraph) ]

toggleViewButton : Bool -> Html Msg
toggleViewButton showGraph =
    let
        buttonText = 
            case showGraph of
                True ->
                    "View as Table"
                False ->
                    "View as Graph"
    in
        button [ type_ "button", class "btn btn-outline-secondary btn-sm", onClick (Msgs.ToggleCountryView (not showGraph)) ]
            [ text buttonText]

dataView : WebData (List PopulationData) -> Bool -> Html Msg
dataView data showGraph =
    case showGraph of
        True ->
            maybeGraph data
        False ->
            maybeTable data