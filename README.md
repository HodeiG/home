# Custome user linux config

### Installation

The best recommended way to install these files is to download the ZIP file and
copy the content to the $HOME directory.

Finally, modify your .bashrc and append the following line at the end of file.

```sh
source $HOME/.my_bashrc
```

### Development

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

Before committing any changes, make sure that the remote repository is set correctly.

```sh
git remote set-url origin git@github.com:HodeiG/home.git
git pull origin master
```

Make some changes, commit them and finally push them.
```sh
git commit -a
git push origin master
```
