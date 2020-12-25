module Common.State exposing (..)

import Common.Item exposing (Item)
import List.Extra as List
import Ports
import Radix exposing (..)
import Return exposing (return)



-- 🌳


type alias Config item =
    { new : Item item
    , getter : Model -> List (Item item)
    , setter : Model -> List (Item item) -> Model

    -- Commands
    -----------
    , move : Item item -> Cmd Msg
    , persist : Item item -> Cmd Msg
    , remove : Item item -> Cmd Msg
    }



-- 📣


create : Config item -> Manager
create config model =
    let
        items =
            config.getter model
    in
    items
        |> List.last
        |> Maybe.map .isNew
        |> Maybe.withDefault False
        |> (\lastIsNew ->
                if lastIsNew then
                    items

                else
                    items ++ [ config.new ]
           )
        |> config.setter model
        |> Return.singleton
        |> Return.command (Ports.focusOnTextInput ())


edit : Config item -> { index : Int } -> Manager
edit config { index } model =
    model
        |> adjustItemWithIndex
            config
            index
            (\i -> { i | editing = True, isNew = False, oldLabel = i.label })
        |> Return.singleton
        |> Return.command (Ports.focusOnTextInput ())


finishedEditing : Config item -> { index : Int, save : Bool } -> Manager
finishedEditing config { index, save } model =
    model
        |> config.getter
        |> List.indexedFoldr
            (\idx i ( acc, changedItem ) ->
                if idx == index then
                    if String.trim i.label == "" && not i.isNew then
                        acc
                            |> (::) { i | editing = False, label = i.oldLabel }
                            |> (\a -> ( a, changedItem ))

                    else
                        let
                            label =
                                String.trim i.label

                            group =
                                { i | editing = False, label = label }
                        in
                        acc
                            |> (if i.isNew then
                                    identity

                                else
                                    (::) group
                               )
                            |> (\a ->
                                    ( a
                                    , if label /= i.oldLabel then
                                        Just group

                                      else
                                        Nothing
                                    )
                               )

                else
                    ( i :: acc, changedItem )
            )
            ( [], Nothing )
        |> (\( items, changedItem ) ->
                return
                    (config.setter model items)
                    (case ( save, changedItem ) of
                        ( True, Just item ) ->
                            if item.oldLabel == "" then
                                config.persist item

                            else
                                config.move item

                        _ ->
                            Cmd.none
                    )
           )


remove : Config item -> { index : Int } -> Manager
remove config { index } model =
    model
        |> config.getter
        |> List.indexedFoldr
            (\idx item ( acc, maybeDeletedItem ) ->
                if idx == index then
                    ( acc, Just item )

                else
                    ( item :: acc, maybeDeletedItem )
            )
            ( [], Nothing )
        |> (\( items, maybeDeletedItem ) ->
                return
                    (config.setter model items)
                    (case maybeDeletedItem of
                        Just deletedItem ->
                            config.remove deletedItem

                        Nothing ->
                            Cmd.none
                    )
           )


updateLabel : Config item -> { index : Int } -> String -> Manager
updateLabel config { index } newLabel model =
    model
        |> adjustItemWithIndex config index (\i -> { i | label = newLabel, isNew = False })
        |> Return.singleton



-- 🛠


adjustItemWithIndex : Config item -> Int -> (Item item -> Item item) -> Model -> Model
adjustItemWithIndex config index mapFn model =
    model
        |> config.getter
        |> List.indexedMap
            (\idx item ->
                if idx == index then
                    mapFn item

                else
                    item
            )
        |> config.setter model
