module Letters.Index exposing (..)

import Char
import Html exposing (..)
import Html.Attributes exposing (class, style, attribute)
import Shared.Utils.ListUtils exposing (partition, getOrDefault)
import Msgs exposing (Msg)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)

view : List Int -> List (Html Msg)
view letters =
    let
        letterCount = (List.length letters)
    in
        if letterCount < 3 then
            [ jumbotron letterCount ]
        else
            [ graph letters ]

jumbotron : Int -> Html Msg
jumbotron letterCount  =
    div [ Html.Attributes.class "jumbotron jumbotron-fluid" ]
        [ h1 [ Html.Attributes.class "text-center display-3" ] [ Html.text "Type something" ] ]

graphWidth : Float
graphWidth =
    1500.0

graphHeight : Float
graphHeight =
    750.0

graph : List Int -> Svg Msg
graph letters =
    let
        circleData = circleDataPoints letters
    in
        svg [ width ((toString graphWidth) ++ "px")
            , height ((toString graphHeight) ++ "px")
            ]
            (List.map letterCircle circleData)

circleDataPoints : List Int -> List(List Int)
circleDataPoints letters =
    partition letters 3

letterCircle : List Int -> Svg Msg
letterCircle circleData =
    let
        rawX = getOrDefault circleData 0 50
        rawY = getOrDefault circleData 1 50
        rawR = getOrDefault circleData 2 50
    in
        circle 
            [ cx <| toString <| codeToXPoint <| rawX
            , cy <| toString <| codeToYPoint <| rawY
            , r <| toString <| rawR
            , fill (circleDataToFillColor rawX rawY rawR)
            ] []

codeToXPoint : Int -> Float
codeToXPoint code =
    randomFloatFromCode (code * code) 0.0 graphWidth

codeToYPoint : Int -> Float
codeToYPoint code =
    randomFloatFromCode (code * code * code) 0.0 graphHeight

codeToRadius : Int -> Float
codeToRadius code =
    randomFloatFromCode (code // 2) 0.0 500.0

randomFloatFromCode : Int -> Float -> Float -> Float
randomFloatFromCode code min max =
    let
        seed = Random.initialSeed code
    in
        Tuple.first (Random.step (Random.float min max) seed)

codeToColor : Int -> Int
codeToColor code =
    floor <| (randomFloatFromCode code 0.0 255.0)

codeToOpacity : Int -> Float
codeToOpacity code =
    (randomFloatFromCode code 0.1 0.9)

circleDataToFillColor : Int -> Int -> Int -> String
circleDataToFillColor circleX circleY circleR =
    "rgba(" ++ (toString (codeToColor circleX)) ++ 
    ", " ++ (toString (codeToColor circleY)) ++ 
    ", " ++ (toString (codeToColor circleR)) ++
    ", " ++ (toString (codeToOpacity (circleX + circleY + circleR))) ++ ")"