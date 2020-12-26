module Radix exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Group exposing (Group)
import Route exposing (Route)
import Url exposing (Url)
import Wnfs



-- ⛩


type alias Flags =
    {}



-- 🌳


type alias Model =
    { authenticated : Bool
    , groups : List Group
    , navKey : Nav.Key
    , route : Route
    , url : Url

    -- TODO: Replace groups with RemoteData type and remove this
    , isLoading : Bool
    }


appPermissions : Wnfs.AppPermissions
appPermissions =
    { creator = "icidasset"
    , name = "Herknen"
    }



-- 📣


type Msg
    = Bypass
      -----------------------------------------
      -- Group
      -----------------------------------------
    | CreateGroup
    | EditGroup { index : Int }
    | FinishedEditingGroup { index : Int, save : Bool }
    | RemoveGroup { index : Int }
    | UpdateGroupLabel { index : Int } String
      -----------------------------------------
      -- Unit
      -----------------------------------------
    | CreateUnit
    | EditUnit { index : Int }
    | FinishedEditingUnit { index : Int, save : Bool }
    | RemoveUnit { index : Int }
    | UpdateUnitLabel { index : Int } String
      -----------------------------------------
      -- 🦉
      -----------------------------------------
    | GotWnfsResponse Wnfs.Response
    | Initialise { authenticated : Bool }
    | UrlChanged Url
    | UrlRequested UrlRequest


type alias Manager =
    Model -> ( Model, Cmd Msg )
