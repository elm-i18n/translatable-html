module Translatable.Html.Attributes exposing
    ( toAttribute
    , style, property, attribute, map
    , class, classList, id, title, hidden
    , type_, value, checked, placeholder, selected
    , accept, acceptCharset, action, autocomplete, autofocus
    , disabled, enctype, list, maxlength, minlength, method, multiple
    , name, novalidate, pattern, readonly, required, size, for, form
    , max, min, step
    , cols, rows, wrap
    , href, target, download, hreflang, media, ping, rel
    , ismap, usemap, shape, coords
    , src, height, width, alt
    , autoplay, controls, loop, preload, poster, default, kind, srclang
    , sandbox, srcdoc
    , reversed, start
    , align, colspan, rowspan, headers, scope
    , accesskey, contenteditable, contextmenu, dir, draggable, dropzone
    , itemprop, lang, spellcheck, tabindex
    , cite, datetime, pubdate, manifest
    )

{-| Helper functions for HTML attributes. They are organized roughly by
category. Each attribute is labeled with the HTML tags it can be used with, so
just search the page for `video` if you want video stuff.


# Conversion

@docs toAttribute


# Primitives

@docs style, property, attribute, map


# Super Common Attributes

@docs class, classList, id, title, hidden


# Inputs

@docs type_, value, checked, placeholder, selected


## Input Helpers

@docs accept, acceptCharset, action, autocomplete, autofocus
@docs disabled, enctype, list, maxlength, minlength, method, multiple
@docs name, novalidate, pattern, readonly, required, size, for, form


## Input Ranges

@docs max, min, step


## Input Text Areas

@docs cols, rows, wrap


# Links and Areas

@docs href, target, download, hreflang, media, ping, rel


## Maps

@docs ismap, usemap, shape, coords


# Embedded Content

@docs src, height, width, alt


## Audio and Video

@docs autoplay, controls, loop, preload, poster, default, kind, srclang


## iframes

@docs sandbox, srcdoc


# Ordered Lists

@docs reversed, start


# Tables

@docs align, colspan, rowspan, headers, scope


# Less Common Global Attributes

Attributes that can be attached to any HTML tag but are less commonly used.

@docs accesskey, contenteditable, contextmenu, dir, draggable, dropzone
@docs itemprop, lang, spellcheck, tabindex


# Miscellaneous

@docs cite, datetime, pubdate, manifest

-}

import Html
import Html.Attributes
import Html.Events
import Json.Decode as Decode
import Json.Encode as Json
import Translatable.Html.Internal exposing (Attribute(..))



-- CONVERSION


{-| Convert `Translatable.Html.Attributes.Attribute` back into core `Html.Attributes.Attribute`.
`Translatable.Html.toHtml` will do this for you so you shouldn't need to use it.

    import Html.Attributes
    import Translatable.Html.Attributes

    attrs : List (Html.Attributes.Attribute msg)
    attrs =
        List.map (Translatable.Html.Attributes.toAttribute translate) typedAttrs

    typedAttrs : List (Translatable.Html.Attributes.Attribute Translatable msg)
    typedAttrs =
        [ "Some title"
            |> text
            |> Translatable.Html.Attributes.title
        ]

    type Translatable
        = Translatable String

    text : String -> Translatable
    text =
        Translatable

    translate : Translatable -> String
    translate (Translatable userText) =
        userText

-}
toAttribute : (userText -> String) -> Attribute userText msg -> Html.Attribute msg
toAttribute f attribute_ =
    case attribute_ of
        Attribute key value_ ->
            Html.Attributes.attribute key value_

        Property key value_ ->
            Html.Attributes.property key (value_ f)

        Event event decoder ->
            Html.Events.custom event decoder



-- This library does not include low, high, or optimum because the idea of a
-- `meter` is just too crazy.
-- PRIMITIVES


