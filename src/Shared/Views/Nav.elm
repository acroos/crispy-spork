module Shared.Views.Nav exposing (navbar)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, href, type_)
import Msgs exposing (Msg)
import Routing exposing (countriesPath)

navbar : Html Msg
navbar =
    nav [ class "navbar navbar-expand-lg navbar-light bg-light" ]
        [ logo, toggler, menu ]

logo : Html Msg
logo = 
    span [ class "navbar-brand" ]
        [ text "Crispy Spork" ]

menu : Html Msg
menu = 
    div [ class "collapse navbar-collapse" ]
    [ ul [ class "navbar-nav" ]
        [ (navItem "Countries List" countriesPath)
        , (navItem "Page 2" "#")
        , (navItem "Page 3" "#")
        ]
    ]

navItem : String -> String -> Html Msg
navItem title url =
    li [ class "nav-item" ] 
        [ a [ class "nav-link", href url ]
            [ text title ]
        ]

toggler : Html Msg
toggler = 
    button [ class "navbar-toggler"
           , type_ "button"
           , attribute "data-toggle" "collapse"
           , attribute "data-target" "#navbarNav"
           , attribute "aria-controls" "navbarNav"
           , attribute "aria-expanded" "false"
           , attribute "aria-label" "Toggle navigation"
           ]
        [ span [ class "navbar-toggler-icon"] [] ]