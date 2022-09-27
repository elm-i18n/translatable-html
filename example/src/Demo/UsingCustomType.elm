module Demo.UsingCustomType exposing (Model, Msg, init, view)

import Translatable.Html as Html
import Translatable.Html.Attributes as Attributes
import Translatable.Html.Events as Events
import Translatable.Html.Keyed as Keyed
import Translatable.Html.Lazy as Lazy
import Translation exposing (Html)


type alias Model =
    ()


init : Model
init =
    ()


type Msg
    = Msg


view : Model -> Html Msg
view model =
    Html.div
        [ "Some title"
            |> Translation.text
            |> Attributes.title
        , Events.onClick Msg
        ]
        [ "UsingCustomType"
            |> Translation.text
            |> Html.text
            |> List.singleton
            |> Html.h1 []
        , Keyed.ul []
            [ ( "001"
              , "Item #1"
                    |> Translation.text
                    |> Html.text
                    |> List.singleton
                    |> Html.li []
              )
            ]
        , Lazy.lazy lazyView model
        ]


lazyView : Model -> Html Msg
lazyView _ =
    let
        -- When you click the parent view, this log should **not** be shown if lazy is working correctly.
        _ =
            Debug.log "Render UsingCustomType.lazyView" ()
    in
    "Lazy"
        |> Translation.text
        |> Html.text
