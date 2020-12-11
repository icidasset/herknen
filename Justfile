dist := "build"


@default: dev-build
	just dev-server & just watch



# Parts
# =====

@css-large:
	echo "💄  Compiling CSS"
	pnpx etc src/Css/Application.css \
		--config src/Css/Tailwind.js \
		--elm-module Css.Classes \
		--elm-path src/Generated/Css/Classes.elm \
		--output {{dist}}/application.css


@elm-dev:
	echo "🌳  Compiling Elm"
	elm make \
		--output {{dist}}/application.js \
		src/Application/Main.elm


@fonts:
	echo "🔤  Copying fonts"
	mkdir -p {{dist}}/fonts/
	cp src/Fonts/*.woff2 {{dist}}/fonts/


@html:
	echo "📜  Compiling HTML"
	mustache \
		--layout src/Html/Layout.html \
		config/default.yml src/Html/Application.html \
		> {{dist}}/index.html


@javascript:
	echo "🏗  Compiling javascript"
	cp src/Javascript/Main.js {{dist}}/index.js


@schemas:
	# echo "🌳  Generating Elm files from schemas"
	# mkdir -p src/Generated
	# pnpx quicktype --array-type --no-ignore-json-refs --module Group -s schema src/Schemas/Group.json -o src/Generated/Group.elm
	# pnpx quicktype --array-type --no-ignore-json-refs --module Unit -s schema src/Schemas/Unit.json -o src/Generated/Unit.elm


@vendor:
	echo "🏗  Copying vendor javascript"
	mkdir {{dist}}/vendor
	cp node_modules/webnative/index.umd.js {{dist}}/vendor/webnative.umd.js



# Development
# ===========


@clean:
	rm -rf {{dist}} || true
	mkdir -p {{dist}}


@dev-build: clean vendor schemas html css-large elm-dev javascript fonts


@dev-server:
	echo "🧞  Putting up a server for ya"
	echo "http://localhost:8003"
	devd --quiet build --port=8003 --all


@watch:
	echo "👀  Watching for changes"
	just watch-css & \
	just watch-elm & \
	just watch-html & \
	just watch-js


@watch-css:
	watchexec -p -w src -f "*/Css/**/*.*" -i build -- just css-large


@watch-elm:
	watchexec -p -w src -e elm -- just elm-dev


@watch-js:
	watchexec -p -w src -e js -- just javascript


@watch-html:
	watchexec -p -w src -e html -- just html
