# Custome user linux config

### Installation

Clone instructions.

```sh
$ cd ~
$ git init
$ git remote add origin https://github.com/HodeiG/home.git
$ git pull origin master
```

Modify your .bashrc and append the following line at the end of file.

```sh
source $HOME/.my_bashrc
```

### Development

Create SSH key and add to the SSH-AGENT. Also, upload public key to github.

```sh
ssh-keygen -t rsa -b 4096 - C "your_email@example.com"
chmod 600 ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa
```

Create .ssh/config file:
```sh
Host github.com
    User git
    IdentityFile ~/.ssh/id_rsa.pu
```

Test configuration.
```sh
ssh -vT git@github.com
```

Make some changes, commit them and finally push them.
```sh
git commit -a
git push origin master
```
