module Translatable.Html exposing
    ( toHtml
    , Html, Attribute, text, node, map
    , h1, h2, h3, h4, h5, h6
    , div, p, hr, pre, blockquote
    , span, a, code, em, strong, i, b, u, sub, sup, br
    , ol, ul, li, dl, dt, dd
    , img, iframe, canvas, math
    , form, input, textarea, button, select, option
    , section, nav, article, aside, header, footer, address, main_
    , figure, figcaption
    , table, caption, colgroup, col, tbody, thead, tfoot, tr, td, th
    , fieldset, legend, label, datalist, optgroup, output, progress, meter
    , audio, video, source, track
    , embed, object, param
    , ins, del
    , small, cite, dfn, abbr, time, var, samp, kbd, s, q
    , mark, ruby, rt, rp, bdi, bdo, wbr
    , details, summary, menuitem, menu
    )

{-| This file is organized roughly in order of popularity. The tags which you'd
expect to use frequently will be closer to the top.


# Conversion

@docs toHtml


# Primitives

@docs Html, Attribute, text, node, map


# Tags


## Headers

@docs h1, h2, h3, h4, h5, h6


## Grouping Content

@docs div, p, hr, pre, blockquote


## Text

@docs span, a, code, em, strong, i, b, u, sub, sup, br


## Lists

@docs ol, ul, li, dl, dt, dd


## Embedded Content

@docs img, iframe, canvas, math


## Inputs

@docs form, input, textarea, button, select, option


## Sections

@docs section, nav, article, aside, header, footer, address, main_


## Figures

@docs figure, figcaption


## Tables

@docs table, caption, colgroup, col, tbody, thead, tfoot, tr, td, th


## Less Common Elements


### Less Common Inputs

@docs fieldset, legend, label, datalist, optgroup, output, progress, meter


### Audio and Video

@docs audio, video, source, track


### Embedded Objects

@docs embed, object, param


### Text Edits

@docs ins, del


### Semantic Text

@docs small, cite, dfn, abbr, time, var, samp, kbd, s, q


### Less Common Text Tags

@docs mark, ruby, rt, rp, bdi, bdo, wbr


## Interactive Elements

@docs details, summary, menuitem, menu

-}

import Html
import Html.Keyed
import Translatable.Html.Attributes
import Translatable.Html.Internal as I exposing (Html(..))



-- CONVERSION


{-| Convert `Translatable.Html.Html` back into core `Html.Html`.

    import Html
    import Translatable.Html

    view : Html.Html msg
    view =
        Translatable.Html.toHtml translate typedView

    typedView : Translatable.Html.Html Translatable msg
    typedView =
        "Hello"
            |> text
            |> Translatable.Html.text

    type Translatable
        = Translatable String

    text : String -> Translatable
    text =
        Translatable

    translate : Translatable -> String
    translate (Translatable userText) =
        userText

-}
toHtml : (userText -> String) -> Html userText msg -> Html.Html msg
toHtml f html =
    case html of
        Node name attrs children ->
            Html.node name
                (List.map (Translatable.Html.Attributes.toAttribute f) attrs)
                (List.map (toHtml f) children)

        KeyedNode name attrs children ->
            Html.Keyed.node name
                (List.map (Translatable.Html.Attributes.toAttribute f) attrs)
                (List.map (Tuple.mapSecond (toHtml f)) children)

        LazyNode node_ ->
            node_ f

        Text userText ->
            Html.text (f userText)



-- CORE TYPES


{-| The core building block used to build up HTML. Here we create an `Html`
value with no attributes and one child:

    hello : Html userText msg
    hello =
        div [] [ text "Hello!" ]

-}
type alias Html userText msg =
    I.Html userText msg


{-| Set attributes on your `Html`. Learn more in the
[`Translatable.Html.Attributes`](Translatable-Html-Attributes) module.
-}
type alias Attribute userText msg =
    I.Attribute userText msg



-- PRIMITIVES


{-| General way to create HTML nodes. It is used to define all of the helper
functions in this library.

    div : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
    div attributes children =
        node "div" attributes children

You can use this to create custom nodes if you need to create something that
is not covered by the helper functions in this library.

-}
node : String -> List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
node =
    Node


