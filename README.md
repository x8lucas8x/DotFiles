# Dot Files

Configuration files for editors and other UNIX tools.
These make it easier for me to setup a programming environment.
They include things, such as:

- neovim
- starship
- kitty
- zellij
- yazi
- zoxide
- fzf
- lazygit
- Nerd fonts
- zsh

## How to install?

On Mac:

```bash
 chmod +x install-mac.sh
 ./install-mac.sh
 ```

On arch-based distro:

```bash
 chmod +x install-arch.sh
 ./install-arch.sh
 ```

On SSH server you aren't an admin, but have rust/golang available:

```bash
 chmod +x install-server.sh
 ./install-server.sh
 ```

## Extras

After installing, you might need to perform extra actions.

### GIT

You need to set **GIT_AUTHOR_EMAIL** and **GIT_COMMITTER_EMAIL** env variables in
a **~/.env.local** file, before first committing.

### Extending/Overriding shell configs

If available on your home directory, the following files will be used to
extend whatever is defined on the **stow/shell** folder:

- ~/.bashrc.local
- ~/.zshrc.local
- ~/.env.local

Finally, anything that shouldn't be committed (e.g., secrets, work-specific env variables)
should be put into them.

### Non-Dot Files

On the *nonStow* folder there are also other files, which are meant
be reused without GNU stow (e.g., kde exports). Just in case the
stow folders does not work after say an upgrade.
