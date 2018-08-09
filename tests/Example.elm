module Example exposing (..)

import Expect exposing (Expectation, equal)
import Test exposing (..)


suite : Test
suite =
    describe "App Tests"
        [
            test "Passes" <|
                \_  -> equal True True
        ]
