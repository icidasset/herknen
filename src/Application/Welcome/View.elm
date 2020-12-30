module Welcome.View exposing (..)

import Css.Classes as C
import Html exposing (Html)
import Html.Events as E
import Radix exposing (..)
import Svg exposing (Svg, svg)
import Svg.Attributes exposing (..)



-- 🌄


view : Html Msg
view =
    Html.div
        [ C.flex
        , C.flex_col
        , C.items_center
        , C.justify_center
        ]
        [ Html.div
            [ C.font_bold
            , C.font_display
            , C.italic
            ]
            [ Html.h1
                [ C.text_6xl
                ]
                [ Html.text "Herknen" ]

            -- , Html.p
            --     [ C.mt_2
            --     , C.opacity_50
            --     , C.text_sm
            --     ]
            --     [ Html.text "To listen attentively; give heed." ]
            ]

        --
        , Html.p
            [ C.mt_10
            , C.opacity_70
            ]
            [ Html.text "A minimalist todo-list app, inspired by "
            , Html.a [] [ Html.text "Clear" ]
            , Html.text "."
            ]

        --
        , Html.button
            [ E.onClick Authenticate

            --
            , C.appearance_none
            , C.bg_opacity_100
            , C.bg_emerald_500
            , C.font_medium
            , C.inline_flex
            , C.items_center
            , C.mt_10
            , C.px_5
            , C.py_3
            , C.rounded_full
            , C.text_sm
            , C.text_white
            ]
            [ Html.span
                [ C.h_4
                , C.inline_block
                , C.mr_2
                , C.opacity_60
                , C.w_4
                ]
                [ svg
                    [ class "fill-current"
                    , height "100%"
                    , width "100%"
                    , viewBox "0 0 88 88"
                    ]
                    [ Svg.path
                        [ d "M44 88a44 44 0 1 1 0-88 44 44 0 0 1 0 88zm-9-29h-6c-2 0-4-2-4-4s2-4 4-4h16l5 8 2 2c2 2 4 3 7 3 5 0 9-4 9-9s-4-9-9-9H48l-2-3h13c5 0 9-4 9-9s-4-9-9-9h-6c0-2-2-3-5-3s-6 3-6 6 3 6 6 6 5-2 5-4h6c2 0 4 2 4 4s-2 4-4 4H43l-5-7-2-2c-2-3-4-4-7-4-5 0-9 4-9 9s4 9 9 9h11l2 3H29c-5 0-9 4-9 9s4 9 9 9h5a6 6 0 1 0 1-5zm20-3l-3-5h7c2 0 4 2 4 4s-2 4-4 4l-3-2-1-1zM33 34l3 4h-7c-2 0-4-2-4-4s2-4 4-4l3 2 1 2z"
                        , fillRule "nonzero"
                        ]
                        []
                    ]
                ]
            , Html.span
                [ C.inline_block, C.pt_px ]
                [ Html.text "Sign in with Fission" ]
            ]
        ]
