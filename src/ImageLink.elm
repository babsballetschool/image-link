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

createImage : String -> Image
createImage source =
    Image { source = source, description = Nothing }

withDescription : String -> Image -> Image
withDescription description (Image image) =
    Image { image | description = Just description }