{-| Specify a style.

    greeting : Node msg
    greeting =
        div
            [ style "background-color" "red"
            , style "height" "90px"
            , style "width" "100%"
            ]
            [ text "Hello!"
            ]

There is no `Html.Styles` module because best practices for working with HTML
suggest that this should primarily be specified in CSS files. So the general
recommendation is to use this function lightly.

-}
style : String -> String -> Attribute userText msg
style =
    Attribute


{-| This function makes it easier to build a space-separated class attribute.
Each class can easily be added and removed depending on the boolean value it
is paired with. For example, maybe we want a way to view notices:

    viewNotice : Notice -> Html msg
    viewNotice notice =
        div
            [ classList
                [ ( "notice", True )
                , ( "notice-important", notice.isImportant )
                , ( "notice-seen", notice.isSeen )
                ]
            ]
            [ text notice.content ]

**Note:** You can have as many `class` and `classList` attributes as you want.
They all get applied, so if you say `[ class "notice", class "notice-seen" ]`
you will get both classes!

-}
classList : List ( String, Bool ) -> Attribute userText msg
classList classes =
    class <|
        String.join " " <|
            List.map Tuple.first <|
                List.filter Tuple.second classes



-- CUSTOM ATTRIBUTES


{-| Create _properties_, like saying `domNode.className = 'greeting'` in
JavaScript.

    import Json.Encode as Encode

    class : String -> Attribute userText msg
    class name =
        property "className" (Encode.string name)

Read more about the difference between properties and attributes [here].

[here]: https://github.com/elm/html/blob/master/properties-vs-attributes.md

-}
property : String -> Json.Value -> Attribute userText msg
property key =
    Property key << always


stringProperty : String -> String -> Attribute userText msg
stringProperty key =
    property key << Json.string


boolProperty : String -> Bool -> Attribute userText msg
boolProperty key =
    property key << Json.bool


userTextProperty : String -> userText -> Attribute userText msg
userTextProperty key userText =
    Property key ((|>) userText >> Json.string)


{-| Create _attributes_, like saying `domNode.setAttribute('class', 'greeting')`
in JavaScript.

    class : String -> Attribute userText msg
    class name =
        attribute "class" name

Read more about the difference between properties and attributes [here].

[here]: https://github.com/elm/html/blob/master/properties-vs-attributes.md

-}
attribute : String -> String -> Attribute userText msg
attribute =
    Attribute


{-| Transform the messages produced by an `Attribute`.
-}
map : (a -> msg) -> Attribute userText a -> Attribute userText msg
map f attribute_ =
    case attribute_ of
        Attribute key value_ ->
            Attribute key value_

        Property key value_ ->
            Property key value_

        Event event decoder ->
            Event event
                (decoder
                    |> Decode.map
                        (\{ message, stopPropagation, preventDefault } ->
                            { message = f message
                            , stopPropagation = stopPropagation
                            , preventDefault = preventDefault
                            }
                        )
                )



-- GLOBAL ATTRIBUTES


{-| Often used with CSS to style elements with common properties.

**Note:** You can have as many `class` and `classList` attributes as you want.
They all get applied, so if you say `[ class "notice", class "notice-seen" ]`
you will get both classes!

-}
class : String -> Attribute userText msg
class =
    stringProperty "className"


{-| Indicates the relevance of an element.
-}
hidden : Bool -> Attribute userText msg
hidden =
    boolProperty "hidden"


{-| Often used with CSS to style a specific element. The value of this
attribute must be unique.
-}
id : String -> Attribute userText msg
id =
    stringProperty "id"


{-| Text to be displayed in a tooltip when hovering over the element.
-}
title : userText -> Attribute userText msg
title =
    userTextProperty "title"



-- LESS COMMON GLOBAL ATTRIBUTES


{-| Defines a keyboard shortcut to activate or add focus to the element.
-}
accesskey : Char -> Attribute userText msg
accesskey char =
    stringProperty "accessKey" (String.fromChar char)


