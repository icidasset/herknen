dist := "build"
workbox_config := "workbox.config.cjs"


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


@css-small:
	echo "💄  Minifying CSS"
	NODE_ENV=production pnpx etc src/Css/Application.css \
		--config src/Css/Tailwind.js \
		--output {{dist}}/application.css \
		\
		--purge-content {{dist}}/**/*.html \
		--purge-content {{dist}}/application.js \
		--purge-content src/Library/Theme.elm


@elm-dev:
	echo "🌳  Compiling Elm"
	elm make \
		--debug \
		--output {{dist}}/application.js \
		src/Application/Main.elm


@elm-production:
	echo "🌳  Compiling Elm (production)"
	elm make \
		--optimize \
		--output {{dist}}/application.js \
		src/Application/Main.elm


@favicons:
	echo "🚚  Transferring favicons"
	cp src/Favicons/* {{dist}}/


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


@manifests:
	echo "🚚  Transferring manifests"
	cp src/Manifests/* {{dist}}/


@minify-js:
	echo "🏗  Minifying javascript"
	just min-js {{dist}}/application.js
	just min-js {{dist}}/index.js


@min-js path:
	cat {{path}} | ./node_modules/.bin/esbuild --minify > {{path}}.tmp
	rm {{path}}
	mv {{path}}.tmp {{path}}


@schemas:
	# echo "🌳  Generating Elm files from schemas"
	# mkdir -p src/Generated
	# pnpx quicktype --array-type --no-ignore-json-refs --module Group -s schema src/Schemas/Group.json -o src/Generated/Group.elm
	# pnpx quicktype --array-type --no-ignore-json-refs --module Unit -s schema src/Schemas/Unit.json -o src/Generated/Unit.elm


@vendor:
	echo "🏗  Copying vendor javascript"
	mkdir {{dist}}/vendor
	cp node_modules/webnative/index.umd.js {{dist}}/vendor/webnative.js
	cp node_modules/webnative-elm/src/funnel.js {{dist}}/vendor/webnative-elm.js


# Service worker
# ==============

@service-worker:
	echo "⚙️  Generating service worker"
	NODE_ENV=development pnpx workbox generateSW {{workbox_config}}


@production-service-worker:
	echo "⚙️  Generating service worker"
	NODE_ENV=production pnpx workbox generateSW {{workbox_config}}



# Development
# ===========


@clean:
	rm -rf {{dist}} || true
	mkdir -p {{dist}}


@deploy-production: production-build
	echo "🛳  Deploying to Fission"
	fission app publish


@dev-build: clean vendor schemas html css-large elm-dev javascript fonts favicons manifests service-worker


@dev-server:
	echo "🧞  Putting up a server for ya"
	echo "http://localhost:8003"
	devd --quiet build --port=8003 --all


@install-deps:
	pnpm install


@production-build: clean vendor schemas html elm-production javascript fonts favicons manifests css-small minify-js production-service-worker


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
