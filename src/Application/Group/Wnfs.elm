module Group.Wnfs exposing (..)

import Group exposing (Group)
import Group.Tag as Group exposing (Tag(..))
import Json.Decode
import Json.Encode
import List.Extra as List
import Maybe.Extra as Maybe
import Ports
import Radix exposing (..)
import RemoteData exposing (RemoteData(..))
import Return exposing (return)
import Route
import Tag
import Task
import Wnfs



-- 🌳


base : Wnfs.Base
base =
    Wnfs.AppData appPermissions



-- 📣


createIndex : Cmd Msg
createIndex =
    { path = [ "Lists" ]
    , tag = tag CreateIndex
    }
        |> Wnfs.mkdir base
        |> Ports.webnativeRequest


ensureIndex : Cmd Msg
ensureIndex =
    { path = [ "Lists" ]
    , tag = tag EnsureIndex
    }
        |> Wnfs.exists base
        |> Ports.webnativeRequest


fetch : { label : String } -> Cmd Msg
fetch { label } =
    { path = [ "Lists", label ++ ".json" ]
    , tag = tag Fetch
    }
        |> Wnfs.readUtf8 base
        |> Ports.webnativeRequest


index : Cmd Msg
index =
    { path = [ "Lists" ]
    , tag = tag Index
    }
        |> Wnfs.ls base
        |> Ports.webnativeRequest


move : Group -> Cmd Msg
move group =
    { from = [ "Lists", group.oldLabel ++ ".json" ]
    , to = [ "Lists", group.label ++ ".json" ]
    , tag = tag Mutation
    }
        |> Wnfs.mv base
        |> Ports.webnativeRequest


persist : Group -> Cmd Msg
persist group =
    group
        |> Group.encode
        |> Json.Encode.encode 0
        |> Wnfs.writeUtf8 base
            { path = [ "Lists", group.label ++ ".json" ]
            , tag = tag Mutation
            }
        |> Ports.webnativeRequest


remove : Group -> Cmd Msg
remove group =
    { path = [ "Lists", group.label ++ ".json" ]
    , tag = tag Mutation
    }
        |> Wnfs.rm base
        |> Ports.webnativeRequest



-- 📰


manage : Group.Tag -> Wnfs.Artifact -> Manager
manage t a model =
    case ( t, a ) of
        -----------------------------------------
        -- Create Index
        -----------------------------------------
        ( CreateIndex, _ ) ->
            [ Task.attempt
                (always CreateExampleGroup)
                (Task.succeed ())

            -- Publish
            , { tag = tag Published }
                |> Wnfs.publish
                |> Ports.webnativeRequest
            ]
                |> Cmd.batch
                |> Tuple.pair model

        -----------------------------------------
        -- Ensure Index
        -----------------------------------------
        ( EnsureIndex, Wnfs.Boolean False ) ->
            return model createIndex

        ( EnsureIndex, Wnfs.Boolean True ) ->
            return model index

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
                        RemoteData.map
                            (\groups ->
                                groups
                                    |> List.findIndex .isLoading
                                    |> Maybe.map (\idx -> List.setAt idx group groups)
                                    |> Maybe.withDefault groups
                            )
                            model.groups
                    )
                |> Result.withDefault
                    (RemoteData.map
                        (\groups ->
                            groups
                                |> List.findIndex .isLoading
                                |> Maybe.map (\idx -> List.removeAt idx groups)
                                |> Maybe.withDefault groups
                        )
                        model.groups
                    )
                |> (\remoteData -> { model | groups = remoteData })
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
                |> (\groups -> { model | groups = Success (sort groups) })
                |> fetchNext

        -----------------------------------------
        -- Mutation
        -----------------------------------------
        ( Mutation, _ ) ->
            { tag = tag Published }
                |> Wnfs.publish
                |> Ports.webnativeRequest
                |> return model

        -----------------------------------------
        -- 🦉
        -----------------------------------------
        _ ->
            Return.singleton model


fetchNext : Manager
fetchNext model =
    model.groups
        |> RemoteData.withDefault []
        |> lookupNext
        -----------------------------------------
        -- If next
        -----------------------------------------
        |> Maybe.map (\{ label } -> fetch { label = label })
        |> Maybe.map (Tuple.pair model)
        -----------------------------------------
        -- If finished
        -----------------------------------------
        |> Maybe.withDefault
            (case model.route of
                -- When we're expecting a group to be loaded
                -- on application start.
                Route.Group ({ label } as a) Nothing ->
                    model.groups
                        |> RemoteData.withDefault []
                        |> Group.findGroupAndIndexByLabel label
                        |> Maybe.unwrap Route.Index (Just >> Route.Group a)
                        |> (\route -> { model | route = route })
                        |> Return.singleton

                _ ->
                    Return.singleton model
            )


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
