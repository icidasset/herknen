module Radix exposing (..)

import Browser exposing (UrlRequest)
import Group exposing (Group)
import Url exposing (Url)
import Wnfs



-- ⛩


type alias Flags =
    {}



-- 🌳


type alias Model =
    { authenticated : Bool

    -- TODO: Replace groups with RemoteData type and remove this
    , isLoading : Bool
    , groups : List Group
    }


appPermissions : Wnfs.AppPermissions
appPermissions =
    { creator = "icidasset"
    , name = "Herknen"
    }



-- 📣


type
    Msg
    -----------------------------------------
    -- Group
    -----------------------------------------
    = CreateGroup
    | EditGroup { index : Int }
    | FinishedEditingGroup { index : Int, save : Bool }
    | RemoveGroup { index : Int }
    | UpdateGroupLabel { index : Int } String
      -----------------------------------------
      -- 🦉
      -----------------------------------------
    | GotWnfsResponse Wnfs.Response
    | Initialise { authenticated : Bool }
    | UrlChanged Url
    | UrlRequested UrlRequest


type alias Manager =
    Model -> ( Model, Cmd Msg )