{-| Just put plain text in the DOM. It will escape the string so that it appears
exactly as you specify.

    text "Hello World!"

-}
text : userText -> Html userText msg
text =
    Text



-- NESTING VIEWS


{-| Transform the messages produced by some `Html`. In the following example,
we have `viewButton` that produces `()` messages, and we transform those values
into `Msg` values in `view`.

    type Msg
        = Left
        | Right

    view : model -> Html userText msg
    view model =
        div []
            [ map (\_ -> Left) (viewButton "Left")
            , map (\_ -> Right) (viewButton "Right")
            ]

    viewButton : String -> Html ()
    viewButton name =
        button [ onClick () ] [ text name ]

This should not come in handy too often. Definitely read [this][reuse] before
deciding if this is what you want.

[reuse]: https://guide.elm-lang.org/reuse/

-}
map : (a -> msg) -> Html userText a -> Html userText msg
map f html =
    case html of
        Node name attrs children ->
            Node name
                (List.map (Translatable.Html.Attributes.map f) attrs)
                (List.map (map f) children)

        KeyedNode name attrs children ->
            KeyedNode name
                (List.map (Translatable.Html.Attributes.map f) attrs)
                (List.map (Tuple.mapSecond (map f)) children)

        LazyNode node_ ->
            LazyNode (node_ >> Html.map f)

        Text userText ->
            Text userText



-- SECTIONS


{-| Defines a section in a document.
-}
section : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
section =
    Node "section"


{-| Defines a section that contains only navigation links.
-}
nav : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
nav =
    Node "nav"


{-| Defines self-contained content that could exist independently of the rest
of the content.
-}
article : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
article =
    Node "article"


{-| Defines some content loosely related to the page content. If it is removed,
the remaining content still makes sense.
-}
aside : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
aside =
    Node "aside"


{-| -}
h1 : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
h1 =
    Node "h1"


{-| -}
h2 : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
h2 =
    Node "h2"


{-| -}
h3 : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
h3 =
    Node "h3"


{-| -}
h4 : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
h4 =
    Node "h4"


{-| -}
h5 : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
h5 =
    Node "h5"


{-| -}
h6 : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
h6 =
    Node "h6"


{-| Defines the header of a page or section. It often contains a logo, the
title of the web site, and a navigational table of content.
-}
header : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
header =
    Node "header"


{-| Defines the footer for a page or section. It often contains a copyright
notice, some links to legal information, or addresses to give feedback.
-}
footer : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
footer =
    Node "footer"


{-| Defines a section containing contact information.
-}
address : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
address =
    Node "address"


{-| Defines the main or important content in the document. There is only one
`main` element in the document.
-}
main_ : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
main_ =
    Node "main"



-- GROUPING CONTENT


{-| Defines a portion that should be displayed as a paragraph.
-}
p : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
p =
    Node "p"


{-| Represents a thematic break between paragraphs of a section or article or
any longer content.
-}
hr : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
hr =
    Node "hr"


{-| Indicates that its content is preformatted and that this format must be
preserved.
-}
pre : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
pre =
    Node "pre"


{-| Represents a content that is quoted from another source.
-}
blockquote : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
blockquote =
    Node "blockquote"


{-| Defines an ordered list of items.
-}
ol : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
ol =
    Node "ol"


{-| Defines an unordered list of items.
-}
ul : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
ul =
    Node "ul"


{-| Defines a item of an enumeration list.
-}
li : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
li =
    Node "li"


{-| Defines a definition list, that is, a list of terms and their associated
definitions.
-}
dl : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
dl =
    Node "dl"


{-| Represents a term defined by the next `dd`.
-}
dt : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
dt =
    Node "dt"


{-| Represents the definition of the terms immediately listed before it.
-}
dd : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
dd =
    Node "dd"


{-| Represents a figure illustrated as part of the document.
-}
figure : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
figure =
    Node "figure"


{-| Represents the legend of a figure.
-}
figcaption : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
figcaption =
    Node "figcaption"


{-| Represents a generic container with no special meaning.
-}
div : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
div =
    Node "div"



