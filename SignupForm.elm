module SignupForm where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (id, type', for, value, class, property, style)

import StartApp
import Effects exposing (none)
import Time
import Signal exposing (..)
import Json.Encode

view actionDispatcher model =
    form
        [ id "signup-form", style [("margin", "20px")] ]
        [ div [] [code [] [text <| toString model]]
        , h1 [] [ text "Sensational Signup Form" ]
        , label [ for "username-field" ] [ text "username: " ]
        , input
            [ id "username-field"
            , type' "text"
            , value model.username
            , on "input" targetValue (Signal.message actionDispatcher << SetUsername)
            ]
            []
        , p [] [text "Type something into the username field above. Then move the cursor to the start of the box, and type fast (or just mash at the keyboard). Fairly quickly, you'll see the cursor magically jumps to the end of the input box. This is because the input event is triggering a change to the model, which triggers a change to the field value. This works fine as long as the whole thing is processed before the next input event triggers. By including an FPS signal, we can slow the system down enough to When the FPS action gets processed out of sequence with the `on 'input'` action. The field below will not exhibit this bug because the value is only set on first ."]
        , label [ for "safe" ] [ text "safe: " ]
        , input
            [ id "safe-field"
            , type' "test"
            , property "defaultValue" (Json.Encode.string model.username)
            , on "input" targetValue (Signal.message actionDispatcher << SetUsername)
            ]
            []
        ]

type Action
  = NoOp
  | SetUsername String

update action model =
  case action of
    NoOp -> (model, none)
    SetUsername s -> ({model | username <- s}, none)

initialModel = { username = "" }

app =
    StartApp.start
        { init = (initialModel, Effects.none)
        , update = update
        , view = view
        , inputs = [(\_ -> NoOp)<~ Time.fps 30]
        }

main = app.html
