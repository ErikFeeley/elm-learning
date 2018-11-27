module Layout exposing (view)

import Browser exposing (Document)
import Element exposing (Element, column, el, link, row, text)
import Html



-- VIEW


view : (a -> msg) -> Element a -> Document msg
view toMsg element =
    { title = "Courses"
    , body =
        [ Html.map toMsg <|
            Element.layout [] <|
                column []
                    [ viewNav
                    , element
                    ]
        ]
    }


viewNav : Element msg
viewNav =
    row [ Element.padding 2, Element.spacing 4 ]
        [ link [] { url = "/", label = text "counter" }
        , link [] { url = "/form", label = text "Form" }
        , link [] { url = "/phttp", label = text "PHttp" }
        , link [] { url = "/jsondecoding", label = text "Json Decoding" }
        , link [] { url = "/stringreverser", label = text "String Reverser" }
        , link [] { url = "time", label = text "Time" }
        ]