-- TEXT LEVEL SEMANTIC


{-| Represents a hyperlink, linking to another resource.
-}
a : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
a =
    Node "a"


{-| Represents emphasized text, like a stress accent.
-}
em : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
em =
    Node "em"


{-| Represents especially important text.
-}
strong : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
strong =
    Node "strong"


{-| Represents a side comment, that is, text like a disclaimer or a
copyright, which is not essential to the comprehension of the document.
-}
small : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
small =
    Node "small"


{-| Represents content that is no longer accurate or relevant.
-}
s : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
s =
    Node "s"


{-| Represents the title of a work.
-}
cite : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
cite =
    Node "cite"


{-| Represents an inline quotation.
-}
q : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
q =
    Node "q"


{-| Represents a term whose definition is contained in its nearest ancestor
content.
-}
dfn : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
dfn =
    Node "dfn"


{-| Represents an abbreviation or an acronym; the expansion of the
abbreviation can be represented in the title attribute.
-}
abbr : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
abbr =
    Node "abbr"


{-| Represents a date and time value; the machine-readable equivalent can be
represented in the datetime attribute.
-}
time : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
time =
    Node "time"


{-| Represents computer code.
-}
code : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
code =
    Node "code"


{-| Represents a variable. Specific cases where it should be used include an
actual mathematical expression or programming context, an identifier
representing a constant, a symbol identifying a physical quantity, a function
parameter, or a mere placeholder in prose.
-}
var : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
var =
    Node "var"


{-| Represents the output of a program or a computer.
-}
samp : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
samp =
    Node "samp"


{-| Represents user input, often from the keyboard, but not necessarily; it
may represent other input, like transcribed voice commands.
-}
kbd : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
kbd =
    Node "kbd"


{-| Represent a subscript.
-}
sub : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
sub =
    Node "sub"


{-| Represent a superscript.
-}
sup : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
sup =
    Node "sup"


{-| Represents some text in an alternate voice or mood, or at least of
different quality, such as a taxonomic designation, a technical term, an
idiomatic phrase, a thought, or a ship name.
-}
i : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
i =
    Node "i"


{-| Represents a text which to which attention is drawn for utilitarian
purposes. It doesn't convey extra importance and doesn't imply an alternate
voice.
-}
b : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
b =
    Node "b"


{-| Represents a non-textual annotation for which the conventional
presentation is underlining, such labeling the text as being misspelt or
labeling a proper name in Chinese text.
-}
u : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
u =
    Node "u"


{-| Represents text highlighted for reference purposes, that is for its
relevance in another context.
-}
mark : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
mark =
    Node "mark"


{-| Represents content to be marked with ruby annotations, short runs of text
presented alongside the text. This is often used in conjunction with East Asian
language where the annotations act as a guide for pronunciation, like the
Japanese furigana.
-}
ruby : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
ruby =
    Node "ruby"


{-| Represents the text of a ruby annotation.
-}
rt : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
rt =
    Node "rt"


{-| Represents parenthesis around a ruby annotation, used to display the
annotation in an alternate way by browsers not supporting the standard display
for annotations.
-}
rp : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
rp =
    Node "rp"


{-| Represents text that must be isolated from its surrounding for
bidirectional text formatting. It allows embedding a span of text with a
different, or unknown, directionality.
-}
bdi : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
bdi =
    Node "bdi"


{-| Represents the directionality of its children, in order to explicitly
override the Unicode bidirectional algorithm.
-}
bdo : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
bdo =
    Node "bdo"


{-| Represents text with no specific meaning. This has to be used when no other
text-semantic element conveys an adequate meaning, which, in this case, is
often brought by global attributes like `class`, `lang`, or `dir`.
-}
span : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
span =
    Node "span"


{-| Represents a line break.
-}
br : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
br =
    Node "br"


{-| Represents a line break opportunity, that is a suggested point for
wrapping text in order to improve readability of text split on several lines.
-}
wbr : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
wbr =
    Node "wbr"



-- EDITS


{-| Defines an addition to the document.
-}
ins : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
ins =
    Node "ins"


{-| Defines a removal from the document.
-}
del : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
del =
    Node "del"



