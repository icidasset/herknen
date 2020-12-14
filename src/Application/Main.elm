module Main exposing (main)

import Browser
import Browser.Navigation
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
import Return exposing (return)
import Theme
import Unit exposing (Unit)
import Url exposing (Url)



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
              , editing = True
              }
            , { icon = Group.iconFromString "assignments"
              , label = "To do"
              , units =
                    []

              --
              , editing = False
              }
            ]
        , newGroupLabel = Nothing
        }
        Cmd.none



-- 📣


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EditGroup { label } ->
            model.groups
                |> List.map
                    (\group ->
                        if group.label == label then
                            { group | editing = True }

                        else
                            { group | editing = False }
                    )
                |> (\groups -> { model | groups = groups, newGroupLabel = Just label })
                |> Return.singleton

        FinishedEditingGroup { applyNewLabel, label } ->
            let
                newLabel =
                    case Maybe.map String.trim model.newGroupLabel of
                        Just "" ->
                            label

                        Nothing ->
                            label

                        Just l ->
                            l
            in
            model.groups
                |> List.map
                    (\group ->
                        if group.label == label then
                            { group | editing = False, label = newLabel }

                        else
                            group
                    )
                |> (\groups -> { model | groups = groups, newGroupLabel = Nothing })
                |> Return.singleton

        HoldOnToNewGroupLabel newLabel ->
            Return.singleton { model | newGroupLabel = Just newLabel }

        UrlChanged url ->
            -- TODO
            ( model
            , Cmd.none
            )

        UrlRequested urlRequest ->
            -- TODO
            ( model
            , Cmd.none
            )



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
            [ groupView model.newGroupLabel model.groups

            --
            , Html.div
                [ C.cursor_pointer
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


groupView : Maybe String -> List Group -> Html Msg
groupView newGroupLabel groups =
    groups
        |> List.indexedMap
            (\idx group ->
                let
                    editMsg =
                        EditGroup { label = group.label }

                    finishedEditingMsg bool =
                        FinishedEditingGroup { applyNewLabel = bool, label = group.label }
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
                    , C.overflow_hidden

                    --
                    , C.last__border_0

                    -- Responsive
                    -------------
                    , C.sm__first__rounded_t
                    , C.sm__last__rounded_b
                    ]
                    [ if group.editing then
                        Html.input
                            [ A.value (Maybe.withDefault group.label newGroupLabel)
                            , E.onBlur (finishedEditingMsg True)
                            , E.onInput HoldOnToNewGroupLabel
                            , Keyboard.on Keyboard.Keypress [ ( Enter, finishedEditingMsg False ) ]

                            --
                            , C.bg_transparent
                            , C.font_body
                            , C.mt_px
                            , C.px_4
                            , C.py_3
                            , C.tracking_wide

                            --
                            , C.focus__outline_none
                            , C.focus__shadow_inner
                            ]
                            []

                      else
                        Html.div
                            [ E.onClick editMsg
                            , C.mt_px
                            , C.px_4
                            , C.py_3
                            , C.tracking_wide
                            ]
                            [ Html.text group.label ]
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
