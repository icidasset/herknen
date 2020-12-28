module Common.Item exposing (..)

-- 🌳


type alias Item item =
    { item
        | isDone : Bool
        , isEditing : Bool
        , isGestureTarget : Bool
        , isLoading : Bool
        , isNew : Bool
        , label : String
        , oldLabel : String
    }
