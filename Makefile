STOW := stow --dir=$(CURDIR) --target=$(HOME) --no-folding

.PHONY: common linux-home linux-work mac delete-linux-home delete-linux-work delete-mac

common:
	$(STOW) shell-common nvim fonts

linux-home:
	$(STOW) bash bin brave chromium fontconfig foot gtk-home hypr hypr-home linux-common mango waybar waypaper-home xdg-home

linux-work:
	$(STOW) bash bin brave chromium fontconfig foot gtk-work hypr hypr-work linux-common terminator waybar waypaper-work tmux xdg-work

mac:
	$(STOW) ghostty tmux zsh

delete-linux-home:
	$(STOW) -D shell-common nvim fonts bash bin brave chromium fontconfig foot gtk-home hypr hypr-home linux-common waybar waypaper-home xdg-home

delete-linux-work:
	$(STOW) -D shell-common nvim fonts bash bin brave chromium fontconfig foot gtk-work hypr hypr-work linux-common terminator waybar waypaper-work tmux xdg-work

delete-mac:
	$(STOW) -D shell-common nvim fonts ghostty tmux zsh
