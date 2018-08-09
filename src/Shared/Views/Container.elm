module Shared.Views.Container exposing (container)

import Html exposing (..)
import Html.Attributes exposing (class)
import Msgs exposing (Msg)

container : List (Html Msg) -> Html Msg
container contents = 
    div [ class "container-fluid" ] contents
