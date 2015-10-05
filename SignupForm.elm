module SignupForm where

import Debug
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (id, type', for, value, class, property, style)

import StartApp exposing (App)
import Effects exposing (Effects, none)
import Time
import Signal exposing (..)
import Json.Encode

type alias Model =
  { username : String }

type Action
  = NoOp
  | SetUsername String

view : Address Action -> Model -> Html
view actionDispatcher model =
    form
        [ id "signup-form", style [("margin", "20px")] ]
        [ h1 [] [ text "Form" ]
        , label [ for "username-field" ] [ text "unstable: " ]
        , input
            [ id "username-field"
            , type' "text"
            , value model.username
            , on "input" targetValue (Signal.message actionDispatcher << SetUsername)
            ]
            []
        , p [] [text "Type something into the field
                      above. Then move the cursor to the start of the box, and type
                      fast (or just mash at the keyboard). Fairly quickly, you'll
                      see the cursor magically jumps to the end of the input
                      box. The field below does not exhibit this bug because there's
                      no conflict between the user setting the value and the
                      model."]
        , label [ for "stable" ] [ text "stable: " ]
        , input
            [ id "stable-field"
            , type' "test"
            , property "defaultValue" (Json.Encode.string model.username)
            , on "input" targetValue (Signal.message actionDispatcher << SetUsername)
            ]
            []
        ]

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp -> (model, none)
    SetUsername s -> ({model | username <- s}, none)

initialModel : Model
initialModel = { username = "" }

app : App Model
app = StartApp.start
  { init = (initialModel, Effects.none)
  , update = update
  , view = view
  , inputs = [(\_ -> NoOp)<~ Time.fps 30]}

main : Signal Html
main = app.html
