module Group.View exposing (..)

import Common.View as Common
import Css.Classes as C
import Group exposing (Group)
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Radix exposing (..)
import Unit exposing (Unit)
import Url



-- 🌄


index : List Group -> Html Msg
index groups =
    Common.index
        [ listView groups

        --
        , Common.create
            [ A.title "Create a new list"
            , E.onClick CreateGroup
            ]
        ]



-- GROUP


listView : List Group -> Html Msg
listView groups =
    groups
        |> List.indexedMap
            (\idx group ->
                Common.item
                    { edit = EditGroup
                    , finishedEditing = FinishedEditingGroup
                    , input = UpdateGroupLabel
                    , remove = RemoveGroup
                    }
                    Html.a
                    [ A.href ("#/group/" ++ Url.percentEncode group.label) ]
                    idx
                    group
            )
        |> Common.list
