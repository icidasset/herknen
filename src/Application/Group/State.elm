module Group.State exposing (..)

import Common.State as Common
import Group exposing (Group)
import Group.Wnfs exposing (sort)
import Ports
import Radix exposing (..)
import Return exposing (return)



-- 🌳


config : Common.Config Group
config =
    { new = Group.new
    , getter = .groups
    , setter = \model groups -> { model | groups = sort groups }

    --
    , move = Group.Wnfs.move
    , persist = Group.Wnfs.persist
    , remove = Group.Wnfs.remove
    }



-- 📣


create : Manager
create =
    Common.create config


edit : { index : Int } -> Manager
edit =
    Common.edit config


finishedEditing : { index : Int, save : Bool } -> Manager
finishedEditing =
    Common.finishedEditing config


remove : { index : Int } -> Manager
remove =
    Common.remove config


updateLabel : { index : Int } -> String -> Manager
updateLabel =
    Common.updateLabel config
