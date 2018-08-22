module ImageLink exposing (..)

import Html exposing (program)
import Html.Attributes as Attribute
import Html.Events as Event
import Json.Decode as Decode
import Formatting exposing (..)
import ImageDirectory as Dir


main : Program Never Model Message
main =
    let
        image =
            createImage "resources/image/algemeen/spitzen.jpg"
                |> withDescription "Spitzen aan de bar"

        model =
            { image = Just image }
    in
        program
            { init = ( model, Cmd.none )
            , view = view
            , update = update
            , subscriptions = \_ -> Sub.none
            }



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


view : Model -> Html.Html Message
view model =
    let
        entry : Result String Dir.Entry
        entry =
            Decode.decodeString Dir.decoder """{
  "type": "directory",
  "contents": [
    { "type": "file", "location":"http://via.placeholder.com/20x20"},
    { "type": "file", "location":"http://via.placeholder.com/20x30"},
    { "type": "directory", "contents": [{ "type": "file", "location":"http://via.placeholder.com/30x20"}] }
  ]
}"""

        entryView =
            case entry of
                Ok actual_entry ->
                    Dir.view UpdateImage actual_entry

                Err _ ->
                    Html.span [] [ Html.text "could not load directory" ]

        toAlt : Image -> String
        toAlt (Image { source, description }) =
            description
                |> Maybe.withDefault ""

        alt =
            model.image
                |> Maybe.map toAlt
                |> Maybe.withDefault ""
    in
        Html.div []
            [ entryView
            , (image model.image)
            , Html.label [] [ Html.text "alt:" ]
            , Html.input
                [ Event.onInput UpdateDescription
                , Attribute.value alt
                ]
                []
            ]


image : Maybe Image -> Html.Html msg
image image =
    case image of
        Just image ->
            link image

        Nothing ->
            default "select an image"


link : Image -> Html.Html msg
link (Image { source, description }) =
    let
        alt =
            Maybe.withDefault "" description

        text =
            linkFormatter alt source
    in
        Html.pre [] [ Html.text text ]


default : String -> Html.Html msg
default defaultText =
    Html.pre [] [ Html.text defaultText ]


linkFormatter : String -> String -> String
linkFormatter =
    let
        format =
            s "![" <> string <> s "](" <> string <> s ")"
    in
        print format
