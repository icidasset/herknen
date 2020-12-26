module Common.Item exposing (..)

-- 🌳


type alias Item item =
    { item
        | editing : Bool
        , isLoading : Bool
        , isNew : Bool
        , label : String
        , oldLabel : String
    }
