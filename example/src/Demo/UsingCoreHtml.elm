module Demo.UsingCoreHtml exposing (Model, Msg, init, view)

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Html.Keyed as Keyed
import Html.Lazy as Lazy


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
        [ "UsingCoreHtml"
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
            Debug.log "Render UsingCoreHtml.lazyView" ()
    in
    "Lazy"
        |> Html.text
