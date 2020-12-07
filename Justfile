dist := "build"


default: clean build


@clean:
	rm -rf {{dist}} || true
	mkdir -p {{dist}}


@build: html css elm



# Parts
# =====

@css:
	echo "💄  Compiling CSS"
	pnpx etc src/Css/Application.css \
	 --config src/Css/Tailwind.js \
		--elm-module Css.Classes \
		--elm-path src/Library/Css/Classes.elm \
		--output {{dist}}/application.css


@elm:
	echo "🌳  Compiling Elm"
	elm make \
		--output {{dist}}/application.js \
		src/Application/Main.elm


@html:
	echo "📜  Compiling HTML"
	mustache \
		--layout src/Html/Layout.html \
		config/default.yml src/Html/Application.html \
		> {{dist}}/index.html
