# Custome user linux config

## Installation

Clone the project using this command:
```sh
git clone git@github.com:HodeiG/home.git
```

Once the project has been cloned, create a software link to the files that want
to be used.

Finally, modify your .bashrc and append the following line at the end of file.

```sh
source $HOME/.my_bashrc
```

## Dependencies

### FZF:

Install via apt `apt install fzf` or using `git`:

```bash
$ git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
$ ~/.fzf/install
```

### Ripgrep [rust]

$ Install it via cargo:

```bash
$ cargo install ripgrep
```

### Zellij (multiplexer)

Install via cargo:

```bash
$ cargo install zellij
$ mkdir ~/.config/zellij
$ zellij setup --dump-config > ~/.config/zellij/config.kdl
```

### Nerd Fonts

In Linux install via git and set .Xresources file:

```bash
$ bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"
```

Execute `fc-list | grep -i nerd` for the different options that can be set in
.Xresources. For instance:

```
XTerm*font: xft:JetBrainsMono\ Nerd\ Font:size=11
```

In Windows install all the fonts downloading them and right click > install
fonts and set Windows Terminal font to `FiraCode Nerd Font`:

```
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
```

### LSDeluxe (lsd) [rust]

# Development

Create a new SSH key, add private key identity to the authentication agent and
upload the public key to github.

```sh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
chmod 600 ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa
<upload public key to github>
```

[Optional] Create .ssh/config file:
```sh
Host github.com
    User git
    IdentityFile ~/.ssh/id_rsa.pu
```

Test configuration.
```sh
ssh -vT git@github.com
```

Before committing any changes, make sure that the remote repository is
configured correctly.

```sh
git remote set-url origin git@github.com:HodeiG/home.git
git pull origin master
```

Make some changes, commit them and finally push them.
```sh
git commit -a
git push origin master
```
