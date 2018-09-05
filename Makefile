
all: javascript html style images fonts
	
javascript: bin/index.js

html: bin/index.html

style: bin/style.css

images: bin/images

fonts : bin/font

bin/images: bin $(wildcard src/images/*)
	mkdir -p bin/images
	cp $(wildcard src/images/*) bin/images

bin/font/: bin $(wildcard src/font/*)
	mkdir -p bin/font
	cp $(wildcard src/font/*) bin/font

bin/index.js : bin src/Main.elm
	./node_modules/.bin/elm make --output bin/index.js src/Main.elm

bin/index.html : bin src/index.html
	cp src/index.html bin/

bin/style.css : bin src/style.css
	cp src/style.css bin/

bin :
	mkdir bin

.PHONY: clean
clean :
	-rm -r bin

