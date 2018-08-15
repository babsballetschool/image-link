module ImageLink exposing (..)

import Html


main =
    Html.text "Hello, World!"



-- Model


type Image
    = Image
        { source : String
        , description : Maybe String
        }
