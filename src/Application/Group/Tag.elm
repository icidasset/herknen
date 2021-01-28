module Group.Tag exposing (..)

import Enum exposing (Enum)



-- 🌳


type Tag
    = CreateIndex
    | EnsureIndex
    | Fetch
    | Index
    | Mutation
    | Published


enum : Enum Tag
enum =
    Enum.create
        [ ( "CreateIndex", CreateIndex )
        , ( "EnsureIndex", EnsureIndex )
        , ( "Fetch", Fetch )
        , ( "Index", Index )
        , ( "Mutation", Mutation )
        , ( "Published", Published )
        ]
