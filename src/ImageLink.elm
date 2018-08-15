module ImageLink exposing (..)

import Html


main =
    Html.text "Hello, World!"



-- Model


type alias Image =
    { source : String
    , description : Maybe String
    }
