module Group.State exposing (..)

import Group exposing (Group)
import Group.Wnfs exposing (sort)
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
            (\idx g ( acc, changedGroup ) ->
                if idx == index then
                    if String.trim g.label == "" && not g.isNew then
                        acc
                            |> (::) { g | editing = False, label = g.oldLabel }
                            |> (\a -> ( a, changedGroup ))

                    else
                        let
                            label =
                                String.trim g.label

                            group =
                                { g | editing = False, label = label }
                        in
                        acc
                            |> (if g.isNew then
                                    identity

                                else
                                    (::) group
                               )
                            |> (\a ->
                                    ( a
                                    , if label /= g.oldLabel then
                                        Just group

                                      else
                                        Nothing
                                    )
                               )

                else
                    ( g :: acc, changedGroup )
            )
            ( [], Nothing )
        |> (\( groups, changedGroup ) ->
                return
                    { model | groups = sort groups }
                    (case changedGroup of
                        Just group ->
                            if group.oldLabel == "" then
                                Group.Wnfs.persist group

                            else
                                Group.Wnfs.move group

                        Nothing ->
                            Cmd.none
                    )
           )


remove : { index : Int } -> Manager
remove { index } model =
    model.groups
        |> List.indexedFoldr
            (\idx group ( acc, maybeDeletedGroup ) ->
                if idx == index then
                    ( acc, Just group )

                else
                    ( group :: acc, maybeDeletedGroup )
            )
            ( [], Nothing )
        |> (\( groups, maybeDeletedGroup ) ->
                return
                    { model | groups = groups }
                    (case maybeDeletedGroup of
                        Just deletedGroup ->
                            Group.Wnfs.remove deletedGroup

                        Nothing ->
                            Cmd.none
                    )
           )


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
