module Layout exposing (view)

import Browser exposing (Document)
import Element exposing (Element, column, el, row, text)
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
        [ Element.link [] { url = "/", label = text "counter" }
        , Element.link [] { url = "/stringreverser", label = text "String Reverser" }
        , Element.link [] { url = "/sammich", label = text "Sammich" }
        ]
