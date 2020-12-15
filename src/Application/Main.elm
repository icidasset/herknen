module Main exposing (main)

import Browser
import Browser.Navigation
import Css.Classes as C
import Group exposing (Group)
import Group.State as Group
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Keyboard exposing (Key(..))
import Keyboard.Events as Keyboard
import Material.Icons.Round as Icons
import Material.Icons.Types exposing (Coloring(..))
import Ports
import Radix exposing (..)
import Return
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
              , oldLabel = ""
              }
            , { icon = Group.iconFromString "assignments"
              , label = "To do"
              , units =
                    []

              --
              , editing = False
              , isNew = False
              , oldLabel = ""
              }
            , { icon = Group.iconFromString "assignments"
              , label = "A"
              , units =
                    []

              --
              , editing = False
              , isNew = False
              , oldLabel = ""
              }
            , { icon = Group.iconFromString "assignments"
              , label = "B"
              , units =
                    []

              --
              , editing = False
              , isNew = False
              , oldLabel = ""
              }
            , { icon = Group.iconFromString "assignments"
              , label = "C"
              , units =
                    []

              --
              , editing = False
              , isNew = False
              , oldLabel = ""
              }
            ]
        }
        Cmd.none



-- 📣


update : Msg -> Model -> ( Model, Cmd Msg )
update msg =
    case msg of
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
        -- URL
        -----------------------------------------
        UrlChanged a ->
            -- TODO
            Return.singleton

        UrlRequested a ->
            -- TODO
            Return.singleton



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
            [ groupView model.groups

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


groupView : List Group -> Html Msg
groupView groups =
    groups
        |> List.indexedMap
            (\idx group ->
                let
                    editMsg =
                        EditGroup { index = idx }

                    finishedEditingMsg bool =
                        FinishedEditingGroup { index = idx, save = bool }
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
                    , C.group
                    , C.pt_px
                    , C.relative

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
                            [ A.value group.label
                            , A.autocomplete False
                            , A.autofocus True
                            , A.spellcheck False
                            , A.type_ "text"

                            --
                            , E.onBlur (finishedEditingMsg True)
                            , E.onInput (UpdateGroupLabel { index = idx })
                            , Keyboard.on Keyboard.Keypress [ ( Enter, finishedEditingMsg False ) ]

                            --
                            , C.bg_transparent
                            , C.font_body
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
                            [ C.px_4
                            , C.py_3
                            , C.tracking_wide
                            ]
                            [ Html.span
                                [ E.onClick editMsg ]
                                [ Html.text group.label ]
                            ]

                    --
                    , Html.div
                        [ E.onClick (RemoveGroup { index = idx })

                        --
                        , C.absolute
                        , C.cursor_pointer
                        , C.opacity_0
                        , C.neg_translate_y_1over2
                        , C.pointer_events_none
                        , C.px_4
                        , C.right_full
                        , C.text_gray_400
                        , C.top_1over2
                        , C.transform

                        --
                        , C.group_hover__opacity_100
                        , C.group_hover__pointer_events_auto
                        ]
                        [ Icons.remove 22 Inherit
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
