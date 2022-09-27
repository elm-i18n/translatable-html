module Main exposing (main)

import Browser
import Demo.UsingCoreHtml
import Demo.UsingCustomType
import Demo.UsingString
import Html
import Translatable.Html
import Translation


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { usingCustomType : Demo.UsingCustomType.Model
    , usingString : Demo.UsingString.Model
    , usingCoreHtml : Demo.UsingCoreHtml.Model
    }


init : Model
init =
    { usingCustomType = Demo.UsingCustomType.init
    , usingString = Demo.UsingString.init
    , usingCoreHtml = Demo.UsingCoreHtml.init
    }


type Msg
    = UsingCustomTypeMsg Demo.UsingCustomType.Msg
    | UsingStringMsg Demo.UsingString.Msg
    | UsingCoreHtmlMsg Demo.UsingCoreHtml.Msg


update : Msg -> Model -> Model
update _ model =
    model


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Demo.UsingCustomType.view model.usingCustomType
            |> Translatable.Html.map UsingCustomTypeMsg
            |> Translatable.Html.toHtml Translation.translate
        , Demo.UsingString.view model.usingString
            |> Translatable.Html.map UsingStringMsg
            |> Translatable.Html.toHtml identity
        , Demo.UsingCoreHtml.view model.usingCoreHtml
            |> Html.map UsingCoreHtmlMsg
        ]
