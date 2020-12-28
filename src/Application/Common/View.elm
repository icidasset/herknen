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


index : List (Html msg) -> Html msg
index =
    Html.div
        [ C.flex
        , C.flex_col
        , C.min_h_screen
        , C.items_center
        , C.w_full

        -- Responsive
        -------------
        , C.sm__min_h_0
        , C.sm__justify_center
        ]


create : { withBorder : Bool } -> List (Html.Attribute msg) -> Html msg
create { withBorder } attributes =
    Html.button
        ([ C.appearance_none
         , C.cursor_pointer
         , C.flex
         , C.items_center
         , C.p_5
         , C.rounded_full
         ]
            |> (if withBorder then
                    List.append
                        [ C.border_2
                        , C.border_dashed
                        , C.border_gray_300

                        -- Dark mode
                        ------------
                        , C.border_gray_600
                        ]

                else
                    identity
               )
            |> List.append attributes
        )
        [ Html.button
            [ C.text_gray_400 ]
            [ Icons.add 22 Inherit ]
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
            [ "bg-gray-200", "dark:bg-gray-800" ]

           else
            Theme.itemForIndex Theme.default idx
          )
            |> Theme.mergeClasses
            |> A.class

        --
        , C.border_b
        , C.border_opacity_5
        , C.border_black
        , C.group
        , C.pt_px
        , C.relative
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
            tag
                ([ C.block
                 , C.px_4
                 , C.py_3
                 , C.tracking_wide
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


action : List (Html.Attribute msg) -> List (Html msg) -> Html msg
action attributes =
    [ C.absolute
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
    , C.transition_opacity

    --
    , C.group_hover__opacity_100
    , C.group_hover__pointer_events_auto
    ]
        |> List.append attributes
        |> Html.button