{-| Indicates whether the element's content is editable.
-}
contenteditable : Bool -> Attribute userText msg
contenteditable =
    boolProperty "contentEditable"


{-| Defines the ID of a `menu` element which will serve as the element's
context menu.
-}
contextmenu : String -> Attribute userText msg
contextmenu =
    attribute "contextmenu"


{-| Defines the text direction. Allowed values are ltr (Left-To-Right) or rtl
(Right-To-Left).
-}
dir : String -> Attribute userText msg
dir =
    stringProperty "dir"


{-| Defines whether the element can be dragged.
-}
draggable : String -> Attribute userText msg
draggable =
    attribute "draggable"


{-| Indicates that the element accept the dropping of content on it.
-}
dropzone : String -> Attribute userText msg
dropzone =
    stringProperty "dropzone"


{-| -}
itemprop : String -> Attribute userText msg
itemprop =
    attribute "itemprop"


{-| Defines the language used in the element.
-}
lang : String -> Attribute userText msg
lang =
    stringProperty "lang"


{-| Indicates whether spell checking is allowed for the element.
-}
spellcheck : Bool -> Attribute userText msg
spellcheck =
    boolProperty "spellcheck"


{-| Overrides the browser's default tab order and follows the one specified
instead.
-}
tabindex : Int -> Attribute userText msg
tabindex n =
    attribute "tabIndex" (String.fromInt n)



-- EMBEDDED CONTENT


{-| The URL of the embeddable content. For `audio`, `embed`, `iframe`, `img`,
`input`, `script`, `source`, `track`, and `video`.
-}
src : String -> Attribute userText msg
src =
    stringProperty "src"


{-| Declare the height of a `canvas`, `embed`, `iframe`, `img`, `input`,
`object`, or `video`.
-}
height : Int -> Attribute userText msg
height n =
    attribute "height" (String.fromInt n)


{-| Declare the width of a `canvas`, `embed`, `iframe`, `img`, `input`,
`object`, or `video`.
-}
width : Int -> Attribute userText msg
width n =
    attribute "width" (String.fromInt n)


{-| Alternative text in case an image can't be displayed. Works with `img`,
`area`, and `input`.
-}
alt : String -> Attribute userText msg
alt =
    stringProperty "alt"



-- AUDIO and VIDEO


{-| The `audio` or `video` should play as soon as possible.
-}
autoplay : Bool -> Attribute userText msg
autoplay =
    boolProperty "autoplay"


{-| Indicates whether the browser should show playback controls for the `audio`
or `video`.
-}
controls : Bool -> Attribute userText msg
controls =
    boolProperty "controls"


{-| Indicates whether the `audio` or `video` should start playing from the
start when it's finished.
-}
loop : Bool -> Attribute userText msg
loop =
    boolProperty "loop"


{-| Control how much of an `audio` or `video` resource should be preloaded.
-}
preload : String -> Attribute userText msg
preload =
    stringProperty "preload"


{-| A URL indicating a poster frame to show until the user plays or seeks the
`video`.
-}
poster : String -> Attribute userText msg
poster =
    stringProperty "poster"


{-| Indicates that the `track` should be enabled unless the user's preferences
indicate something different.
-}
default : Bool -> Attribute userText msg
default =
    boolProperty "default"


{-| Specifies the kind of text `track`.
-}
kind : String -> Attribute userText msg
kind =
    stringProperty "kind"



{--TODO: maybe reintroduce once there's a better way to disambiguate imports
{-| Specifies a user-readable title of the text `track`. -}
label : String -> Attribute userText msg
label =
  stringProperty "label"
--}


{-| A two letter language code indicating the language of the `track` text data.
-}
srclang : String -> Attribute userText msg
srclang =
    stringProperty "srclang"



-- IFRAMES


{-| A space separated list of security restrictions you'd like to lift for an
`iframe`.
-}
sandbox : String -> Attribute userText msg
sandbox =
    stringProperty "sandbox"


