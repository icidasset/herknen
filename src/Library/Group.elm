module Group exposing (Group, Icon, default, iconFromString, icons, materialIcon, new)

import Dict exposing (Dict)
import Material.Icons.Round as Icons
import Material.Icons.Types as Material
import Unit exposing (Unit)



-- 🌳


type alias Group =
    { icon : Icon
    , label : String
    , units : List Unit

    -----------------------------------------
    -- Internal
    -----------------------------------------
    , editing : Bool
    , isNew : Bool
    }


type Icon
    = Icon String


new : Group
new =
    { icon = default.icon
    , label = ""
    , units = []

    --
    , editing = True
    , isNew = True
    }


icons : Dict String ( Icon, Material.Icon msg )
icons =
    [ ( "assignments", Icons.assignment_turned_in )
    ]
        |> List.map (\( key, material ) -> ( key, ( Icon key, material ) ))
        |> Dict.fromList


default : { icon : Icon, material : Material.Icon msg }
default =
    { icon = Icon "default"
    , material = Icons.check_box_outline_blank
    }



-- 🛠


iconFromString : String -> Icon
iconFromString key =
    icons
        |> Dict.get key
        |> Maybe.map Tuple.first
        |> Maybe.withDefault default.icon


materialIcon : Icon -> Material.Icon msg
materialIcon (Icon key) =
    icons
        |> Dict.get key
        |> Maybe.map Tuple.second
        |> Maybe.withDefault default.material
