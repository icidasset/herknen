module Radix exposing (..)

import Browser exposing (UrlRequest)
import Group exposing (Group)
import Url exposing (Url)



-- ⛩


type alias Flags =
    {}



-- 🌳


type alias Model =
    { groups : List Group
    , newGroupLabel : Maybe String
    }



-- 📣


type Msg
    = CreateGroup
    | EditGroup { index : Int, label : String }
    | FinishedEditingGroup { applyNewLabel : Bool, index : Int }
    | HoldOnToNewGroupLabel String
      -----------------------------------------
      -- URL
      -----------------------------------------
    | UrlChanged Url
    | UrlRequested UrlRequest
