module Route exposing (..)

import Group exposing (Group)
import Url exposing (Url)
import Url.Parser exposing (..)



-- 🌳


type Route
    = Index
    | Group { label : String } (Maybe Group)
    | NotFound



-- 🛠


fromUrl : Url -> Route
fromUrl url =
    -- Hash-based routing
    { url | path = Maybe.withDefault "" url.fragment }
        |> parse route
        |> Maybe.withDefault NotFound



-- ㊙️


route : Parser (Route -> a) a
route =
    oneOf
        [ map Index top
        , map
            (\label ->
                Group
                    { label = Maybe.withDefault label (Url.percentDecode label) }
                    Nothing
            )
            (s "group" </> string)
        ]
