STOW := stow --dir=$(CURDIR) --target=$(HOME)

.PHONY: home work mac delete-home delete-work delete-mac

home:
	$(STOW) bash bin brave chromium DankMaterialShell fontconfig fonts foot gtk-home mango mango-home mimeapps-home nvim rofi shell-home solaar tmux waybar waypaper-home zed

work:
	$(STOW) bash bin brave chromium DankMaterialShell fontconfig fonts foot gtk-work mango mango-work mimeapps-work nvim rofi shell-work solaar terminator waybar waypaper-work tmux zed

mac:
	$(STOW) fonts ghostty nvim shell-mac tmux zsh

delete-home:
	$(STOW) -D nvim fonts bash bin chromium fontconfig foot gtk-home hypr hypr-home tmux waybar waypaper-home

delete-work:
	$(STOW) -D nvim fonts bash bin brave chromium fontconfig foot gtk-work hypr hypr-work linux-common terminator waybar waypaper-work tmux xdg-work

delete-mac:
	$(STOW) -D fonts ghostty nvim shell-mac tmux zsh
