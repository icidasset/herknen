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
                [ C.font_display
                , C.italic
                , C.mb_6
                , C.opacity_50
                , C.text_xl
                ]
                [ Html.text group.label ]
            ]

        --
        , listView group.units

        --
        , if List.isEmpty group.units then
            Html.div
                [ C.border_2
                , C.border_dashed
                , C.border_gray_300
                , C.rounded_full
                ]
                [ Common.create
                    [ A.title "Add something to the list"
                    , E.onClick CreateUnit
                    ]
                ]

          else
            Common.create
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
                { edit = EditUnit
                , finishedEditing = FinishedEditingUnit
                , input = UpdateUnitLabel
                , remove = RemoveUnit
                }
                Html.span
                []
            )
        |> Common.list