-- EMBEDDED CONTENT


{-| Represents an image.
-}
img : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
img =
    Node "img"


{-| Embedded an HTML document.
-}
iframe : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
iframe =
    Node "iframe"


{-| Represents a integration point for an external, often non-HTML,
application or interactive content.
-}
embed : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
embed =
    Node "embed"


{-| Represents an external resource, which is treated as an image, an HTML
sub-document, or an external resource to be processed by a plug-in.
-}
object : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
object =
    Node "object"


{-| Defines parameters for use by plug-ins invoked by `object` elements.
-}
param : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
param =
    Node "param"


{-| Represents a video, the associated audio and captions, and controls.
-}
video : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
video =
    Node "video"


{-| Represents a sound or audio stream.
-}
audio : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
audio =
    Node "audio"


{-| Allows authors to specify alternative media resources for media elements
like `video` or `audio`.
-}
source : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
source =
    Node "source"


{-| Allows authors to specify timed text track for media elements like `video`
or `audio`.
-}
track : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
track =
    Node "track"


{-| Represents a bitmap area for graphics rendering.
-}
canvas : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
canvas =
    Node "canvas"


{-| Defines a mathematical formula.
-}
math : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
math =
    Node "math"



-- TABULAR DATA


{-| Represents data with more than one dimension.
-}
table : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
table =
    Node "table"


{-| Represents the title of a table.
-}
caption : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
caption =
    Node "caption"


{-| Represents a set of one or more columns of a table.
-}
colgroup : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
colgroup =
    Node "colgroup"


{-| Represents a column of a table.
-}
col : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
col =
    Node "col"


{-| Represents the block of rows that describes the concrete data of a table.
-}
tbody : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
tbody =
    Node "tbody"


{-| Represents the block of rows that describes the column labels of a table.
-}
thead : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
thead =
    Node "thead"


{-| Represents the block of rows that describes the column summaries of a table.
-}
tfoot : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
tfoot =
    Node "tfoot"


{-| Represents a row of cells in a table.
-}
tr : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
tr =
    Node "tr"


{-| Represents a data cell in a table.
-}
td : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
td =
    Node "td"


{-| Represents a header cell in a table.
-}
th : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
th =
    Node "th"



-- FORMS


{-| Represents a form, consisting of controls, that can be submitted to a
server for processing.
-}
form : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
form =
    Node "form"


{-| Represents a set of controls.
-}
fieldset : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
fieldset =
    Node "fieldset"


{-| Represents the caption for a `fieldset`.
-}
legend : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
legend =
    Node "legend"


{-| Represents the caption of a form control.
-}
label : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
label =
    Node "label"


{-| Represents a typed data field allowing the user to edit the data.
-}
input : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
input =
    Node "input"


{-| Represents a button.
-}
button : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
button =
    Node "button"


{-| Represents a control allowing selection among a set of options.
-}
select : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
select =
    Node "select"


{-| Represents a set of predefined options for other controls.
-}
datalist : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
datalist =
    Node "datalist"


{-| Represents a set of options, logically grouped.
-}
optgroup : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
optgroup =
    Node "optgroup"


{-| Represents an option in a `select` element or a suggestion of a `datalist`
element.
-}
option : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
option =
    Node "option"


{-| Represents a multiline text edit control.
-}
textarea : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
textarea =
    Node "textarea"


{-| Represents the result of a calculation.
-}
output : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
output =
    Node "output"


{-| Represents the completion progress of a task.
-}
progress : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
progress =
    Node "progress"


{-| Represents a scalar measurement (or a fractional value), within a known
range.
-}
meter : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
meter =
    Node "meter"



-- INTERACTIVE ELEMENTS


{-| Represents a widget from which the user can obtain additional information
or controls.
-}
details : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
details =
    Node "details"


{-| Represents a summary, caption, or legend for a given `details`.
-}
summary : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
summary =
    Node "summary"


{-| Represents a command that the user can invoke.
-}
menuitem : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
menuitem =
    Node "menuitem"


{-| Represents a list of commands.
-}
menu : List (Attribute userText msg) -> List (Html userText msg) -> Html userText msg
menu =
    Node "menu"
