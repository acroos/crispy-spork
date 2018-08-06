module Countries.PopulationGraph exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href)
import Msgs exposing (Msg)
import Models exposing (CountryName, PopulationData)
import RemoteData exposing (WebData)
import Routing exposing (countriesPath)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Visualization.Axis as Axis exposing (defaultOptions)
import Visualization.Scale as Scale exposing (ContinuousScale)

view : WebData (List PopulationData) -> Html Msg
view response =
    div []
        [ nav
        , maybeGraph response
        ]

nav : Html Msg
nav = 
    div [ ] [ listBtn ]

listBtn : Html Msg
listBtn =
    Html.a
        [ href countriesPath ]
        [ Html.text "< Back" ]

maybeGraph : WebData (List PopulationData) -> Svg Msg
maybeGraph response =
    case response of
        RemoteData.NotAsked ->
            Html.text ""
            
        RemoteData.Loading ->
            Html.text "Loading..."
        
        RemoteData.Success populationData ->
            graph populationData

        RemoteData.Failure error ->
            Html.text (toString error)

w : Float
w = 
    1500

h : Float
h =
    750

padding : Float
padding = 
    80

maxTotalValue : List PopulationData -> Float
maxTotalValue list =
    let
        totalList = (List.map (\d -> (toFloat d.total)) list)
    in
        maxWithDefault totalList 100000.0

maxWithDefault : List Float -> Float -> Float
maxWithDefault list default =
    case(List.maximum list) of
        Just number ->
            number
        
        Nothing ->
            default

xScale : List PopulationData -> ContinuousScale
xScale list =
    Scale.linear ( 0, toFloat <| List.length <| list ) ( 0, w - 2 * padding )

yScale : List PopulationData -> ContinuousScale
yScale list =
    let
        maxY = (maxTotalValue list)

    in
        Scale.linear ( 0, maxY ) ( h - (2 * padding), 0 )

xAxis : List PopulationData -> Svg msg
xAxis list =
    Axis.axis { defaultOptions | orientation = Axis.Bottom }
         (xScale list)

yAxis : List PopulationData -> Svg msg
yAxis list =
    Axis.axis { defaultOptions | orientation = Axis.Left, tickCount = 20 } (yScale list)

columnDataText : PopulationData -> Svg msg
columnDataText data =
    let
        text = "Age: " ++ (toString data.age)
            ++ "Females: " ++ (toString data.females)
            ++ "Males: " ++ (toString data.males)
            ++ "Total: " ++ (toString data.total)
    in
        Svg.text text

maleColumn : ContinuousScale -> ContinuousScale -> PopulationData -> Svg msg
maleColumn xScale yScale data =
    g [ class "male-column" ]
        [ rect
            [ x <| toString <| Scale.convert xScale <| toFloat <| data.age
            , y <| toString <| Scale.convert yScale <| toFloat <| data.males
            , width <| toString <| (w - (2 * padding)) / 100 
            , height <| toString <| h - Scale.convert yScale (toFloat data.males) - 2 * padding
            ]
            []
        ]

femaleColumn : ContinuousScale -> ContinuousScale -> PopulationData -> Svg msg
femaleColumn xScale yScale data =
    g [ class "female-column" ]
        [ rect
            [ x <| toString <| Scale.convert xScale <| toFloat <| data.age
            , y <| toString <| Scale.convert yScale <| toFloat <| (data.males + data.females)
            , width <| toString <| (w - (2 * padding)) / 100 
            , height <| toString <| h - Scale.convert yScale (toFloat data.females) - 2 * padding
            ]
            []
        ]

column : ContinuousScale -> ContinuousScale -> PopulationData -> Svg msg
column xScale yScale data =
    g [ class "column" ]
        [ rect
            [ x <| toString <| Scale.convert xScale <| toFloat <| data.age
            , y <| toString <| Scale.convert yScale <| toFloat <| data.total
            , width <| toString <| (w - (2 * padding)) / 100 
            , height <| toString <| h - Scale.convert yScale (toFloat data.total) - 2 * padding
            ]
            []
        , text_
            [ x <| toString <| Scale.convert xScale (toFloat data.age)
            , y <| toString <| Scale.convert yScale (toFloat data.total)
            , textAnchor "middle"
            ]
            [ columnDataText data ]
        ]

graph : List PopulationData -> Svg Msg
graph model =
    svg [ Svg.Attributes.width (toString w ++ "px"), Svg.Attributes.height (toString h ++ "px") ]
        [ Svg.style [] [ Svg.text """
            .male-column rect { fill: rgba(0, 0, 255, 0.8); }
            .female-column rect { fill: rgba(255, 192, 203, 0.8); }
            .column rect { fill: rgba(255, 255, 255, 0.1); }
            .column text { display: none; }
            .column:hover rect { fill: rgb(255, 255, 255, 0.3); }
            .column:hover text { display: inline; }
          """ ]
        , g [ transform ("translate(" ++ toString (padding - 1) ++ ", " ++ toString (h - padding) ++ ")") ]
            [ xAxis model ]
        , g [ transform ("translate(" ++ toString (padding - 1) ++ ", " ++ toString padding ++ ")") ]
            [ yAxis model ]
        , g [ transform ("translate(" ++ toString padding ++ ", " ++ toString padding ++ ")"), Svg.Attributes.class "series" ] 
            (List.map (maleColumn (xScale model) (yScale model)) model)
        , g [ transform ("translate(" ++ toString padding ++ ", " ++ toString padding ++ ")"), Svg.Attributes.class "series" ] 
            (List.map (femaleColumn (xScale model) (yScale model)) model)
        , g [ transform ("translate(" ++ toString padding ++ ", " ++ toString padding ++ ")"), Svg.Attributes.class "series" ] 
            (List.map (column (xScale model) (yScale model)) model)
        ]