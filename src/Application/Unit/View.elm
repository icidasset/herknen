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
            ]
            [ Html.h1
                [ C.antialiased
                , C.font_display
                , C.italic
                , C.mb_6
                , C.mt_8
                , C.text_gray_400
                , C.text_lg

                -- Responsive
                -------------
                , C.sm__mt_0
                ]
                [ Html.text group.label ]
            ]

        --
        , listView group.units

        --
        , Common.create
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
