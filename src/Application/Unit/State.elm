module Unit.State exposing (..)

import Bounce
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
                            { group | units = units, persisted = False }

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
    , move = \m _ -> persistGroupsMomentarily m
    , persist = \m _ -> persistGroupsMomentarily m
    , remove = \m _ -> persistGroupsMomentarily m
    }


persistGroupsMomentarily : Manager
persistGroupsMomentarily model =
    return
        { model | groupsBounce = Bounce.push model.groupsBounce }
        (Bounce.delay 1500 PersistGroupsIfSteady)



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
        |> persistGroupsMomentarily


edit : { index : Int } -> Manager
edit =
    Common.edit config


finishedEditing : { index : Int } -> Manager
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