{-| An HTML document that will be displayed as the body of an `iframe`. It will
override the content of the `src` attribute if it has been specified.
-}
srcdoc : String -> Attribute userText msg
srcdoc =
    stringProperty "srcdoc"



-- INPUT


{-| Defines the type of a `button`, `input`, `embed`, `object`, `script`,
`source`, `style`, or `menu`.
-}
type_ : String -> Attribute userText msg
type_ =
    stringProperty "type"


{-| Defines a default value which will be displayed in a `button`, `option`,
`input`, `li`, `meter`, `progress`, or `param`.
-}
value : String -> Attribute userText msg
value =
    stringProperty "value"


{-| Indicates whether an `input` of type checkbox is checked.
-}
checked : Bool -> Attribute userText msg
checked =
    boolProperty "checked"


{-| Provides a hint to the user of what can be entered into an `input` or
`textarea`.
-}
placeholder : String -> Attribute userText msg
placeholder =
    stringProperty "placeholder"


{-| Defines which `option` will be selected on page load.
-}
selected : Bool -> Attribute userText msg
selected =
    boolProperty "selected"



-- INPUT HELPERS


{-| List of types the server accepts, typically a file type.
For `form` and `input`.
-}
accept : String -> Attribute userText msg
accept =
    stringProperty "accept"


{-| List of supported charsets in a `form`.
-}
acceptCharset : String -> Attribute userText msg
acceptCharset =
    stringProperty "acceptCharset"


{-| The URI of a program that processes the information submitted via a `form`.
-}
action : String -> Attribute userText msg
action =
    stringProperty "action"


{-| Indicates whether a `form` or an `input` can have their values automatically
completed by the browser.
-}
autocomplete : Bool -> Attribute userText msg
autocomplete bool =
    stringProperty "autocomplete"
        (if bool then
            "on"

         else
            "off"
        )


{-| The element should be automatically focused after the page loaded.
For `button`, `input`, `select`, and `textarea`.
-}
autofocus : Bool -> Attribute userText msg
autofocus =
    boolProperty "autofocus"


{-| Indicates whether the user can interact with a `button`, `fieldset`,
`input`, `optgroup`, `option`, `select` or `textarea`.
-}
disabled : Bool -> Attribute userText msg
disabled =
    boolProperty "disabled"


{-| How `form` data should be encoded when submitted with the POST method.
Options include: application/x-www-form-urlencoded, multipart/form-data, and
text/plain.
-}
enctype : String -> Attribute userText msg
enctype =
    stringProperty "enctype"


{-| Associates an `input` with a `datalist` tag. The datalist gives some
pre-defined options to suggest to the user as they interact with an input.
The value of the list attribute must match the id of a `datalist` node.
For `input`.
-}
list : String -> Attribute userText msg
list =
    attribute "list"


{-| Defines the minimum number of characters allowed in an `input` or
`textarea`.
-}
minlength : Int -> Attribute userText msg
minlength n =
    attribute "minLength" (String.fromInt n)


{-| Defines the maximum number of characters allowed in an `input` or
`textarea`.
-}
maxlength : Int -> Attribute userText msg
maxlength n =
    attribute "maxlength" (String.fromInt n)


{-| Defines which HTTP method to use when submitting a `form`. Can be GET
(default) or POST.
-}
method : String -> Attribute userText msg
method =
    stringProperty "method"


{-| Indicates whether multiple values can be entered in an `input` of type
email or file. Can also indicate that you can `select` many options.
-}
multiple : Bool -> Attribute userText msg
multiple =
    boolProperty "multiple"


{-| Name of the element. For example used by the server to identify the fields
in form submits. For `button`, `form`, `fieldset`, `iframe`, `input`,
`object`, `output`, `select`, `textarea`, `map`, `meta`, and `param`.
-}
name : String -> Attribute userText msg
name =
    stringProperty "name"


{-| This attribute indicates that a `form` shouldn't be validated when
submitted.
-}
novalidate : Bool -> Attribute userText msg
novalidate =
    boolProperty "noValidate"


