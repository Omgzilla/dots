STOW := stow --dir=$(CURDIR) --target=$(HOME)

.PHONY: home work mac delete-home delete-work delete-mac

home:
	$(STOW) bash bin brave chromium dms fontconfig fonts foot gtk-home mango mango-home mimeapps-home nvim rofi shell-home solaar tmux waybar waypaper-home zed

work:
	$(STOW) bash bin brave chromium dms fontconfig fonts foot gtk-work mango mango-work mimeapps-work nvim rofi shell-work solaar terminator waybar waypaper-work tmux zed

mac:
	$(STOW) fonts ghostty nvim shell-mac tmux zsh

delete-home:
	$(STOW) -D bash bin brave chromium dms fontconfig fonts foot gtk-home mango mango-home mimeapps-home nvim rofi shell-home solaar tmux waybar waypaper-home zed

delete-work:
	$(STOW) -D bash bin brave chromium dms fontconfig fonts foot gtk-work mango mango-work mimeapps-work nvim rofi shell-work solaar terminator waybar waypaper-work tmux zed

delete-mac:
	$(STOW) -D fonts ghostty nvim shell-mac tmux zsh
