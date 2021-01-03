module Main exposing (main)

import Browser
import Browser.Navigation
import Css.Classes as C
import Group exposing (Group)
import Group.State as Group
import Group.View as Group
import Group.Wnfs
import Html exposing (Html)
import Html.Attributes as A
import Html.Events.Extra.Pointer as Pointer
import Loaders
import Other.State as Other
import Ports
import Radix exposing (..)
import RemoteData exposing (RemoteData(..))
import Return exposing (return)
import Route
import Unit.State as Unit
import Unit.View as Unit
import Url exposing (Url)
import Welcome.View as Welcome



-- ⛩


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        }



-- 🌳


init : Flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url navKey =
    return
        { groups = Loading
        , navKey = navKey
        , pointerStartCoordinates = Nothing
        , route = Route.fromUrl url
        , url = url
        }
        Cmd.none


initPartDeux : { authenticated : Bool } -> Model -> ( Model, Cmd Msg )
initPartDeux { authenticated } model =
    if authenticated then
        return
            { model | groups = Loading }
            Group.Wnfs.ensureIndex

    else
        Return.singleton { model | groups = NotAsked }



-- 📣


update : Msg -> Model -> ( Model, Cmd Msg )
update msg =
    case msg of
        Bypass ->
            Return.singleton

        Initialise a ->
            initPartDeux a

        -----------------------------------------
        -- Group
        -----------------------------------------
        CompleteGroup a ->
            Group.complete a

        CreateExampleGroup ->
            Group.createExample

        CreateGroup ->
            Group.create

        EditGroup a ->
            Group.edit a

        FinishedEditingGroup a ->
            Group.finishedEditing a

        RemoveGroup a ->
            Group.remove a

        StartGroupGesture a b ->
            Group.startGesture a b

        UpdateGroupLabel a b ->
            Group.updateLabel a b

        -----------------------------------------
        -- Unit
        -----------------------------------------
        CompleteUnit a ->
            Unit.complete a

        CreateUnit ->
            Unit.create

        EditUnit a ->
            Unit.edit a

        FinishedEditingUnit a ->
            Unit.finishedEditing a

        RemoveUnit a ->
            Unit.remove a

        StartUnitGesture a b ->
            Unit.startGesture a b

        UpdateUnitLabel a b ->
            Unit.updateLabel a b

        -----------------------------------------
        -- 🦉
        -----------------------------------------
        Authenticate ->
            Other.authenticate

        GotWnfsResponse a ->
            Other.gotWnfsResponse a

        PointerDown a ->
            Other.pointerDown a

        PointerUp a ->
            Other.pointerUp a

        UrlChanged a ->
            Other.urlChanged a

        UrlRequested a ->
            Other.urlRequested a



-- 📰


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Ports.initialise Initialise
        , Ports.wnfsResponse GotWnfsResponse
        ]



-- 🌄


view : Model -> Browser.Document Msg
view model =
    { title = "Herknen"
    , body = [ container model ]
    }


container : Model -> Html Msg
container model =
    Html.section
        [ Pointer.onUp PointerUp
        , A.style "touch-action" "pan-y"

        --
        , Pointer.onWithOptions "pointerdown"
            { stopPropagation = False
            , preventDefault = False
            }
            PointerDown

        --
        , C.flex
        , C.h_full
        , C.items_center
        , C.justify_center
        , C.overflow_y_auto
        , C.select_none
        ]
        [ case model.groups of
            NotAsked ->
                Welcome.view

            Loading ->
                Loaders.puff 32 "currentColor"

            Failure e ->
                -- TODO
                Html.text e

            Success groups ->
                case model.route of
                    Route.Index ->
                        Group.index groups

                    Route.Group _ (Just { group }) ->
                        Unit.index group

                    Route.Group { label } _ ->
                        Loaders.puff 32 "currentColor"

                    Route.NotFound ->
                        -- TODO: Proper 404 page
                        Html.text "404"
        ]
