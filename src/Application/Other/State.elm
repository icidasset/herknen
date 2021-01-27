module Other.State exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Common.Item
import Group
import Group.State
import Group.Wnfs
import Html.Events.Extra.Pointer as Pointer
import List.Extra as List
import Ports
import Radix exposing (..)
import RemoteData exposing (RemoteData(..))
import Return exposing (return)
import Route
import Tag
import Unit
import Unit.State
import Url exposing (Url)
import Webnative exposing (Artifact(..), Context(..))
import Wnfs



-- 📣


authenticate : Manager
authenticate model =
    permissions
        |> Webnative.redirectToLobby Webnative.CurrentUrl
        |> Ports.webnativeRequest
        |> return model


gotWnfsResponse : Webnative.Response -> Manager
gotWnfsResponse response model =
    case Webnative.decodeResponse Tag.parse response of
        -----------------------------------------
        -- 🚀
        -----------------------------------------
        Ok ( Webnative, _, Initialisation state ) ->
            if Webnative.isAuthenticated state then
                return
                    { model | groups = Loading }
                    Group.Wnfs.ensureIndex

            else
                Return.singleton { model | groups = NotAsked }

        Ok ( Webnative, _, _ ) ->
            Return.singleton model

        -----------------------------------------
        -- 💾
        -----------------------------------------
        Ok ( Wnfs, Just (Tag.Group tag), artifact ) ->
            Group.Wnfs.manage tag artifact model

        Ok ( Wnfs, _, _ ) ->
            Return.singleton model

        -----------------------------------------
        -- 🥵
        -----------------------------------------
        Err ( maybeContext, errTyped, errString ) ->
            -- TODO: Error handling
            Return.singleton model


pointerDown : Pointer.Event -> Manager
pointerDown event model =
    let
        ( x, y ) =
            event.pointer.pagePos
    in
    Return.singleton { model | pointerStartCoordinates = Just { x = x, y = y } }


pointerUp : Pointer.Event -> Manager
pointerUp event m =
    let
        model =
            { m | pointerStartCoordinates = Nothing }

        ( endX, endY ) =
            event.pointer.pagePos
    in
    case model.route of
        -----------------------------------------
        -- Group
        -----------------------------------------
        Route.Group attr (Just { index, group }) ->
            let
                maybeStart =
                    Common.Item.findGestureTargetWithIndex group.units

                updatedUnits =
                    List.map (\u -> { u | gestureTarget = Nothing }) group.units

                updatedRoute =
                    { index = index
                    , group = { group | gestureTarget = Nothing, units = updatedUnits }
                    }
                        |> Just
                        |> Route.Group attr

                updatedModel =
                    { model | route = updatedRoute }
            in
            case ( maybeStart, m.pointerStartCoordinates ) of
                ( Just start, _ ) ->
                    let
                        ( diffX, diffY ) =
                            ( endX - start.coordinates.x
                            , endY - start.coordinates.y
                            )
                    in
                    if diffX <= -100 && abs diffY <= 100 then
                        -- Swipe left
                        Unit.State.complete { index = start.index } updatedModel

                    else if diffX >= 100 && abs diffY <= 100 then
                        -- Swipe right
                        Unit.State.remove { index = start.index } updatedModel

                    else
                        -- 🛑
                        Return.singleton updatedModel

                ( _, Just { x, y } ) ->
                    let
                        ( diffX, diffY ) =
                            ( endX - x
                            , endY - y
                            )
                    in
                    if abs diffX <= 100 && diffY >= 150 then
                        -- Swipe up
                        Return.singleton { updatedModel | route = Route.Index }

                    else if abs diffX <= 100 && diffY <= -150 then
                        -- Swipe down
                        Unit.State.create updatedModel

                    else
                        -- 🛑
                        Return.singleton updatedModel

                _ ->
                    Return.singleton updatedModel

        -----------------------------------------
        -- Index
        -----------------------------------------
        Route.Index ->
            let
                maybeStart =
                    model.groups
                        |> RemoteData.toMaybe
                        |> Maybe.andThen Common.Item.findGestureTargetWithIndex

                updatedGroups =
                    (\g -> { g | gestureTarget = Nothing })
                        |> List.map
                        |> RemoteData.map

                updatedModel =
                    { model | groups = updatedGroups model.groups }
            in
            case ( maybeStart, m.pointerStartCoordinates ) of
                ( Just start, _ ) ->
                    let
                        ( diffX, diffY ) =
                            ( endX - start.coordinates.x
                            , endY - start.coordinates.y
                            )
                    in
                    if diffX <= -100 && abs diffY <= 100 then
                        -- Swipe left
                        Group.State.complete { index = start.index } updatedModel

                    else if diffX >= 100 && abs diffY <= 100 then
                        -- Swipe right
                        Group.State.remove { index = start.index } updatedModel

                    else
                        -- 🛑
                        Return.singleton updatedModel

                ( _, Just { x, y } ) ->
                    let
                        ( diffX, diffY ) =
                            ( endX - x
                            , endY - y
                            )
                    in
                    if abs diffX <= 100 && diffY >= 150 then
                        -- Swipe up
                        Return.singleton updatedModel

                    else if abs diffX <= 100 && diffY <= -150 then
                        -- Swipe down
                        Group.State.create updatedModel

                    else
                        -- 🛑
                        Return.singleton updatedModel

                _ ->
                    Return.singleton updatedModel

        -----------------------------------------
        -- 🦉
        -----------------------------------------
        _ ->
            Return.singleton model


urlChanged : Url -> Manager
urlChanged url model =
    case Route.fromUrl url of
        Route.Group { label } Nothing ->
            let
                maybeGroup =
                    Group.findGroupAndIndexByLabel
                        label
                        (RemoteData.withDefault [] model.groups)

                route =
                    Route.Group
                        { label = label }
                        maybeGroup
            in
            Return.singleton { model | route = route }

        route ->
            Return.singleton { model | route = route }


urlRequested : UrlRequest -> Manager
urlRequested urlRequest model =
    case urlRequest of
        Internal url ->
            ( model
            , Nav.pushUrl model.navKey (Url.toString url)
            )

        External url ->
            ( model
            , Nav.load url
            )
