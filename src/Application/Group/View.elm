module Group.View exposing (..)

import Css.Classes as C
import Group exposing (Group)
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Keyboard exposing (Key(..))
import Keyboard.Events as Keyboard
import Material.Icons.Round as Icons
import Material.Icons.Types exposing (Coloring(..))
import Radix exposing (..)
import Theme
import Unit exposing (Unit)



-- 🌄


index : Model -> Html Msg
index model =
    Html.div
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
