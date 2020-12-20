port module Ports exposing (..)

import Wnfs



-- 📣


port focusOnTextInput : () -> Cmd msg


port wnfsRequest : Wnfs.Request -> Cmd msg



-- 📰


port initialise : ({ authenticated : Bool } -> msg) -> Sub msg


port wnfsResponse : (Wnfs.Response -> msg) -> Sub msg
