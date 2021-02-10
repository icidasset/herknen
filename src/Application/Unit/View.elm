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
        [ Common.title
            { href = "#/"
            , title = group.label
            , tooltip = "Select another list"
            }

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
