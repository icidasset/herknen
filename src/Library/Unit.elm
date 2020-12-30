module Unit exposing (Unit, decoder, encode, findGestureTargetWithIndex, new)

import Json.Decode
import Json.Encode as Json
import Time



-- 🌳


type alias Unit =
    { isDone : Bool
    , label : String
    , notifyAt : Maybe Time.Posix

    -----------------------------------------
    -- Internal
    -----------------------------------------
    , gestureTarget : Maybe { x : Float, y : Float }
    , isEditing : Bool
    , isLoading : Bool
    , isNew : Bool
    , oldLabel : String
    }


new : Unit
new =
    { isDone = False
    , label = ""
    , notifyAt = Nothing

    -----------------------------------------
    -- Internal
    -----------------------------------------
    , gestureTarget = Nothing
    , isEditing = True
    , isLoading = False
    , isNew = True
    , oldLabel = ""
    }



-- 🛠


decoder : Json.Decode.Decoder Unit
decoder =
    Json.Decode.map2
        (\isDone label ->
            { isDone = isDone
            , label = label
            , notifyAt = Nothing

            -----------------------------------------
            -- Internal
            -----------------------------------------
            , gestureTarget = Nothing
            , isEditing = False
            , isLoading = False
            , isNew = False
            , oldLabel = label
            }
        )
        (Json.Decode.field "isDone" Json.Decode.bool)
        (Json.Decode.field "label" Json.Decode.string)


encode : Unit -> Json.Value
encode unit =
    Json.object
        [ ( "isDone", Json.bool unit.isDone )
        , ( "label", Json.string unit.label )
        ]



-- 🔬


findGestureTargetWithIndex :
    List Unit
    ->
        Maybe
            { index : Int
            , coordinates : { x : Float, y : Float }
            }
findGestureTargetWithIndex =
    findGestureTargetWithIndex_ -1


findGestureTargetWithIndex_ :
    Int
    -> List Unit
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
