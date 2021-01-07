module Common.View exposing (..)

import Common.Item exposing (Item)
import Css.Classes as C
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Html.Events.Extra.Pointer as Pointer
import Json.Decode as Decode
import Keyboard exposing (Key(..))
import Keyboard.Events as Keyboard
import Material.Icons.Round as Icons
import Material.Icons.Types exposing (Coloring(..))
import Radix exposing (..)
import Theme
import Unit exposing (Unit)



-- 🌳


type alias Messages msg =
    { complete : { index : Int } -> msg
    , edit : { index : Int } -> msg
    , finishedEditing : { index : Int, save : Bool } -> msg
    , gestureTarget : { index : Int } -> Pointer.Event -> msg
    , input : { index : Int } -> String -> msg
    , remove : { index : Int } -> msg
    }



-- 🌄


create : { withBorder : Bool } -> List (Html.Attribute msg) -> Html msg
create { withBorder } attributes =
    Html.button
        ([ C.appearance_none
         , C.bg_transparent
         , C.cursor_pointer
         , C.flex
         , C.items_center
         , C.p_5
         , C.rounded_full
         , C.shadow_none
         , C.text_gray_400
         , C.transition_colors

         --
         , C.focus__outline_none
         , C.focus__text_black
         , C.dark__focus__text_white
         ]
            |> (if withBorder then
                    List.append
                        [ C.border_2
                        , C.border_dashed
                        , C.border_gray_300

                        -- Dark mode
                        ------------
                        , C.dark__border_gray_600
                        ]

                else
                    identity
               )
            |> List.append attributes
        )
        [ Icons.add 22 Inherit
        ]


emptyState : List (Html.Attribute msg) -> List (Html msg) -> Html msg
emptyState attributes =
    [ C.flex
    , C.flex_1
    , C.font_display
    , C.italic
    , C.items_center
    , C.justify_center
    , C.opacity_50
    , C.px_8
    , C.py_5
    , C.text_center
    , C.text_lg

    -- Responsive
    -------------
    , C.sm__flex_grow_0
    ]
        |> List.append attributes
        |> Html.div


index : List (Html msg) -> Html msg
index =
    Html.div
        [ C.flex
        , C.flex_col
        , C.h_full
        , C.items_center
        , C.overflow_y_auto
        , C.w_full

        -- Responsive
        -------------
        , C.sm__min_h_0
        , C.sm__justify_center
        ]


item :
    Messages msg
    -> (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> List (Html.Attribute msg)
    -> Int
    -> Item item
    -> Html msg
item messages tag attributes idx it =
    let
        editMsg =
            messages.edit { index = idx }

        finishedEditingMsg bool =
            messages.finishedEditing { index = idx, save = bool }
    in
    Html.li
        [ (if it.isDone then
            Theme.completedItemForIndex Theme.default idx

           else
            Theme.itemForIndex Theme.default idx
          )
            |> Theme.mergeClasses
            |> A.class

        --
        , A.style "touch-action" "none"

        --
        , C.border_b
        , C.border_opacity_5
        , C.border_black
        , C.group
        , C.overflow_x_hidden
        , C.pt_px
        , C.relative
        , C.select_auto
        , C.transition_colors

        --
        , if it.isEditing then
            C.shadow_inner

          else
            C.shadow_none

        --
        , C.last__border_0

        -- Responsive
        -------------
        , C.sm__overflow_x_visible
        , C.sm__first__rounded_t
        , C.sm__last__rounded_b
        ]
        [ if it.isEditing then
            Html.input
                [ A.value it.label
                , A.autocomplete False
                , A.autofocus True
                , A.spellcheck False
                , A.type_ "text"

                --
                , E.onBlur (finishedEditingMsg True)
                , E.onInput (messages.input { index = idx })
                , Keyboard.on Keyboard.Keypress [ ( Enter, finishedEditingMsg True ) ]

                --
                , C.bg_transparent
                , C.font_body
                , C.px_4
                , C.py_4
                , C.tracking_wide
                , C.w_full

                --
                , C.focus__outline_none

                -- Responsive
                -------------
                , C.sm__py_3
                ]
                []

          else
            tag
                ([ C.block
                 , C.px_4
                 , C.py_4
                 , C.rounded
                 , C.tracking_wide

                 --
                 , C.focus__outline_none
                 , C.focus__ring_2
                 , C.focus__ring_offset_gray_900
                 , C.focus__ring_offset_4
                 , C.focus__ring_gray_400

                 -- Responsive
                 -------------
                 , C.sm__py_3
                 ]
                    |> (if it.isLoading then
                            identity

                        else
                            { index = idx }
                                |> messages.gestureTarget
                                |> Pointer.onDown
                                |> List.singleton
                                |> List.append
                       )
                    |> (if it.isDone then
                            List.append [ C.line_through ]

                        else
                            identity
                       )
                    |> List.append
                        attributes
                )
                [ Html.span
                    (if it.isLoading then
                        []

                     else
                        [ { message = editMsg
                          , stopPropagation = True
                          , preventDefault = True
                          }
                            |> Decode.succeed
                            |> E.custom "click"
                        ]
                    )
                    [ Html.text it.label ]
                ]

        -----------------------------------------
        -- Action Left
        -----------------------------------------
        , action
            [ E.onClick (messages.remove { index = idx })
            , C.right_full
            ]
            [ Icons.clear 18 Inherit ]

        -----------------------------------------
        -- Action Right
        -----------------------------------------
        , action
            [ E.onClick (messages.complete { index = idx })
            , C.left_full
            ]
            [ Icons.done 18 Inherit ]
        ]


list : List (Html msg) -> Html msg
list =
    Html.ol
        [ Theme.default.container
            |> Theme.mergeClasses
            |> A.class

        --
        , C.rounded
        , C.shadow_md
        , C.w_full

        -- Responsive
        -------------
        , C.sm__max_w_xs
        ]



-- ㊙️


action : List (Html.Attribute msg) -> List (Html msg) -> Html msg
action attributes =
    [ A.tabindex -1

    --
    , C.absolute
    , C.appearance_none
    , C.cursor_pointer
    , C.opacity_0
    , C.neg_translate_y_1over2
    , C.pointer_events_none
    , C.px_5
    , C.py_4
    , C.text_gray_400
    , C.top_1over2
    , C.transform
    , C.transition_all

    --
    , C.group_hover__opacity_100
    , C.group_hover__pointer_events_auto

    --
    , C.focus__outline_none
    , C.focus__text_black
    , C.dark__focus__text_white
    ]
        |> List.append attributes
        |> Html.button
