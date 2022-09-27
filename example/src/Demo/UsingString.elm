module Demo.UsingString exposing (Model, Msg, init, view)

import Translatable.Html as Html
import Translatable.Html.Attributes as Attributes
import Translatable.Html.Events as Events
import Translatable.Html.Keyed as Keyed
import Translatable.Html.Lazy as Lazy


type alias Html msg =
    Html.Html String msg


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
            |> Attributes.title
        , Events.onClick Msg
        ]
        [ "UsingString"
            |> Html.text
            |> List.singleton
            |> Html.h1 []
        , Keyed.ul []
            [ ( "001"
              , "Item #1"
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
            Debug.log "Render UsingString.lazyView" ()
    in
    "Lazy"
        |> Html.text
