module Main exposing (main)

import Browser
import Browser.Navigation
import Css.Classes as C
import Group exposing (Group)
import Html exposing (Html)
import Html.Attributes as A
import Material.Icons.Round as Icons
import Material.Icons.Types exposing (Coloring(..))
import Radix exposing (..)
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
              }
            , { icon = Group.iconFromString "assignments"
              , label = "To do"
              , units =
                    []
              }
            ]
        }
        Cmd.none



-- 📣


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
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
            [ groupView model.groups

            --
            , Html.div
                [ C.flex
                , C.items_center
                , C.p_4
                ]
                [ Html.span
                    [ C.mr_2 ]
                    [ Icons.add 16 Inherit ]
                , Html.text "Create list"
                ]
            ]
        ]
    }


groupView : List Group -> Html Msg
groupView groups =
    groups
        |> List.indexedMap
            (\idx group ->
                Html.li
                    [ idx
                        |> Theme.itemForIndex Theme.default
                        |> Theme.mergeClasses
                        |> A.class

                    --
                    , C.border_b
                    , C.border_opacity_5
                    , C.border_black
                    , C.px_4
                    , C.py_3
                    , C.tracking_wide

                    --
                    , C.last__border_0

                    -- Responsive
                    -------------
                    , C.sm__first__rounded_t
                    , C.sm__last__rounded_b
                    ]
                    [ Html.div
                        [ C.pt_px ]
                        [ Html.text group.label ]
                    ]
            )
        |> Html.ol
            [ Theme.default.container
                |> Theme.mergeClasses
                |> A.class

            --
            , C.max_w_xs
            , C.w_full
            ]


unitView : Unit -> Html Msg
unitView unit =
    Html.div
        []
        [ Html.text unit.text
        ]
