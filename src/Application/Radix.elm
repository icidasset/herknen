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
    }



-- 📣


type Msg
    = CreateGroup
    | EditGroup { index : Int }
    | FinishedEditingGroup { index : Int, save : Bool }
    | UpdateGroupLabel { index : Int } String
      -----------------------------------------
      -- URL
      -----------------------------------------
    | UrlChanged Url
    | UrlRequested UrlRequest


type alias Manager =
    Model -> ( Model, Cmd Msg )
