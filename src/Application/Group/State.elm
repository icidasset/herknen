module Group.State exposing (..)

import Common.State as Common
import Group exposing (Group)
import Group.Wnfs exposing (sort)
import Html.Events.Extra.Pointer as Pointer
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
    , move = always Group.Wnfs.move
    , persist = always Group.Wnfs.persist
    , remove = always Group.Wnfs.remove
    }



-- 📣


create : Manager
create =
    Common.create config


complete : { index : Int } -> Manager
complete { index } model =
    Return.singleton model


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
