module Group.Tag exposing (..)

import Enum exposing (Enum)



-- 🌳


type Tag
    = Fetch
    | Index
    | Mutation


enum : Enum Tag
enum =
    Enum.create
        [ ( "Fetch", Fetch )
        , ( "Index", Index )
        , ( "Mutation", Mutation )
        ]
