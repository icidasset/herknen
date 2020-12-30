module Theme exposing (Theme, completedItemForIndex, default, itemForIndex, mergeClasses)

import List.Extra as List



-- 🌳


type alias Theme =
    { container : List String
    , completedItems : List (List String)
    , items : List (List String)
    }



-- 🎨


default : Theme
default =
    { container =
        [ "text-opacity-90", "text-white", "dark:text-opacity-80" ]
    , completedItems =
        [ [ "bg-opacity-100", "bg-gray-300", "dark:bg-gray-800" ]
        , [ "bg-opacity-90", "bg-gray-300", "dark:bg-gray-800" ]
        , [ "bg-opacity-80", "bg-gray-300", "dark:bg-gray-800" ]
        , [ "bg-opacity-70", "bg-gray-300", "dark:bg-gray-800" ]
        , [ "bg-opacity-60", "bg-gray-300", "dark:bg-gray-800" ]
        ]
    , items =
        [ [ "bg-opacity-80", "bg-emerald-400" ]
        , [ "bg-opacity-80", "bg-emerald-500" ]
        , [ "bg-opacity-80", "bg-emerald-600" ]
        , [ "bg-opacity-80", "bg-emerald-700" ]
        , [ "bg-opacity-80", "bg-emerald-800" ]
        ]
    }



-- 🛠


completedItemForIndex : Theme -> Int -> List String
completedItemForIndex =
    forIndex .completedItems


itemForIndex : Theme -> Int -> List String
itemForIndex =
    forIndex .items


mergeClasses : List String -> String
mergeClasses =
    String.join " "



-- ㊙️


forIndex : (Theme -> List (List a)) -> Theme -> Int -> List a
forIndex fn theme index =
    let
        l =
            List.length (fn theme)
    in
    index
        |> modBy (l * 2 - 2)
        |> (\i ->
                if i >= l then
                    l * 2 - 2 - i

                else
                    i
           )
        |> (\itemIdx -> List.getAt itemIdx <| fn theme)
        |> Maybe.withDefault []
