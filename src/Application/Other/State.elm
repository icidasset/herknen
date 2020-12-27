module Other.State exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Group.Wnfs
import List.Extra as List
import Radix exposing (..)
import RemoteData
import Return exposing (return)
import Route
import Tag
import Url exposing (Url)
import Wnfs



-- 📣


gotWnfsResponse : Wnfs.Response -> Manager
gotWnfsResponse response =
    case Wnfs.decodeResponse Tag.parse response of
        Ok ( Tag.Group tag, artifact ) ->
            Group.Wnfs.manage tag artifact

        _ ->
            -- TODO: Error handling
            Return.singleton


urlChanged : Url -> Manager
urlChanged url model =
    case Route.fromUrl url of
        Route.Group { label } Nothing ->
            let
                maybeGroup =
                    List.find
                        (.label >> (==) label)
                        (RemoteData.withDefault [] model.groups)

                route =
                    Route.Group
                        { index = Nothing
                        , label = label
                        }
                        maybeGroup
            in
            Return.singleton { model | route = route }

        route ->
            Return.singleton { model | route = route }


urlRequested : UrlRequest -> Manager
urlRequested urlRequest model =
    case urlRequest of
        Internal url ->
            ( model
            , Nav.pushUrl model.navKey (Url.toString url)
            )

        External url ->
            ( model
            , Nav.load url
            )
