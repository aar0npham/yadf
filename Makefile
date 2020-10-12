.PHONY: install init stow build run

.DEFAULT: install

init:
	chmod +x init/*.sh && ./init/init.sh
stow:	
	cd pkg && . stow.sh
install: init
	./init/install.sh
build:
	docker build -t aar0npham/dotfiles:latest .
run:
	docker run -it aar0npham/dotfiles:latest

