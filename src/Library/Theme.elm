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
        [ [ "bg-opacity-80", "bg-indigo-400" ]
        , [ "bg-opacity-80", "bg-violet-400" ]
        , [ "bg-opacity-80", "bg-purple-400" ]
        , [ "bg-opacity-80", "bg-fuchsia-400" ]
        , [ "bg-opacity-80", "bg-pink-400" ]
        , [ "bg-opacity-80", "bg-rose-400" ]
        ]
    }



-- 🛠


itemForIndex : Theme -> Int -> List String
itemForIndex theme index =
    index
        |> modBy (List.length theme.items)
        |> (\itemIdx -> List.getAt itemIdx theme.items)
        |> Maybe.withDefault []


mergeClasses : List String -> String
mergeClasses =
    String.join " "
