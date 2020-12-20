module Group.Wnfs exposing (..)

import Group exposing (Group)
import Group.Tag as Group exposing (Tag(..))
import Json.Decode
import Json.Encode
import Ports
import Radix exposing (..)
import Return exposing (return)
import Tag
import Wnfs



-- 🌳


base : Wnfs.Base
base =
    Wnfs.AppData appPermissions



-- 📣


fetch : { label : String } -> Cmd Msg
fetch { label } =
    { path = [ "Lists", label ++ ".json" ]
    , tag = tag Fetch
    }
        |> Wnfs.read base
        |> Ports.wnfsRequest


index : Cmd Msg
index =
    { path = [ "Lists" ]
    , tag = tag Index
    }
        |> Wnfs.ls base
        |> Ports.wnfsRequest


move : Group -> Cmd Msg
move group =
    { from = [ "Lists", group.oldLabel ++ ".json" ]
    , to = [ "Lists", group.label ++ ".json" ]
    , tag = tag Mutation
    }
        |> Wnfs.mv base
        |> Ports.wnfsRequest


persist : Group -> Cmd Msg
persist group =
    group
        |> Group.encode
        |> Json.Encode.encode 0
        |> Wnfs.writeUtf8 base
            { path = [ "Lists", group.label ++ ".json" ]
            , tag = tag Mutation
            }
        |> Ports.wnfsRequest


remove : Group -> Cmd Msg
remove group =
    { path = [ "Lists", group.label ++ ".json" ]
    , tag = tag Mutation
    }
        |> Wnfs.rm base
        |> Ports.wnfsRequest



-- 📰


manage : Group.Tag -> Wnfs.Artifact -> Manager
manage t a model =
    case ( t, a ) of
        -----------------------------------------
        -- Fetch
        -----------------------------------------
        ( Fetch, Wnfs.Utf8Content json ) ->
            -- Got a single Group from WNFS,
            -- decode it and fetch the next one that isn't loaded.
            json
                |> Json.Decode.decodeString Group.decoder
                |> Result.map
                    (\group ->
                        List.map
                            (\g ->
                                if g.label == group.label then
                                    group

                                else
                                    g
                            )
                            model.groups
                    )
                |> Result.withDefault model.groups
                |> (\groups -> { model | groups = groups })
                |> fetchNext

        -----------------------------------------
        -- Index
        -----------------------------------------
        ( Index, Wnfs.DirectoryContent list ) ->
            -- Got the lists index.
            -- Make a temporary Group for each list we found.
            list
                |> List.filterMap
                    (\{ kind, name } ->
                        if kind == Wnfs.File && String.endsWith ".json" name then
                            name
                                |> String.dropRight 5
                                |> Group.temporary
                                |> Just

                        else
                            Nothing
                    )
                |> (\groups -> { model | groups = sort groups, isLoading = False })
                |> fetchNext

        -----------------------------------------
        -- Mutation
        -----------------------------------------
        ( Mutation, _ ) ->
            return model (Ports.wnfsRequest Wnfs.publish)

        -----------------------------------------
        -- 🦉
        -----------------------------------------
        _ ->
            Return.singleton model


fetchNext : Manager
fetchNext model =
    model.groups
        |> lookupNext
        |> Maybe.map (\{ label } -> fetch { label = label })
        |> Maybe.withDefault Cmd.none
        |> Tuple.pair model


lookupNext : List Group -> Maybe Group
lookupNext groups =
    case groups of
        group :: rest ->
            if group.isLoading then
                Just group

            else
                lookupNext rest

        _ ->
            Nothing



-- 🧹


sort : List Group -> List Group
sort =
    List.sortBy .label


tag : Tag -> String
tag t =
    Tag.toString (Tag.Group t)
