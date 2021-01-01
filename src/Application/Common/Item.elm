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



-- 🔬


findGestureTargetWithIndex :
    List (Item item)
    ->
        Maybe
            { index : Int
            , coordinates : { x : Float, y : Float }
            }
findGestureTargetWithIndex =
    findGestureTargetWithIndex_ -1


findGestureTargetWithIndex_ :
    Int
    -> List (Item item)
    ->
        Maybe
            { index : Int
            , coordinates : { x : Float, y : Float }
            }
findGestureTargetWithIndex_ counter units =
    case units of
        [] ->
            Nothing

        unit :: rest ->
            case unit.gestureTarget of
                Just coordinates ->
                    Just { index = counter + 1, coordinates = coordinates }

                Nothing ->
                    findGestureTargetWithIndex_ (counter + 1) rest
