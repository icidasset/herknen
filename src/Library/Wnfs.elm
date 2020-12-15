port module Wnfs exposing (..)

import Json.Decode as Json



-- 📣


port wnfsRequest : { method : String, arguments : List Json.Value } -> Cmd msg



-- 📰


port wnfsResponse : (Json.Value -> msg) -> Sub msg
