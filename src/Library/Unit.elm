module Unit exposing (..)

import Json.Decode
import Json.Encode as Json
import Time



-- 🌳


type alias Unit =
    { label : String
    , notifyAt : Maybe Time.Posix

    -----------------------------------------
    -- Internal
    -----------------------------------------
    , editing : Bool
    , isLoading : Bool
    , isNew : Bool
    , oldLabel : String
    }


new : Unit
new =
    { label = ""
    , notifyAt = Nothing

    -----------------------------------------
    -- Internal
    -----------------------------------------
    , editing = True
    , isLoading = False
    , isNew = True
    , oldLabel = ""
    }



-- 🛠


decoder : Json.Decode.Decoder Unit
decoder =
    Json.Decode.map
        (\label ->
            { label = label
            , notifyAt = Nothing

            -----------------------------------------
            -- Internal
            -----------------------------------------
            , editing = False
            , isLoading = False
            , isNew = False
            , oldLabel = label
            }
        )
        (Json.Decode.field "label" Json.Decode.string)


encode : Unit -> Json.Value
encode unit =
    Json.object
        [ ( "label", Json.string unit.label ) ]
