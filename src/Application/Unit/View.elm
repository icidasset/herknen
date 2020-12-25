module Unit.View exposing (..)

import Common.View as Common
import Css.Classes as C
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Material.Icons.Round as Icons
import Material.Icons.Types exposing (Coloring(..))
import Radix exposing (..)
import Unit exposing (Unit)



-- 🌄


index : List Unit -> Html Msg
index units =
    Common.index
        [ listView units

        --
        , Common.create
            [ A.title "Add something to the list"

            -- , E.onClick CreateGroup
            ]
        ]



-- GROUP


listView : List Unit -> Html Msg
listView units =
    units
        |> List.indexedMap
            (Common.item
                { edit = \_ -> Bypass
                , finishedEditing = \_ -> Bypass
                , input = \_ _ -> Bypass
                , remove = \_ -> Bypass
                }
                []
            )
        |> Common.list
