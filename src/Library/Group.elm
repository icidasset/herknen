module Group exposing (Group, Icon, decoder, default, encode, example, findGroupAndIndexByLabel, iconFromString, icons, markAllAsDone, materialIcon, new, temporary)

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
    , gestureTarget : Maybe { x : Float, y : Float }
    , isDone : Bool
    , isEditing : Bool
    , isLoading : Bool
    , isNew : Bool
    , oldLabel : String
    , persisted : Bool
    }


type Icon
    = Icon String


example : Group
example =
    let
        newUnit =
            Unit.new

        unit =
            { newUnit | isEditing = False, isNew = False }
    in
    { new
        | label = "Shopping List"
        , units =
            [ { unit | label = "Bread" }
            , { unit | label = "Butter" }
            ]

        --
        , isEditing = False
        , isNew = False
    }


new : Group
new =
    { icon = default.icon
    , label = ""
    , units = []

    --
    , gestureTarget = Nothing
    , isDone = False
    , isEditing = True
    , isLoading = False
    , isNew = True
    , oldLabel = ""
    , persisted = True
    }


temporary : String -> Group
temporary label =
    { icon = default.icon
    , label = label
    , units = []

    --
    , gestureTarget = Nothing
    , isDone = False
    , isEditing = False
    , isLoading = True
    , isNew = False
    , oldLabel = label
    , persisted = True
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
            , gestureTarget = Nothing
            , isDone = False
            , isEditing = False
            , isLoading = False
            , isNew = False
            , oldLabel = label
            , persisted = True
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


markAllAsDone : Group -> Group
markAllAsDone group =
    { group | units = List.map (\u -> { u | isDone = True }) group.units }


materialIcon : Icon -> Material.Icon msg
materialIcon (Icon key) =
    icons
        |> Dict.get key
        |> Maybe.map Tuple.second
        |> Maybe.withDefault default.material



-- 🔬


findGroupAndIndexByLabel : String -> List Group -> Maybe { index : Int, group : Group }
findGroupAndIndexByLabel label groups =
    findGroupAndIndexByLabel_ label -1 groups


findGroupAndIndexByLabel_ : String -> Int -> List Group -> Maybe { index : Int, group : Group }
findGroupAndIndexByLabel_ label counter groups =
    case groups of
        [] ->
            Nothing

        group :: rest ->
            if group.label == label then
                Just { index = counter + 1, group = group }

            else
                findGroupAndIndexByLabel_ label (counter + 1) rest
