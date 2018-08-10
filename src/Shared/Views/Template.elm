module Shared.Views.Template exposing(template)

import Html exposing (..)
import Msgs exposing (Msg)
import Shared.Views.Container exposing(container)
import Shared.Views.Nav exposing(navbar)

template : List (Html Msg) -> Html Msg
template childElements =
    div [ ] [ navbar, (container childElements) ]