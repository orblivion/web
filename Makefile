MAKEFLAGS := --no-builtin-rules

USER         := xand
HOST         := hackfreeordie.org
PORT         := 22
USER_AT_HOST := $(USER)@$(HOST)

DIR_LOCAL  := dist
DIR_SERVER := /var/www

.PHONY: generate
generate:
	mkdir -p $(DIR_LOCAL)
	./generate.rkt -o $(DIR_LOCAL)

.PHONY: deploy
deploy:
	rsync \
		-avz \
		--delete \
		--omit-dir-times \
		--copy-links \
		./$(DIR_LOCAL)/* \
		-e 'ssh -p $(PORT)' \
		$(USER_AT_HOST):$(DIR_SERVER)
	ssh -p $(PORT) $(USER_AT_HOST) chmod -R a+rX $(DIR_SERVER)
