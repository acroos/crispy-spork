module Countries.PopulationGraph exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
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
    div [ Html.Attributes.class "clearfix mb2 white bg-black" ]
        [ listBtn ]

listBtn : Html Msg
listBtn =
    Html.a
        [ Html.Attributes.class "btn regular"
        , href countriesPath
        ]
        [ Html.text "< Back" ]

maybeGraph : WebData (List PopulationData) -> Svg Msg
maybeGraph response =
    case response of
        RemoteData.NotAsked ->
            Html.text ""
            
        RemoteData.Loading ->
            Html.text "Loading..."
        
        RemoteData.Success populationData ->
            graph (List.map (\d -> (d.age, d.total)) populationData)

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

xScale : ContinuousScale
xScale =
    Scale.linear ( 0, 100 ) ( 0, w - 2 * padding )

yScale : List ( Int, Int ) -> ContinuousScale
yScale list =
    let
        maxY =
            case (List.maximum(List.map Tuple.second list)) of
                Just number ->
                    (toFloat number)
                
                Nothing ->
                    100000.0

    in
        Scale.linear ( 0, maxY ) ( h - (2 * padding), 0 )

xAxis : List ( Int, Int ) -> Svg msg
xAxis list =
    Axis.axis { defaultOptions | orientation = Axis.Bottom }
         (xScale)

yAxis : List ( Int, Int ) -> Svg msg
yAxis list =
    Axis.axis { defaultOptions | orientation = Axis.Left, tickCount = 20 } (yScale list)

column : ContinuousScale -> ContinuousScale -> ( Int, Int ) -> Svg msg
column xScale yScale ( age, count ) =
    g [ Svg.Attributes.class "column" ]
        [ rect
            [ x <| toString <| Scale.convert xScale (toFloat age)
            , y <| toString <| Scale.convert yScale (toFloat count)
            , width <| toString <| (w - (2 * padding)) / 100 
            , height <| toString <| h - Scale.convert yScale (toFloat count) - 2 * padding
            ]
            []
        , text_
            [ x <| toString <| Scale.convert xScale (toFloat age)
            , y <| toString <| Scale.convert yScale (toFloat count)
            , textAnchor "middle"
            ]
            [ Svg.text <| toString count ]
        ]

graph : List ( Int, Int ) -> Svg Msg
graph model =
    svg [ Svg.Attributes.width (toString w ++ "px"), Svg.Attributes.height (toString h ++ "px") ]
        [ Svg.style [] [ Svg.text """
            .column rect { fill: rgba(118, 214, 78, 0.8); }
            .column text { display: none; }
            .column:hover rect { fill: rgb(118, 214, 78); }
            .column:hover text { display: inline; }
          """ ]
        , g [ transform ("translate(" ++ toString (padding - 1) ++ ", " ++ toString (h - padding) ++ ")") ]
            [ xAxis model ]
        , g [ transform ("translate(" ++ toString (padding - 1) ++ ", " ++ toString padding ++ ")") ]
            [ yAxis model ]
        , g [ transform ("translate(" ++ toString padding ++ ", " ++ toString padding ++ ")"), Svg.Attributes.class "series" ] <|
            List.map (column xScale (yScale model)) model
        ]