{-| Defines a regular expression which an `input`'s value will be validated
against.
-}
pattern : String -> Attribute userText msg
pattern =
    stringProperty "pattern"


{-| Indicates whether an `input` or `textarea` can be edited.
-}
readonly : Bool -> Attribute userText msg
readonly =
    boolProperty "readOnly"


{-| Indicates whether this element is required to fill out or not.
For `input`, `select`, and `textarea`.
-}
required : Bool -> Attribute userText msg
required =
    boolProperty "required"


{-| For `input` specifies the width of an input in characters.

For `select` specifies the number of visible options in a drop-down list.

-}
size : Int -> Attribute userText msg
size n =
    attribute "size" (String.fromInt n)


{-| The element ID described by this `label` or the element IDs that are used
for an `output`.
-}
for : String -> Attribute userText msg
for =
    stringProperty "htmlFor"


{-| Indicates the element ID of the `form` that owns this particular `button`,
`fieldset`, `input`, `label`, `meter`, `object`, `output`, `progress`,
`select`, or `textarea`.
-}
form : String -> Attribute userText msg
form =
    attribute "form"



-- RANGES


{-| Indicates the maximum value allowed. When using an input of type number or
date, the max value must be a number or date. For `input`, `meter`, and `progress`.
-}
max : String -> Attribute userText msg
max =
    stringProperty "max"


{-| Indicates the minimum value allowed. When using an input of type number or
date, the min value must be a number or date. For `input` and `meter`.
-}
min : String -> Attribute userText msg
min =
    stringProperty "min"


{-| Add a step size to an `input`. Use `step "any"` to allow any floating-point
number to be used in the input.
-}
step : String -> Attribute userText msg
step n =
    stringProperty "step" n



--------------------------


{-| Defines the number of columns in a `textarea`.
-}
cols : Int -> Attribute userText msg
cols n =
    attribute "cols" (String.fromInt n)


{-| Defines the number of rows in a `textarea`.
-}
rows : Int -> Attribute userText msg
rows n =
    attribute "rows" (String.fromInt n)


{-| Indicates whether the text should be wrapped in a `textarea`. Possible
values are "hard" and "soft".
-}
wrap : String -> Attribute userText msg
wrap =
    stringProperty "wrap"



-- MAPS


{-| When an `img` is a descendant of an `a` tag, the `ismap` attribute
indicates that the click location should be added to the parent `a`'s href as
a query string.
-}
ismap : Bool -> Attribute userText msg
ismap =
    boolProperty "isMap"


{-| Specify the hash name reference of a `map` that should be used for an `img`
or `object`. A hash name reference is a hash symbol followed by the element's name or id.
E.g. `"#planet-map"`.
-}
usemap : String -> Attribute userText msg
usemap =
    stringProperty "useMap"


{-| Declare the shape of the clickable area in an `a` or `area`. Valid values
include: default, rect, circle, poly. This attribute can be paired with
`coords` to create more particular shapes.
-}
shape : String -> Attribute userText msg
shape =
    stringProperty "shape"


{-| A set of values specifying the coordinates of the hot-spot region in an
`area`. Needs to be paired with a `shape` attribute to be meaningful.
-}
coords : String -> Attribute userText msg
coords =
    stringProperty "coords"



-- REAL STUFF


{-| Specifies the horizontal alignment of a `caption`, `col`, `colgroup`,
`hr`, `iframe`, `img`, `table`, `tbody`, `td`, `tfoot`, `th`, `thead`, or
`tr`.
-}
align : String -> Attribute userText msg
align =
    stringProperty "align"


{-| Contains a URI which points to the source of the quote or change in a
`blockquote`, `del`, `ins`, or `q`.
-}
cite : String -> Attribute userText msg
cite =
    stringProperty "cite"



-- LINKS AND AREAS


