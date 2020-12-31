.PHONY: init build run stow

.DEFAULT: init

init:
	chmod +x init/*.sh && ./init/init.sh
stow:
	stow config --target=${HOME} --ignore='stow.sh'
	stow macos --target=${HOME}/Library/Application\ Support/Übersicht/widgets
build:
	docker build -t aar0npham/dotfiles:latest .
run:
	docker run -it aar0npham/dotfiles:latest
vmware:
	sudo modprobe -a vmw_vmci vmmon
