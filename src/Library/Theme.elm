module Theme exposing (..)

import List.Extra as List



-- 🌳


type alias Theme =
    { container : List String
    , items : List (List String)
    }



-- 🎨


default : Theme
default =
    { container =
        [ "text-opacity-90", "text-white" ]
    , items =
        [ [ "bg-opacity-80", "bg-emerald-400" ]
        , [ "bg-opacity-80", "bg-emerald-500" ]
        , [ "bg-opacity-80", "bg-emerald-600" ]
        , [ "bg-opacity-80", "bg-emerald-700" ]
        , [ "bg-opacity-80", "bg-emerald-800" ]
        ]
    }



-- 🛠


itemForIndex : Theme -> Int -> List String
itemForIndex theme index =
    let
        l =
            List.length theme.items
    in
    index
        |> modBy (l * 2 - 2)
        |> (\i ->
                if i >= l then
                    l * 2 - 2 - i

                else
                    i
           )
        |> (\itemIdx -> List.getAt itemIdx theme.items)
        |> Maybe.withDefault []


mergeClasses : List String -> String
mergeClasses =
    String.join " "
