module Common.Item exposing (..)

-- 🌳


type alias Item item =
    { item
        | gestureTarget : Maybe { x : Float, y : Float }
        , isDone : Bool
        , isEditing : Bool
        , isLoading : Bool
        , isNew : Bool
        , label : String
        , oldLabel : String
    }
