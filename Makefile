all: modularize-script submodules

include ../../build/modules.mk

MODULE = markitup
MODULARIZE_OPTIONS = -jq

SOURCE_SCRIPT_FOLDER = markitup

SET_HTML_LESS_CONVERTER     = sed 's/url(images\//url(@{foundry_uri}\/markitup\/sets\/html\/images\//g'
SKIN_DEFAULT_LESS_CONVERTER = sed 's/url(default\/images\//url(@{foundry_uri}\/markitup\/skins\/default\/images\//g'
SKIN_SIMPLE_LESS_CONVERTER  = sed 's/url(simple\/images\//url(@{foundry_uri}\/markitup\/skins\/simple\/images\//g'

submodules:
	make set-html
	make skin-default
	make skin-simple

prep-set-%:
	$(eval MODULE                   = markitup/sets/$*)
	$(eval SOURCE_SCRIPT_FOLDER     = markitup/sets)
	$(eval SOURCE_SCRIPT_FILE       = markitup/sets/$*/set.js)
	$(eval TARGET_SCRIPT_FOLDER     = ${FOUNDRY_SCRIPTS_FOLDER}/markitup/sets)
	$(eval TARGET_SCRIPT_FILE_NAME  = $*)
	$(eval SOURCE_STYLE_FILE        = markitup/sets/$*/style.css)
	$(eval TARGET_STYLE_FILE_NAME   = $*)
	$(eval SOURCE_ASSET_FILES       = markitup/sets/$*/images/*)
	$(eval TARGET_ASSET_FOLDER_NAME = images)

set-html: prep-set-html .set-html create-script-folder modularize-script copy-style minify-style lessify-style copy-assets

.set-html:
	# Because we want to rename the source folder from html to default, but roll out as html.
	$(eval SOURCE_STYLE_FILE  = markitup/sets/default/style.css)
	$(eval SOURCE_SCRIPT_FILE = markitup/sets/default/set.js)
	$(eval SOURCE_ASSET_FILES = markitup/sets/default/images/*)
	$(eval TARGET_STYLE_LESS_CONVERTER = ${SET_HTML_LESS_CONVERTER})

prep-skin-%:
	$(eval SOURCE_STYLE_FOLDER      = markitup/skins/$*)
	$(eval SOURCE_STYLE_FILE        = markitup/skins/$*/style.css)
	$(eval TARGET_STYLE_FOLDER      = ${FOUNDRY_STYLES_FOLDER}/markitup/skins/$*)
	$(eval TARGET_STYLE_FILE_NAME   = style)
	$(eval SOURCE_ASSET_FILES       = markitup/skins/$*/images/*)
	$(eval TARGET_ASSET_FOLDER_NAME = images)

skin-default: prep-skin-default .skin-default copy-style minify-style lessify-style copy-assets

.skin-default:
	# Because we want to rename the source folder from default to markitup, but roll out as default.
	$(eval SOURCE_STYLE_FOLDER = markitup/skins/markitup)
	$(eval SOURCE_STYLE_FILE   = markitup/skins/markitup/style.css)	
	$(eval SOURCE_ASSET_FILES  = markitup/skins/markitup/images/*)
	$(eval TARGET_STYLE_LESS_CONVERTER = ${SKIN_DEFAULT_LESS_CONVERTER})

skin-simple: prep-skin-simple .skin-simple copy-style minify-style lessify-style copy-assets

.skin-simple:
	$(eval TARGET_STYLE_LESS_CONVERTER = ${SKIN_SIMPLE_LESS_CONVERTER})
