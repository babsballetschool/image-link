module ImageLink exposing (..)

import Html
import Formatting exposing (..)


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



-- Update


type Message
    = UpdateImage String
    | UpdateDescription String


update : Message -> Model -> ( Model, Cmd msg )
update message model =
    let
        nextModel =
            case message of
                UpdateImage source ->
                    let
                        image =
                            createImage source
                    in
                        { image = Just image }

                UpdateDescription description ->
                    let
                        nextImage =
                            Maybe.map (\model -> model |> withDescription description) model.image
                    in
                        { image = nextImage }
    in
        ( nextModel, Cmd.none )



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
        alt =
            Maybe.withDefault "" description

        text =
            linkFormatter alt source
    in
        Html.pre [] [ Html.text text ]


linkFormatter : String -> String -> String
linkFormatter =
    let
        format =
            s "![" <> string <> s "](" <> string <> s ")"
    in
        print format
