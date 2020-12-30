port module Ports exposing (..)

import Webnative
import Wnfs



-- 📣


port focusOnTextInput : () -> Cmd msg


port webnativeRequest : Webnative.Request -> Cmd msg


port wnfsRequest : Webnative.Request -> Cmd msg



-- 📰


port initialise : ({ authenticated : Bool } -> msg) -> Sub msg


port wnfsResponse : (Webnative.Response -> msg) -> Sub msg
