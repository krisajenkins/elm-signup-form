all: index.html

index.html: SignupForm.elm
	elm-make --yes $< --output=$@