{-| The URL of a linked resource, such as `a`, `area`, `base`, or `link`.
-}
href : String -> Attribute userText msg
href =
    stringProperty "href"


{-| Specify where the results of clicking an `a`, `area`, `base`, or `form`
should appear. Possible special values include:

  - \_blank &mdash; a new window or tab
  - \_self &mdash; the same frame (this is default)
  - \_parent &mdash; the parent frame
  - \_top &mdash; the full body of the window

You can also give the name of any `frame` you have created.

-}
target : String -> Attribute userText msg
target =
    stringProperty "target"


{-| Indicates that clicking an `a` and `area` will download the resource
directly. The `String` argument determins the name of the downloaded file.
Say the file you are serving is named `hats.json`.

    download "" -- hats.json

    download "my-hats.json" -- my-hats.json

    download "snakes.json" -- snakes.json

The empty `String` says to just name it whatever it was called on the server.

-}
download : String -> Attribute userText msg
download fileName =
    stringProperty "download" fileName


{-| Indicates that clicking an `a` and `area` will download the resource
directly, and that the downloaded resource with have the given filename.
So `downloadAs "hats.json"` means the person gets a file named `hats.json`.
-}
downloadAs : String -> Attribute userText msg
downloadAs =
    stringProperty "download"


{-| Two-letter language code of the linked resource of an `a`, `area`, or `link`.
-}
hreflang : String -> Attribute userText msg
hreflang =
    stringProperty "hreflang"


{-| Specifies a hint of the target media of a `a`, `area`, `link`, `source`,
or `style`.
-}
media : String -> Attribute userText msg
media =
    attribute "media"


{-| Specify a URL to send a short POST request to when the user clicks on an
`a` or `area`. Useful for monitoring and tracking.
-}
ping : String -> Attribute userText msg
ping =
    stringProperty "ping"


{-| Specifies the relationship of the target object to the link object.
For `a`, `area`, `link`.
-}
rel : String -> Attribute userText msg
rel =
    attribute "rel"



-- CRAZY STUFF


{-| Indicates the date and time associated with the element.
For `del`, `ins`, `time`.
-}
datetime : String -> Attribute userText msg
datetime =
    attribute "datetime"


{-| Indicates whether this date and time is the date of the nearest `article`
ancestor element. For `time`.
-}
pubdate : String -> Attribute userText msg
pubdate =
    attribute "pubdate"



-- ORDERED LISTS


{-| Indicates whether an ordered list `ol` should be displayed in a descending
order instead of a ascending.
-}
reversed : Bool -> Attribute userText msg
reversed =
    boolProperty "reversed"


{-| Defines the first number of an ordered list if you want it to be something
besides 1.
-}
start : Int -> Attribute userText msg
start n =
    stringProperty "start" (String.fromInt n)



-- TABLES


{-| The colspan attribute defines the number of columns a cell should span.
For `td` and `th`.
-}
colspan : Int -> Attribute userText msg
colspan n =
    attribute "colspan" (String.fromInt n)


{-| A space separated list of element IDs indicating which `th` elements are
headers for this cell. For `td` and `th`.
-}
headers : String -> Attribute userText msg
headers =
    stringProperty "headers"


{-| Defines the number of rows a table cell should span over.
For `td` and `th`.
-}
rowspan : Int -> Attribute userText msg
rowspan n =
    attribute "rowspan" (String.fromInt n)


{-| Specifies the scope of a header cell `th`. Possible values are: col, row,
colgroup, rowgroup.
-}
scope : String -> Attribute userText msg
scope =
    stringProperty "scope"


{-| Specifies the URL of the cache manifest for an `html` tag.
-}
manifest : String -> Attribute userText msg
manifest =
    attribute "manifest"



{--TODO: maybe reintroduce once there's a better way to disambiguate imports
{-| The number of columns a `col` or `colgroup` should span. -}
span : Int -> Attribute userText msg
span n =
    stringProperty "span" (String.fromInt n)
--}
