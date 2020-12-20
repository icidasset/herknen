module Main exposing (main)

import Browser
import Browser.Navigation
import Group exposing (Group)
import Group.State as Group
import Group.View as Group
import Group.Wnfs
import Loaders
import Ports
import Radix exposing (..)
import Return exposing (return)
import Tag
import Url exposing (Url)
import Welcome.View as Welcome
import Wnfs



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
init _ _ _ =
    return
        { authenticated = False
        , isLoading = True
        , groups = []
        }
        Cmd.none


initPartDeux : { authenticated : Bool } -> Model -> ( Model, Cmd Msg )
initPartDeux { authenticated } model =
    return
        { model
            | authenticated = authenticated
            , isLoading = authenticated
        }
        (if authenticated then
            Group.Wnfs.index

         else
            Cmd.none
        )



-- 📣


update : Msg -> Model -> ( Model, Cmd Msg )
update msg =
    case msg of
        Initialise a ->
            initPartDeux a

        -----------------------------------------
        -- Group
        -----------------------------------------
        CreateGroup ->
            Group.create

        EditGroup a ->
            Group.edit a

        FinishedEditingGroup a ->
            Group.finishedEditing a

        RemoveGroup a ->
            Group.remove a

        UpdateGroupLabel a b ->
            Group.updateLabel a b

        -----------------------------------------
        -- 🦉
        -----------------------------------------
        GotWnfsResponse a ->
            case Wnfs.decodeResponse Tag.parse a of
                Ok ( Tag.Group tag, artifact ) ->
                    Group.Wnfs.manage tag artifact

                _ ->
                    -- TODO: Error handling
                    Return.singleton

        UrlChanged a ->
            -- TODO
            Return.singleton

        UrlRequested a ->
            -- TODO
            Return.singleton



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
    , body =
        [ if model.isLoading then
            Loaders.puff 32 "currentColor"

          else if model.authenticated then
            Group.index model

          else
            Welcome.view
        ]
    }
