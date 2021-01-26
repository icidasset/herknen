module Group.State exposing (..)

import Bounce
import Common.State as Common
import Group exposing (Group)
import Group.Wnfs exposing (sort)
import Html.Events.Extra.Pointer as Pointer
import List.Extra as List
import Ports
import Radix exposing (..)
import RemoteData exposing (RemoteData(..))
import Return exposing (return)



-- 🌳


config : Common.Config Group
config =
    { new = Group.new
    , getter = .groups >> RemoteData.withDefault []
    , setter = \model groups -> { model | groups = Success groups }
    , sorter = sort

    --
    , move = \m -> Group.Wnfs.move >> return m
    , persist = \m -> Group.Wnfs.persist >> return m
    , remove = \m -> Group.Wnfs.remove >> return m
    }



-- 📣


create : Manager
create =
    Common.create config


createExample : Manager
createExample model =
    let
        example =
            Group.example
    in
    { model | groups = Success [ example ] }
        |> Return.singleton
        |> Return.command (Group.Wnfs.persist example)


complete : { index : Int } -> Manager
complete { index } model =
    model
        |> Common.adjustItemWithIndex
            config
            index
            Group.markAllAsDone
        |> Return.singleton
        |> Return.effect_
            (\newModel ->
                newModel.groups
                    |> RemoteData.toMaybe
                    |> Maybe.andThen (List.getAt index)
                    |> Maybe.map Group.Wnfs.persist
                    |> Maybe.withDefault Cmd.none
            )


edit : { index : Int } -> Manager
edit =
    Common.edit config


finishedEditing : { index : Int } -> Manager
finishedEditing =
    Common.finishedEditing config


persistIfSteady : Manager
persistIfSteady model =
    let
        newBounce =
            Bounce.pop model.groupsBounce

        groups =
            if Bounce.steady newBounce then
                RemoteData.map
                    (List.map (\group -> { group | persisted = True }))
                    model.groups

            else
                model.groups
    in
    return
        { model | groups = groups, groupsBounce = newBounce }
        (if Bounce.steady newBounce then
            model.groups
                |> RemoteData.withDefault []
                |> List.filter (.persisted >> (==) False)
                |> List.map Group.Wnfs.persist
                |> Cmd.batch

         else
            Cmd.none
        )


remove : { index : Int } -> Manager
remove =
    Common.remove config


startGesture : { index : Int } -> Pointer.Event -> Manager
startGesture =
    Common.startGesture config


updateLabel : { index : Int } -> String -> Manager
updateLabel =
    Common.updateLabel config
