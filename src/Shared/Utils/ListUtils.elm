module Shared.Utils.ListUtils exposing (getOrDefault)

getOrDefault : List a -> Int -> a -> a
getOrDefault list index default =
    let
        maybeVal = (List.head (List.drop index list))
    in
        case maybeVal of
            Just a ->
                a

            Nothing ->
                default