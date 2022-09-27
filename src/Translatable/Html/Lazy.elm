module Translatable.Html.Lazy exposing (lazy, lazy2, lazy3, lazy4, lazy5, lazy6)

{-| Since all Elm functions are pure we have a guarantee that the same input
will always result in the same output. This module gives us tools to be lazy
about building `Html` that utilize this fact.

Rather than immediately applying functions to their arguments, the `lazy`
functions just bundle the function and arguments up for later. When diffing
the old and new virtual DOM, it checks to see if all the arguments are equal
by reference. If so, it skips calling the function!

This is a really cheap test and often makes things a lot faster, but definitely
benchmark to be sure!

@docs lazy, lazy2, lazy3, lazy4, lazy5, lazy6

-}

import Html
import Html.Lazy
import Translatable.Html
import Translatable.Html.Internal exposing (Html(..))


{-| A performance optimization that delays the building of virtual DOM nodes.

Calling `(view model)` will definitely build some virtual DOM, perhaps a lot of
it. Calling `(lazy view model)` delays the call until later. During diffing, we
can check to see if `model` is referentially equal to the previous value used,
and if so, we just stop. No need to build up the tree structure and diff it,
we know if the input to `view` is the same, the output must be the same!

-}
lazy : (a -> Html userText msg) -> a -> Html userText msg
lazy fn a =
    Html.Lazy.lazy3 lazyHelp fn a
        |> LazyNode


lazyHelp : (a -> Html userText msg) -> a -> (userText -> String) -> Html.Html msg
lazyHelp fn a toString =
    fn a
        |> Translatable.Html.toHtml toString


{-| Same as `lazy` but checks on two arguments.
-}
lazy2 : (a -> b -> Html userText msg) -> a -> b -> Html userText msg
lazy2 fn a b =
    Html.Lazy.lazy4 lazy2Help fn a b
        |> LazyNode


lazy2Help : (a -> b -> Html userText msg) -> a -> b -> (userText -> String) -> Html.Html msg
lazy2Help fn a b toString =
    fn a b
        |> Translatable.Html.toHtml toString


{-| Same as `lazy` but checks on three arguments.
-}
lazy3 : (a -> b -> c -> Html userText msg) -> a -> b -> c -> Html userText msg
lazy3 fn a b c =
    Html.Lazy.lazy5 lazy3Help fn a b c
        |> LazyNode


lazy3Help : (a -> b -> c -> Html userText msg) -> a -> b -> c -> (userText -> String) -> Html.Html msg
lazy3Help fn a b c toString =
    fn a b c
        |> Translatable.Html.toHtml toString


{-| Same as `lazy` but checks on four arguments.
-}
lazy4 : (a -> b -> c -> d -> Html userText msg) -> a -> b -> c -> d -> Html userText msg
lazy4 fn a b c d =
    Html.Lazy.lazy6 lazy4Help fn a b c d
        |> LazyNode


lazy4Help : (a -> b -> c -> d -> Html userText msg) -> a -> b -> c -> d -> (userText -> String) -> Html.Html msg
lazy4Help fn a b c d toString =
    fn a b c d
        |> Translatable.Html.toHtml toString


{-| Same as `lazy` but checks on five arguments.
-}
lazy5 : (a -> b -> c -> d -> e -> Html userText msg) -> a -> b -> c -> d -> e -> Html userText msg
lazy5 fn a b c d e =
    Html.Lazy.lazy7 lazy5Help fn a b c d e
        |> LazyNode


lazy5Help : (a -> b -> c -> d -> e -> Html userText msg) -> a -> b -> c -> d -> e -> (userText -> String) -> Html.Html msg
lazy5Help fn a b c d e toString =
    fn a b c d e
        |> Translatable.Html.toHtml toString


{-| Same as `lazy` but checks on six arguments.
-}
lazy6 : (a -> b -> c -> d -> e -> f -> Html userText msg) -> a -> b -> c -> d -> e -> f -> Html userText msg
lazy6 fn a b c d e f =
    Html.Lazy.lazy8 lazy6Help fn a b c d e f
        |> LazyNode


lazy6Help : (a -> b -> c -> d -> e -> f -> Html userText msg) -> a -> b -> c -> d -> e -> f -> (userText -> String) -> Html.Html msg
lazy6Help fn a b c d e f toString =
    fn a b c d e f
        |> Translatable.Html.toHtml toString
