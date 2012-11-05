include ../../build/modules.mk

MODULE = markitup
FILENAME = ${MODULE}.js
SOURCE = markitup/jquery.${MODULE}.js
PRODUCTION = ${PRODUCTION_DIR}/${FILENAME}
DEVELOPMENT = ${DEVELOPMENT_DIR}/${FILENAME}
DEVELOPMENT_FOLDER = ${DEVELOPMENT_DIR}/${MODULE}
PRODUCTION_FOLDER  = ${PRODUCTION_DIR}/${MODULE}
DEVELOPMENT_SETS   = ${DEVELOPMENT_FOLDER}/sets
PRODUCTION_SETS    = ${PRODUCTION_FOLDER}/sets
DEVELOPMENT_SKINS  = ${DEVELOPMENT_FOLDER}/skins
PRODUCTION_SKINS   = ${PRODUCTION_FOLDER}/skins


all: body sets skins

body:
	mkdir -p ${DEVELOPMENT_FOLDER}
	mkdir -p ${PRODUCTION_FOLDER}
	${MODULARIZE} -jq -n "${MODULE}" ${SOURCE} > ${DEVELOPMENT}
	${UGLIFYJS} ${DEVELOPMENT} > ${PRODUCTION}

sets:
	mkdir -p ${PRODUCTION_SETS}
	mkdir -p ${DEVELOPMENT_SETS}

	# HTML
	# "markitup/sets/html"
	mkdir -p ${DEVELOPMENT_SETS}/html
	mkdir -p ${PRODUCTION_SETS}/html
	cp markitup/sets/default/style.css ${DEVELOPMENT_SETS}/html/style.css
	${UGLIFYCSS} markitup/sets/default/style.css > ${PRODUCTION_SETS}/html/style.css
	cp -R markitup/sets/default/images ${DEVELOPMENT_SETS}/html/images
	cp -R markitup/sets/default/images ${PRODUCTION_SETS}/html/images
	${MODULARIZE} -jq -n "markitup/sets/html" markitup/sets/default/set.js > ${DEVELOPMENT_SETS}/html.js
	${UGLIFYJS} ${DEVELOPMENT_SETS}/html.js > ${PRODUCTION_SETS}/html.js

skins:
	mkdir -p ${DEVELOPMENT_SKINS}
	mkdir -p ${PRODUCTION_SKINS}

	# markitup
	# "markitup/skins/markitup"
	mkdir -p ${DEVELOPMENT_SKINS}/default
	mkdir -p ${PRODUCTION_SKINS}/default
	cp markitup/skins/markitup/style.css ${DEVELOPMENT_SKINS}/default.css
	${UGLIFYCSS} markitup/skins/markitup/style.css > ${PRODUCTION_SKINS}/default.css
	cp -R markitup/skins/markitup/images ${DEVELOPMENT_SKINS}/default/images
	cp -R markitup/skins/markitup/images ${PRODUCTION_SKINS}/default/images

	# markitup
	# "markitup/skins/simple"
	mkdir -p ${DEVELOPMENT_SKINS}/simple
	mkdir -p ${PRODUCTION_SKINS}/simple
	cp markitup/skins/simple/style.css ${DEVELOPMENT_SKINS}/simple.css
	${UGLIFYCSS} markitup/skins/simple/style.css > ${PRODUCTION_SKINS}/simple.css
	cp -R markitup/skins/simple/images ${DEVELOPMENT_SKINS}/simple/images
	cp -R markitup/skins/simple/images ${PRODUCTION_SKINS}/simple/images

	# also to styles
	mkdir -p ${STYLES_DIR}/markitup
	cat markitup/skins/simple/style.css | sed 's/url(simple\//url(@{foundry}\/styles\/markitup\//g' > ${STYLES_DIR}/markitup/default.less
	cp -R markitup/skins/simple/images ${STYLES_DIR}/markitup/images

clean:
	rm -rf ${DEVELOPMENT}
	rm -rf ${DEVELOPMENT_FOLDER}
	rm -rf ${PRODUCTION}
	rm -rf ${PRODUCTION_FOLDER}
	rm -rf ${PRODUCTION_SETS}
	rm -rf ${DEVELOPMENT_SETS}
	rm -rf ${DEVELOPMENT_SKINS}
	rm -rf ${PRODUCTION_SKINS}

