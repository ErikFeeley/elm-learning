module Layout exposing (view)

import Browser exposing (Document)
import Element exposing (Element)
import Html exposing (Html, text)



-- VIEW


view : (a -> msg) -> Element a -> Document msg
view toMsg element =
    { title = "Courses"
    , body = [ Html.map toMsg <| Element.layout [] element ]
    }
