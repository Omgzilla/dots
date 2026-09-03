STOW := stow --dir=$(CURDIR) --target=$(HOME)

.PHONY: home work mac delete-home delete-work delete-mac

home:
	$(STOW) bash bin brave chromium fontconfig fonts foot gtk-home hypr hypr-home mango mimeapps-home nvim rofi shell-home waybar waypaper-home

work:
	$(STOW) bash bin brave chromium DankMaterialShell fontconfig fonts foot gtk-work hypr hypr-work mango mimeapps-work nvim quickshell-work rofi shell-work terminator waybar waypaper-work tmux

mac:
	$(STOW) ghostty tmux zsh

delete-home:
	$(STOW) -D shell-common nvim fonts bash bin chromium fontconfig foot gtk-home hypr hypr-home linux-common tmux waybar waypaper-home xdg-home

delete-work:
	$(STOW) -D shell-common nvim fonts bash bin brave chromium fontconfig foot gtk-work hypr hypr-work linux-common terminator waybar waypaper-work tmux xdg-work

delete-mac:
	$(STOW) -D shell-common nvim fonts ghostty tmux zsh
