module Unit.State exposing (..)

import Common.State as Common
import Group exposing (Group)
import Group.Wnfs exposing (sort)
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
                Route.Group a (Just group) ->
                    let
                        updatedGroup =
                            { group | units = units }

                        updatedRoute =
                            Route.Group a (Just updatedGroup)
                    in
                    model.groups
                        |> RemoteData.withDefault []
                        |> List.map
                            (\g ->
                                -- TODO: Use index
                                if g.label == updatedGroup.label && g.icon == updatedGroup.icon then
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
    , move = groupCmd Group.Wnfs.move
    , persist = groupCmd Group.Wnfs.persist
    , remove = groupCmd Group.Wnfs.remove
    }


groupCmd : (Group -> Cmd Msg) -> Model -> Unit -> Cmd Msg
groupCmd cmdFn model _ =
    model.route
        |> Route.group
        |> Maybe.map cmdFn
        |> Maybe.withDefault Cmd.none



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
