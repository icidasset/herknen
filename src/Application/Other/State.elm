module Other.State exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Group
import Group.Wnfs
import Html.Events.Extra.Pointer as Pointer
import List.Extra as List
import Radix exposing (..)
import RemoteData
import Return exposing (return)
import Route
import Tag
import Unit
import Unit.State
import Url exposing (Url)
import Wnfs



-- 📣


gotWnfsResponse : Wnfs.Response -> Manager
gotWnfsResponse response =
    case Wnfs.decodeResponse Tag.parse response of
        Ok ( Tag.Group tag, artifact ) ->
            Group.Wnfs.manage tag artifact

        _ ->
            -- TODO: Error handling
            Return.singleton


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
    in
    case model.route of
        Route.Group attr (Just { index, group }) ->
            let
                maybeStart =
                    Unit.findGestureTargetWithIndex group.units

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

                ( endX, endY ) =
                    event.pointer.pagePos
            in
            case ( maybeStart, m.pointerStartCoordinates ) of
                ( Just start, _ ) ->
                    let
                        ( diffX, diffY ) =
                            ( endX - start.coordinates.x
                            , endY - start.coordinates.y
                            )
                    in
                    if diffX <= -100 && abs diffY < 50 then
                        -- Swipe left
                        Unit.State.complete { index = start.index } updatedModel

                    else if diffX >= 100 && abs diffY < 50 then
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
                    if abs diffX < 50 && diffY >= 150 then
                        -- Swipe up
                        Return.singleton { updatedModel | route = Route.Index }

                    else if abs diffX < 50 && diffY <= -150 then
                        -- Swipe down
                        Unit.State.create updatedModel

                    else
                        -- 🛑
                        Return.singleton updatedModel

                _ ->
                    Return.singleton updatedModel

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
