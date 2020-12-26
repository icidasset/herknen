module Main exposing (main)

import Browser
import Browser.Navigation
import Group exposing (Group)
import Group.State as Group
import Group.View as Group
import Group.Wnfs
import Html
import Loaders
import Other.State as Other
import Ports
import Radix exposing (..)
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
        { authenticated = False
        , isLoading = True
        , groups = []
        , navKey = navKey
        , route = Route.Index
        , url = url
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
        Bypass ->
            Return.singleton

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
        -- Unit
        -----------------------------------------
        CreateUnit ->
            Unit.create

        EditUnit a ->
            Unit.edit a

        FinishedEditingUnit a ->
            Unit.finishedEditing a

        RemoveUnit a ->
            Unit.remove a

        UpdateUnitLabel a b ->
            Unit.updateLabel a b

        -----------------------------------------
        -- 🦉
        -----------------------------------------
        GotWnfsResponse a ->
            Other.gotWnfsResponse a

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
    , body =
        [ if model.isLoading then
            Loaders.puff 32 "currentColor"

          else if model.authenticated then
            case model.route of
                Route.Index ->
                    Group.index model

                Route.Group _ (Just group) ->
                    Unit.index group.units

                Route.Group { label } _ ->
                    -- TODO: Loading
                    Html.text ("Loading " ++ label)

                Route.NotFound ->
                    -- TODO: Proper 404 page
                    Html.text "404"

          else
            Welcome.view
        ]
    }
