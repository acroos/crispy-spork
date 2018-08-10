module Letters.Index exposing (..)

import Char
import Html exposing (..)
import Html.Attributes exposing (class, style, attribute)
import Shared.Utils.ListUtils exposing (getOrDefault)
import Msgs exposing (Msg)
import Svg exposing (..)
import Svg.Attributes exposing (..)

view : List Int -> List (Html Msg)
view letters =
    let
        letterCount = (List.length letters)
    in
        if letterCount <= 150 then
            [ jumbotron letterCount ]
        else
            [ graph letters
            , Html.text (toText letters)
            ]

jumbotron : Int -> Html Msg
jumbotron letterCount  =
    let
        element = 
            if letterCount == 0 then
                zeroLettersHeader
            else
                progressBar letterCount
    in
        
    div [ Html.Attributes.class "jumbotron jumbotron-fluid" ]
        [ element ]

zeroLettersHeader : Html Msg
zeroLettersHeader =
    h1 [ Html.Attributes.class "text-center display-3" ]  [ Html.text "Type something" ] 

progressBar : Int -> Html Msg
progressBar letterCount =
    let
        width = (toFloat letterCount) / 1.5
    in
        div [ Html.Attributes.class "progress" ]
            [ div 
                [ Html.Attributes.class "progress progress-bar-striped bg-info"
                , Html.Attributes.style [ ("width", ((toString width) ++ "%")) ]
                , attribute "role" "progressbar"
                , attribute "aria-valuenow" (toString letterCount)
                , attribute "aria-valuemin" (toString 0)
                , attribute "aria-valuemax" (toString 150)
                ] []
            ]

graph : List Int -> Svg Msg
graph letters =
    let
        circleData = circleDataPoints letters
    in
        svg [ width "1500px"
            , height "750px"
            ]
            (List.map letterCircle circleData)

circleDataPoints : List Int -> List(List Int)
circleDataPoints letters =
    let
        xs = List.take 50 letters
        ys = List.drop 50 (List.take 100 letters)
        ws = List.drop 100 letters
    in
        List.map3 (\x y w -> [x, y, w]) xs ys ws

letterCircle : List Int -> Svg Msg
letterCircle circleData =
    let
        rawX = (getOrDefault circleData 0 50)
        rawY = (getOrDefault circleData 1 50)
        rawR = (getOrDefault circleData 2 50)
    in
        circle 
            [ cx <| toString <| codeToXPoint <| rawX
            , cy <| toString <| codeToYPoint <| rawY
            , r <| toString <| rawR
            , fill (circleDataToFillColor rawX rawY rawR)
            ] []

codeToXPoint : Int -> Int
codeToXPoint code =
    ((code - 32) * 14) + 96

codeToYPoint : Int -> Int
codeToYPoint code =
    ((code - 32) * 6) + 96

circleDataToFillColor : Int -> Int -> Int -> String
circleDataToFillColor circleX circleY circleR =
    "rgb(" ++ (toString circleX) ++ 
    ", " ++ (toString circleY) ++ 
    ", " ++ (toString circleR) ++ ")"

toText : List Int -> String
toText letters =
    letters
    |> List.map Char.fromCode
    |> String.fromList
    |> String.reverse