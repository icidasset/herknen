module Unit exposing (..)

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
    , isEditing : Bool
    , isGestureTarget : Bool
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
    , isEditing = True
    , isGestureTarget = False
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
            , isEditing = False
            , isGestureTarget = False
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
