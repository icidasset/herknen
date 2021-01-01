module Unit.View exposing (..)

import Common.View as Common
import Css.Classes as C
import Group exposing (Group)
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Material.Icons.Round as Icons
import Material.Icons.Types exposing (Coloring(..))
import Radix exposing (..)
import Unit exposing (Unit)



-- 🌄


index : Group -> Html Msg
index group =
    Common.index
        [ Html.a
            [ A.href "#/"
            , A.title "Select another list"

            --
            , C.text_gray_400
            , C.transition_colors

            --
            , C.focus__outline_none
            , C.focus__text_black
            , C.focus__underline
            , C.dark__focus__text_white
            ]
            [ Html.h1
                [ C.antialiased
                , C.font_bold
                , C.font_display
                , C.pb_6
                , C.pt_8
                , C.px_5
                , C.text_xl
                , C.tracking_tighter

                -- Responsive
                -------------
                , C.sm__mt_0
                , C.sm__text_base
                ]
                [ Html.text group.label ]
            ]

        --
        , listView group.units

        --
        , if List.isEmpty group.units then
            Common.emptyState
                [ E.onClick CreateUnit
                , C.cursor_pointer
                ]
                [ Html.p
                    []
                    [ Html.text "All done, "
                    , Html.span [ C.sm__hidden ] [ Html.text "tap the screen" ]
                    , Html.span [ C.hidden, C.sm__inline ] [ Html.text "click here" ]
                    , Html.text " to add"
                    , Html.br [] []
                    , Html.text "something to the list."
                    ]
                ]

          else
            Common.create
                { withBorder = List.isEmpty group.units }
                [ A.title "Add something to the list"
                , E.onClick CreateUnit
                ]
        ]



-- GROUP


listView : List Unit -> Html Msg
listView units =
    units
        |> List.indexedMap
            (Common.item
                { complete = CompleteUnit
                , edit = EditUnit
                , finishedEditing = FinishedEditingUnit
                , gestureTarget = StartUnitGesture
                , input = UpdateUnitLabel
                , remove = RemoveUnit
                }
                Html.span
                []
            )
        |> Common.list
