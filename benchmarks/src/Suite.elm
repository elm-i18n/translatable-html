module Suite exposing (suite)

import Benchmark exposing (Benchmark)
import Html
import Translatable.Html


suite : Benchmark
suite =
    Benchmark.describe "elm-translatable-html"
        [ compareWithCoreSuite
        ]


compareWithCoreSuite : Benchmark
compareWithCoreSuite =
    Benchmark.describe "elm-translatable-html vs. elm/html"
        [ compareWithCoreCustomType 1
        , compareWithCoreCustomType 100
        , compareWithCoreString 1
        , compareWithCoreString 100
        ]


compareWithCoreCustomType : Int -> Benchmark
compareWithCoreCustomType count =
    compareWithCore ("custom type: render " ++ String.fromInt count ++ " nodes")
        count
        (List.map (\_ -> "" |> Translatable |> Translatable.Html.text)
            >> Translatable.Html.div []
            >> Translatable.Html.toHtml translate
        )
        (List.map (\_ -> "" |> Translatable |> translate |> Html.text)
            >> Html.div []
        )


compareWithCoreString : Int -> Benchmark
compareWithCoreString count =
    compareWithCore ("string: render " ++ String.fromInt count ++ " nodes")
        count
        (List.map (\_ -> "" |> Translatable.Html.text)
            >> Translatable.Html.div []
            >> Translatable.Html.toHtml identity
        )
        (List.map (\_ -> "" |> Html.text)
            >> Html.div []
        )


compareWithCore : String -> Int -> (List Int -> Html.Html msg) -> (List Int -> Html.Html msg) -> Benchmark
compareWithCore name count translatable core =
    Benchmark.compare name
        "translatable"
        (\_ -> List.range 1 count |> translatable)
        "core"
        (\_ -> List.range 1 count |> core)


type Translatable
    = Translatable String


translate : Translatable -> String
translate (Translatable userText) =
    userText
