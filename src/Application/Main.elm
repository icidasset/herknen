module Main exposing (main)

import Browser
import Browser.Navigation
import Css.Classes as C
import Group exposing (Group)
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Keyboard exposing (Key(..))
import Keyboard.Events as Keyboard
import Material.Icons.Round as Icons
import Material.Icons.Types exposing (Coloring(..))
import Ports
import Radix exposing (..)
import Return exposing (return)
import Theme
import Unit exposing (Unit)
import Url exposing (Url)
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
    Tuple.pair
        { groups =
            [ { icon = Group.iconFromString "assignments"
              , label = "Grocery List"
              , units =
                    []

              --
              , editing = False
              , isNew = False
              }
            , { icon = Group.iconFromString "assignments"
              , label = "To do"
              , units =
                    []

              --
              , editing = False
              , isNew = False
              }
            , { icon = Group.iconFromString "assignments"
              , label = "A"
              , units =
                    []

              --
              , editing = False
              , isNew = False
              }
            , { icon = Group.iconFromString "assignments"
              , label = "B"
              , units =
                    []

              --
              , editing = False
              , isNew = False
              }
            , { icon = Group.iconFromString "assignments"
              , label = "C"
              , units =
                    []

              --
              , editing = False
              , isNew = False
              }
            ]
        , newGroupLabel = Nothing
        }
        Cmd.none



-- 📣


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CreateGroup ->
            return
                { model | groups = model.groups ++ [ Group.new ] }
                (Ports.focusOnTextInput ())

        EditGroup { index, label } ->
            model.groups
                |> List.indexedMap
                    (\groupIdx group ->
                        if groupIdx == index then
                            { group | editing = True, isNew = False }

                        else
                            { group | editing = False, isNew = False }
                    )
                |> (\groups ->
                        { model | groups = groups, newGroupLabel = Just label }
                   )
                |> Return.singleton
                |> Return.command (Ports.focusOnTextInput ())

        FinishedEditingGroup { applyNewLabel, index } ->
            let
                newLabel group =
                    case Maybe.map String.trim model.newGroupLabel of
                        Just "" ->
                            group.label

                        Nothing ->
                            group.label

                        Just l ->
                            l
            in
            model.groups
                |> List.indexedMap
                    (\groupIdx group ->
                        if groupIdx == index then
                            { group | editing = False, isNew = False, label = newLabel group }

                        else
                            group
                    )
                |> List.filter (.isNew >> (==) False)
                |> List.filter (.label >> String.isEmpty >> not)
                |> (\groups -> { model | groups = groups, newGroupLabel = Nothing })
                |> Return.singleton

        HoldOnToNewGroupLabel newLabel ->
            Return.singleton { model | newGroupLabel = Just newLabel }

        UrlChanged url ->
            -- TODO
            ( model
            , Cmd.none
            )

        UrlRequested urlRequest ->
            -- TODO
            ( model
            , Cmd.none
            )



-- 📰


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- 🌄


view : Model -> Browser.Document Msg
view model =
    { title = "Herknen"
    , body =
        [ Html.div
            [ C.flex
            , C.flex_col
            , C.items_center
            , C.justify_center
            , C.w_full
            ]
            [ groupView model.newGroupLabel model.groups

            --
            , Html.div
                [ A.title "Create a new list"
                , E.onClick CreateGroup

                --
                , C.cursor_pointer
                , C.flex
                , C.items_center
                , C.p_4
                ]
                [ Html.span
                    [ C.text_gray_400 ]
                    [ Icons.add 22 Inherit ]
                ]
            ]
        ]
    }


groupView : Maybe String -> List Group -> Html Msg
groupView newGroupLabel groups =
    groups
        |> List.indexedMap
            (\idx group ->
                let
                    editMsg =
                        EditGroup { index = idx, label = group.label }

                    finishedEditingMsg bool =
                        FinishedEditingGroup { applyNewLabel = bool, index = idx }
                in
                Html.li
                    [ idx
                        |> Theme.itemForIndex Theme.default
                        |> Theme.mergeClasses
                        |> A.class

                    --
                    , C.border_b
                    , C.border_opacity_5
                    , C.border_black
                    , C.overflow_hidden

                    --
                    , if group.editing then
                        C.shadow_inner

                      else
                        C.shadow_none

                    --
                    , C.last__border_0

                    -- Responsive
                    -------------
                    , C.sm__first__rounded_t
                    , C.sm__last__rounded_b
                    ]
                    [ if group.editing then
                        Html.input
                            [ A.value (Maybe.withDefault group.label newGroupLabel)
                            , A.autocomplete False
                            , A.autofocus True
                            , A.spellcheck False
                            , A.type_ "text"
                            , E.onBlur (finishedEditingMsg True)
                            , E.onInput HoldOnToNewGroupLabel
                            , Keyboard.on Keyboard.Keypress [ ( Enter, finishedEditingMsg False ) ]

                            --
                            , C.bg_transparent
                            , C.font_body
                            , C.mt_px
                            , C.px_4
                            , C.py_3
                            , C.tracking_wide
                            , C.w_full

                            --
                            , C.focus__outline_none
                            ]
                            []

                      else
                        Html.div
                            [ C.mt_px
                            , C.px_4
                            , C.py_3
                            , C.tracking_wide
                            ]
                            [ Html.span
                                [ E.onClick editMsg ]
                                [ Html.text group.label ]
                            ]
                    ]
            )
        |> Html.ol
            [ Theme.default.container
                |> Theme.mergeClasses
                |> A.class

            --
            , C.max_w_xs
            , C.rounded
            , C.shadow_md
            , C.w_full
            ]


unitView : Unit -> Html Msg
unitView unit =
    Html.div
        []
        [ Html.text unit.text
        ]
