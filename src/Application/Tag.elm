module Tag exposing (..)

import Group.Tag as Group



-- 🌳


type Tag
    = Group Group.Tag


separator : String
separator =
    "__"



-- 🛠


toString : Tag -> String
toString tag =
    case tag of
        Group groupTag ->
            "Group" ++ separator ++ Group.enum.toString groupTag


parse : String -> Result String Tag
parse string =
    case String.split separator string of
        [ "Group", suffix ] ->
            suffix
                |> Group.enum.fromString
                |> Result.fromMaybe "Unknown group tag"
                |> Result.map Group

        _ ->
            Err "Unknown tag"
