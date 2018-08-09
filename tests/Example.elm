module Example exposing (..)

import Expect exposing (Expectation, equal)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "App Tests"
        [
            test "Passes" <|
                \_  -> equal True True
        ]
