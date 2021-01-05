module Common.State exposing (..)

import Common.Item exposing (Item)
import Html.Events.Extra.Pointer as Pointer
import List.Extra as List
import Ports
import Radix exposing (..)
import Return exposing (return)



-- 🌳


type alias Config item =
    { new : Item item
    , getter : Model -> List (Item item)
    , setter : Model -> List (Item item) -> Model
    , sorter : List (Item item) -> List (Item item)

    -- Commands
    -----------
    , move : Model -> Item item -> ( Model, Cmd Msg )
    , persist : Model -> Item item -> ( Model, Cmd Msg )
    , remove : Model -> Item item -> ( Model, Cmd Msg )
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
            (\i -> { i | isEditing = True, isNew = False, oldLabel = i.label })
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
                            |> (::) { i | isEditing = False, label = i.oldLabel }
                            |> (\a -> ( a, changedItem ))

                    else
                        let
                            label =
                                String.trim i.label

                            item =
                                { i | isEditing = False, label = label, isNew = False }
                        in
                        acc
                            |> (if String.isEmpty label then
                                    identity

                                else
                                    (::) item
                               )
                            |> (\a ->
                                    ( a
                                    , if label /= i.oldLabel then
                                        Just item

                                      else
                                        Nothing
                                    )
                               )

                else
                    ( i :: acc, changedItem )
            )
            ( [], Nothing )
        |> (\( items, changedItem ) ->
                items
                    |> config.sorter
                    |> config.setter model
                    |> Return.singleton
                    |> Return.andThen
                        (\newModel ->
                            case ( save, changedItem ) of
                                ( True, Just item ) ->
                                    if item.oldLabel == "" then
                                        config.persist newModel item

                                    else
                                        config.move newModel item

                                _ ->
                                    Return.singleton newModel
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
                items
                    |> config.setter model
                    |> Return.singleton
                    |> Return.andThen
                        (\newModel ->
                            case maybeDeletedItem of
                                Just deletedItem ->
                                    config.remove newModel deletedItem

                                Nothing ->
                                    Return.singleton newModel
                        )
           )


startGesture : Config item -> { index : Int } -> Pointer.Event -> Manager
startGesture config { index } event model =
    model
        |> config.getter
        |> List.indexedMap
            (\idx item ->
                if idx == index then
                    let
                        ( x, y ) =
                            event.pointer.pagePos

                        target =
                            Just { x = x, y = y }
                    in
                    { item | gestureTarget = target }

                else
                    { item | gestureTarget = Nothing }
            )
        |> config.setter model
        |> Return.singleton


updateLabel : Config item -> { index : Int } -> String -> Manager
updateLabel config { index } newLabel model =
    model
        |> adjustItemWithIndex config index (\i -> { i | label = newLabel })
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
