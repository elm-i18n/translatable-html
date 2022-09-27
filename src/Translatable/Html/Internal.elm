module Translatable.Html.Internal exposing (Attribute(..), Event_, Html(..))

import Html
import Json.Decode as Json


type Html userText msg
    = Node String (List (Attribute userText msg)) (List (Html userText msg))
    | KeyedNode String (List (Attribute userText msg)) (List ( String, Html userText msg ))
    | LazyNode ((userText -> String) -> Html.Html msg)
    | Text userText
    | Core (Html.Html msg)


type Attribute userText msg
    = Attribute String String
    | Property String ((userText -> String) -> Json.Value)
    | Event String (Json.Decoder (Event_ msg))


type alias Event_ msg =
    { message : msg
    , stopPropagation : Bool
    , preventDefault : Bool
    }
