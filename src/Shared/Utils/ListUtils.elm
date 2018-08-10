module Shared.Utils.ListUtils exposing (partition, getOrDefault)

-- This function takes in a list and a partition size.  It splits
-- the list up into sub-lists of the partition size
-- NOTE: (List.length list) % size != 0, there remaining data will be left out
partition : List a -> Int -> List (List a)
partition list size =
    partitionHelper list size []

partitionHelper : List a -> Int -> List (List a) -> List (List a)
partitionHelper list size result =
    if (List.length list < 3) then
        result
    else
        partitionHelper (List.drop size list) size (result ++ [List.take size list])

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