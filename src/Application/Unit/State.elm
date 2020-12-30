module Unit.State exposing (..)

import Common.State as Common
import Group exposing (Group)
import Group.Wnfs exposing (sort)
import Html.Events.Extra.Pointer as Pointer
import Ports
import Radix exposing (..)
import RemoteData exposing (RemoteData(..))
import Return exposing (return)
import Route
import Unit exposing (Unit)



-- 🌳


config : Common.Config Unit
config =
    { new = Unit.new
    , getter =
        \model -> Route.units model.route
    , setter =
        \model units ->
            case model.route of
                Route.Group attr (Just { index, group }) ->
                    let
                        updatedGroup =
                            { group | units = units }

                        updatedRoute =
                            Route.Group attr (Just { index = index, group = updatedGroup })
                    in
                    model.groups
                        |> RemoteData.withDefault []
                        |> List.indexedMap
                            (\i g ->
                                if i == index then
                                    updatedGroup

                                else
                                    g
                            )
                        |> (\groups ->
                                { model
                                    | groups = Success groups
                                    , route = updatedRoute
                                }
                           )

                route ->
                    model
    , sorter = identity

    --
    , move = \m _ -> groupCmd Group.Wnfs.persist m
    , persist = \m _ -> groupCmd Group.Wnfs.persist m
    , remove = \m _ -> groupCmd Group.Wnfs.persist m
    }


groupCmd : (Group -> Cmd Msg) -> Model -> Cmd Msg
groupCmd cmdFn model =
    model.route
        |> Route.group
        |> Maybe.map cmdFn
        |> Maybe.withDefault Cmd.none



-- 📣


create : Manager
create =
    Common.create config


complete : { index : Int } -> Manager
complete { index } model =
    model
        |> Common.adjustItemWithIndex
            config
            index
            (\unit -> { unit | isDone = not unit.isDone })
        |> Return.singleton
        |> Return.effect_ (groupCmd Group.Wnfs.persist)


edit : { index : Int } -> Manager
edit =
    Common.edit config


finishedEditing : { index : Int, save : Bool } -> Manager
finishedEditing =
    Common.finishedEditing config


remove : { index : Int } -> Manager
remove =
    Common.remove config


startGesture : { index : Int } -> Pointer.Event -> Manager
startGesture =
    Common.startGesture config


updateLabel : { index : Int } -> String -> Manager
updateLabel =
    Common.updateLabel config
