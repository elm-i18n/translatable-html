module Translation exposing (Html, Translatable, text, translate)

import Translatable.Html


type alias Html msg =
    Translatable.Html.Html Translatable msg


{-| An example translatable type that doesn't actually do anything.
-}
type Translatable
    = Translatable String


text : String -> Translatable
text =
    Translatable


translate : Translatable -> String
translate (Translatable userText) =
    userText
