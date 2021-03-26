module Route exposing (Route(..), fromUrl, group, units)

import Group exposing (Group)
import Unit exposing (Unit)
import Url exposing (Url)
import Url.Parser exposing (..)



-- 🌳


type Route
    = Index
    | Group { label : String } (Maybe { index : Int, group : Group })
      --
    | Error String
    | NotFound



-- 🛠


fromUrl : Url -> Route
fromUrl url =
    -- Hash-based routing
    { url | path = Maybe.withDefault "" url.fragment }
        |> parse route
        |> Maybe.withDefault NotFound



-- 🏗


group : Route -> Maybe Group
group r =
    case r of
        Group _ (Just a) ->
            Just a.group

        _ ->
            Nothing


units : Route -> List Unit
units r =
    case r of
        Group _ (Just a) ->
            a.group.units

        _ ->
            []



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
