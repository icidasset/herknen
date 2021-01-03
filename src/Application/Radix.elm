module Radix exposing (..)

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
    | FinishedEditingGroup { index : Int, save : Bool }
    | RemoveGroup { index : Int }
    | StartGroupGesture { index : Int } Pointer.Event
    | UpdateGroupLabel { index : Int } String
      -----------------------------------------
      -- Unit
      -----------------------------------------
    | CompleteUnit { index : Int }
    | CreateUnit
    | EditUnit { index : Int }
    | FinishedEditingUnit { index : Int, save : Bool }
    | RemoveUnit { index : Int }
    | StartUnitGesture { index : Int } Pointer.Event
    | UpdateUnitLabel { index : Int } String
      -----------------------------------------
      -- 🦉
      -----------------------------------------
    | Authenticate
    | GotWnfsResponse Webnative.Response
    | Initialise { authenticated : Bool }
    | PointerDown Pointer.Event
    | PointerUp Pointer.Event
    | UrlChanged Url
    | UrlRequested UrlRequest


type alias Manager =
    Model -> ( Model, Cmd Msg )
