module ImageLink exposing (..)

import Html


main =
    let
        image =
            createImage "resources/image/algemeen/spitzen.jpg"
                |> withDescription "Spitzen aan de bar"

        model =
            { image = Just image }
    in
        view model



-- Model


type alias Model =
    { image : Maybe Image
    }


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



-- View


view : Model -> Html.Html msg
view model =
    case model.image of
        Just image ->
           link image

        Nothing ->
            Html.text "select an image"


link : Image -> Html.Html msg
link (Image { source, description }) =
    let
        text = "![](" ++ source ++ ")"
    in
        Html.pre [] [Html.text text]
