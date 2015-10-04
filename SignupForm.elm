-- declares that this is the SignupForm module, which is how
-- other modules will reference this one if they want to import it and reuse its code.
module SignupForm where

-- Elm’s "import" keyword works mostly like "require" in node.js.
-- The “exposing (..)” option specifies that we want to bring the Html module’s contents
-- into this file’s current namespace, so that instead of writing out
-- Html.form and Html.label we can just use "form" and "label" without the "Html." prefix.
import Html exposing (..)

-- This works the same way; we also want to import the entire
-- Html.Events module into the current namespace.
import Html.Events exposing (..)

-- With this import we are only bringing a few specific functions into our
-- namespace, specifically "id", "type'", "for", "value", and "class".
import Html.Attributes exposing (id, type', for, value, class, property, style)

import StartApp
import Effects
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
            , on "input" targetValue (\str -> Signal.message actionDispatcher { actionType = "SET_USERNAME", payload = str })
            ]
            []
        , div [ class "validation-error" ] [ text model.errors.username ]
        , label [ for "password" ] [ text "password: " ]
        , input
            [ id "password-field"
            , type' "password"
            , value model.password
            , on "input" targetValue (\str -> Signal.message actionDispatcher { actionType = "SET_PASSWORD", payload = str })
            ]
            []
        , div [ class "validation-error" ] [ text model.errors.password ]
        , div [ class "signup-button", onClick actionDispatcher { actionType = "VALIDATE", payload = "" } ] [ text "Sign Up!" ]
        , p [] [text "Type something into the username field above. Then move the cursor to the start of the box, and type fast (or just mash at the keyboard). Fairly quickly, you'll see the cursor magically jumps to the end of the input box. When the FPS action gets processed out of sequence with the `on 'input'` action. The field below will not exhibit this bug."]
        , label [ for "safe" ] [ text "safe: " ]
        , input
            [ id "safe-field"
            , type' "test"
            , property "defaultValue" (Json.Encode.string model.username)
            , on "input" targetValue (\str -> Signal.message actionDispatcher { actionType = "SET_USERNAME", payload = str })
            ]
            []
        ]


initialErrors =
    { username = "", password = "" }


getErrors model =
    { username =
        if model.username == "" then
            "Please enter a username!"
        else
            ""

    , password =
        if model.password == "" then
            "Please enter a password!"
        else
            ""
    }


update action model =
    if action.actionType == "VALIDATE" then
        ({ model | errors <- getErrors model }, Effects.none)
    else if action.actionType == "NOOP" then
        (model, Effects.none)
    else if action.actionType == "SET_USERNAME" then
        ({ model | username <- action.payload, errors <- initialErrors }, Effects.none)
    else if action.actionType == "SET_PASSWORD" then
        ({ model | password <- action.payload, errors <- initialErrors }, Effects.none)
    else
        (model, Effects.none)


initialModel =
    { username = "", password = "", errors = initialErrors }


app =
    StartApp.start
        { init = (initialModel, Effects.none)
        , update = update
        , view = view
        , inputs = [(\_ -> {actionType = "NOOP", payload = ""})<~ Time.fps 30]
        }

main =
    app.html
