module Shared.Utils.StringUtils exposing (toCommaString)

toCommaString : String -> String
toCommaString str =
  let
    len = String.length str
  in
    if len < 4 then
      str
    else
      (toCommaString (String.slice 0 (len - 3) str)) ++ "," ++ (String.right 3 str)