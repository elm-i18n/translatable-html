# translatable-html

tl;dr: A version of [`elm/html`][elm/html] geared towards translation.

- :white_check_mark: Avoid using untranslated strings in places that should be translated.
- :white_check_mark: Avoid the need to pass around a global context to every view function.
- :warning: Defering the translation step to a single place _may_ negatively affect [performance](#performance). I haven't yet tested this package in production or any performance critical rendering scenario.

---

## What

This package helps you write HTML when your application is going to be translated into multiple languages.
It does this by exposing almost exactly the same interface as [`elm/html`][elm/html] but with an additional `userText` parameter and functions to convert between the 2 packages:

```elm
-- elm/html
Html.Html msg

-- elm-i18n/translatable-html
Translatable.Html.Html userText msg
```

```elm
-- elm/html
Html.Attributes.Attribute msg

-- elm-i18n/translatable-html
Translatable.Html.Attributes.Attribute userText msg
```


## Why

The idea is that if you have a custom type for your _untranslated_ source strings (e.g. `Translatable`), this package helps you enforce that only that custom type can be used in places that should be translated (e.g. `Html.text` or `Html.Attributes.title`) and plain strings cannot be used.

As well as parameterising the `Html` and `Attribute` type, it also defers translation so it can be applied in a single step. This means that you no longer need to pass around a global context to nearly every view function that contains the configuration necessary to turn an untranslated string into a translated one (i.e. the users current language and the dictionary of translated strings).


### Before

```elm
import Html


type alias GlobalContext = 
    { translateConfig : TranslateConfig }


view : GlobalContext -> Html.Html msg
view globalContext =
    Html.div [] 
        [ view1 globalContext
        , view2 globalContext
        , view3 globalContext
        ]


view1 : GlobalContext -> Html.Html msg
view1 { translateConfig } =
    "Foo"
        |> translatable
        |> translate translateConfig
        |> Html.text


view2 : GlobalContext -> Html.Html msg
view2 { translateConfig } =
    "Bar"
        |> translatable
        |> translate translateConfig
        |> Html.text


view3 : GlobalContext -> Html.Html msg
view3 { translateConfig } =
    "Baz"
        |> translatable
        |> translate translateConfig
        |> Html.text


type Translatable
    = Translatable String


translatable : String -> Translatable
translatable =
    Translatable


translate : TranslateConfig -> Translatable -> String
translate translateConfig (Translatable userText) =
    userText
```


### After

```elm
import Html
import Translatable.Html


type alias GlobalContext = 
    { translateConfig : TranslateConfig }


view : GlobalContext -> Html.Html msg
view { translateConfig } =
    Translatable.Html.toHtml (translate translateConfig) <|
        Translatable.Html.div [] 
            [ view1
            , view2
            , view3
            ]


view1 : Translatable.Html.Html Translatable msg
view1 =
    "Foo"
        |> translatable
        |> Translatable.Html.text


view2 : Translatable.Html.Html Translatable msg
view2 =
    "Bar"
        |> translatable
        |> Translatable.Html.text


view3 : Translatable.Html.Html Translatable msg
view3 =
    "Baz"
        |> translatable
        |> Translatable.Html.text


type Translatable
    = Translatable String


translatable : String -> Translatable
translatable =
    Translatable


translate : TranslateConfig -> Translatable -> String
translate translateConfig (Translatable userText) =
    userText
```

A more detailed example app showing how I recommend using this package can be found in the [`./example`](./example) directory.


## Performance

As mentioned above, using this package over [`elm/html`][elm/html] _may_ have a negative impact on performance. 
Using [`Translatable.Html.Lazy`](https://package.elm-lang.org/packages/elm-i18n/translatable-html/latest/Translatable-Html-Lazy) may be a way to mitigate the problem.

There are some benchmarks comparing this package to [`elm/html`][elm/html] in the [`./benchmarks`](./benchmarks) directory.


## Caveats

- [`elm/html`][elm/html] exposes 8 lazy functions; due to the way lazy works `translatable-html` can only expose 6 lazy functions as 2 of these parameters are used internally.


<!-- refs -->

[elm/html]: https://package.elm-lang.org/packages/elm/html/latest/
