all: build

build watch: babel_flags += -s
watch: babel_flags += -w

build watch:
	babel $(babel_flags) -d build src

test:
	babel-tape-runner tests/**/*.js

$(VERSION):
	bash version.sh $(VERSION)

version: $(VERSION)

.npmignore: .gitignore
	sort -ru .gitignore | grep -v '^build$$' > .npmignore
	echo '.gitignore .npmignore Makefile *.sh' | tr ' ' '\n' >> .npmignore

.kbignore: .npmignore
	sort -ru .npmignore > .kbignore
	echo .git >> .kbignore

sign: .kbignore
	keybase dir sign -p kb

verify:
	keybase dir verify

ifdef VERSION
tag: sign
	git commit -am 'Signed PGP:E6B74303'
	git tag v$(VERSION)
endif

clean:
	rm -rf build
	git checkout SIGNED.md

.PHONY: clean version build watch sign verify tag

