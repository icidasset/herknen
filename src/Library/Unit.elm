module Unit exposing (..)

import Json.Decode
import Json.Encode as Json
import Time



-- 🌳


type alias Unit =
    -- createdAt : Time.Posix
    -- modifiedAt : Time.Posix
    -- notifyAt : Time.Posix
    { text : String
    }



-- 🛠


decoder : Json.Decode.Decoder Unit
decoder =
    Json.Decode.map
        (\text ->
            { text = text }
        )
        (Json.Decode.field "text" Json.Decode.string)


encode : Unit -> Json.Value
encode unit =
    Json.object
        [ ( "text", Json.string unit.text ) ]
