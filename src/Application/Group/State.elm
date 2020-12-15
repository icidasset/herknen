module Group.State exposing (..)

import Group exposing (Group)
import List.Extra as List
import Ports
import Radix exposing (..)
import Return exposing (return)



-- 📣


create : Manager
create model =
    model.groups
        |> List.last
        |> Maybe.map .isNew
        |> Maybe.withDefault False
        |> (\lastIsNew ->
                if lastIsNew then
                    model.groups

                else
                    model.groups ++ [ Group.new ]
           )
        |> (\groups ->
                { model | groups = groups }
           )
        |> Return.singleton
        |> Return.command (Ports.focusOnTextInput ())


edit : { index : Int } -> Manager
edit { index } model =
    model
        |> adjustGroupWithIndex
            index
            (\g -> { g | editing = True, isNew = False, oldLabel = g.label })
        |> Return.singleton
        |> Return.command (Ports.focusOnTextInput ())


finishedEditing : { index : Int, save : Bool } -> Manager
finishedEditing { index, save } model =
    model
        |> adjustGroupWithIndex
            index
            (\g ->
                if String.trim g.label == "" && not g.isNew then
                    { g | editing = False, label = g.oldLabel }

                else
                    { g | editing = False, label = String.trim g.label }
            )
        |> (\m ->
                { m | groups = List.filter (.isNew >> not) m.groups }
           )
        |> Return.singleton
        |> Return.command
            (if save then
                Cmd.none

             else
                Cmd.none
            )


updateLabel : { index : Int } -> String -> Manager
updateLabel { index } newLabel model =
    model
        |> adjustGroupWithIndex index (\g -> { g | label = newLabel })
        |> Return.singleton



-- 🛠


adjustGroupWithIndex : Int -> (Group -> Group) -> Model -> Model
adjustGroupWithIndex index mapFn model =
    model.groups
        |> List.indexedMap
            (\idx group ->
                if idx == index then
                    mapFn group

                else
                    group
            )
        |> (\groups -> { model | groups = groups })
