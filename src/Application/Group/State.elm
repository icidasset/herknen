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
    model.groups
        |> List.indexedFoldr
            (\idx g ( acc, bool ) ->
                if idx == index then
                    if String.trim g.label == "" && not g.isNew then
                        acc
                            |> (::) { g | editing = False, label = g.oldLabel }
                            |> (\a -> ( a, bool ))

                    else
                        let
                            label =
                                String.trim g.label
                        in
                        acc
                            |> (if g.isNew then
                                    identity

                                else
                                    (::) { g | editing = False, label = label }
                               )
                            |> (\a -> ( a, label /= g.oldLabel ))

                else
                    ( g :: acc, bool )
            )
            ( [], False )
        |> (\( groups, labelChanged ) ->
                Return.singleton { model | groups = groups }
           )


remove : { index : Int } -> Manager
remove { index } model =
    model.groups
        |> List.removeAt index
        |> (\groups -> { model | groups = groups })
        |> Return.singleton


updateLabel : { index : Int } -> String -> Manager
updateLabel { index } newLabel model =
    model
        |> adjustGroupWithIndex index (\g -> { g | label = newLabel, isNew = False })
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
