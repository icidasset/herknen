module Radix exposing (..)

import Bounce exposing (Bounce)
import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Group exposing (Group)
import Html.Events.Extra.Pointer as Pointer
import RemoteData exposing (RemoteData)
import Route exposing (Route)
import Url exposing (Url)
import Webnative



-- ⛩


type alias Flags =
    {}



-- 🌳


type alias Model =
    { groups : RemoteData String (List Group)
    , groupsBounce : Bounce
    , navKey : Nav.Key
    , pointerStartCoordinates : Maybe { x : Float, y : Float }
    , route : Route
    , url : Url
    }


appPermissions : Webnative.AppPermissions
appPermissions =
    { creator = "icidasset"
    , name = "Herknen"
    }


permissions : Webnative.Permissions
permissions =
    { app = Just appPermissions
    , fs = Nothing
    }



-- 📣


type Msg
    = Bypass
      -----------------------------------------
      -- Group
      -----------------------------------------
    | CompleteGroup { index : Int }
    | CreateExampleGroup
    | CreateGroup
    | EditGroup { index : Int }
    | FinishedEditingGroup { index : Int }
    | PersistGroupsIfSteady
    | RemoveGroup { index : Int }
    | StartGroupGesture { index : Int } Pointer.Event
    | UpdateGroupLabel { index : Int } String
      -----------------------------------------
      -- Unit
      -----------------------------------------
    | CompleteUnit { index : Int }
    | CreateUnit
    | EditUnit { index : Int }
    | FinishedEditingUnit { index : Int }
    | RemoveUnit { index : Int }
    | StartUnitGesture { index : Int } Pointer.Event
    | UpdateUnitLabel { index : Int } String
      -----------------------------------------
      -- 🦉
      -----------------------------------------
    | Authenticate
    | GotWebnativeResponse Webnative.Response
    | PointerDown Pointer.Event
    | PointerUp Pointer.Event
    | UrlChanged Url
    | UrlRequested UrlRequest


type alias Manager =
    Model -> ( Model, Cmd Msg )
