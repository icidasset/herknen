module Group exposing (Group, Icon, decoder, default, encode, iconFromString, icons, materialIcon, new, temporary)

import Dict exposing (Dict)
import Json.Decode
import Json.Encode as Json
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
    , isLoading : Bool
    , isNew : Bool
    , oldLabel : String
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
    , isLoading = False
    , isNew = True
    , oldLabel = ""
    }


temporary : String -> Group
temporary label =
    { icon = default.icon
    , label = label
    , units = []

    --
    , editing = False
    , isLoading = True
    , isNew = False
    , oldLabel = label
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


decoder : Json.Decode.Decoder Group
decoder =
    Json.Decode.map3
        (\icon label units ->
            { icon = iconFromString icon
            , label = label
            , units = units

            --
            , editing = False
            , isLoading = False
            , isNew = False
            , oldLabel = label
            }
        )
        (Json.Decode.field "icon" Json.Decode.string)
        (Json.Decode.field "label" Json.Decode.string)
        (Json.Decode.field "units" <| Json.Decode.list Unit.decoder)


encode : Group -> Json.Value
encode group =
    Json.object
        [ ( "icon", Json.string <| iconToString group.icon )
        , ( "label", Json.string group.label )
        , ( "units", Json.list Unit.encode group.units )
        ]


iconFromString : String -> Icon
iconFromString key =
    icons
        |> Dict.get key
        |> Maybe.map Tuple.first
        |> Maybe.withDefault default.icon


iconToString : Icon -> String
iconToString (Icon key) =
    key


materialIcon : Icon -> Material.Icon msg
materialIcon (Icon key) =
    icons
        |> Dict.get key
        |> Maybe.map Tuple.second
        |> Maybe.withDefault default.material
