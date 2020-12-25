module Common.Item exposing (..)

-- 🌳


type alias Item item =
    { item
        | editing : Bool
        , isNew : Bool
        , label : String
        , oldLabel : String
    }
