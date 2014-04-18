# Configuration d'une stack LAMP *de travail*

## Tool

Bash function to generate password

```bash
genpasswd() {
    local l=$1
        [ "$l" == "" ] && l=16
        tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}
```

Usage : `genpasswd 16` or simply `genpasswd`

## Install serveur chez GANDI Flex:
# Configuration du serveur web Linux

## Accès

- Mot de passe root MySQL: `********************`
- `ssh root@SERVER_IP` / ``********************`
- `ssh lespolypodes@SERVER_IP` / ``********************`

## Install serveur chez GANDI host

- 4 CPU
- 4096 mo de RAM
- IP 1
- dd 10 Go
- Paris, France uniquement
- Mode : Classique
- Type image : Image Gandi
- Nom du disque système : `ubuesquentu`
- OS : Ubuntu 12.10 64 bits
- Version du kernel 3.2-x86_64
- Taille du disque 3 Go (non modifiable, = taille occupée par l’OS)
- hostname : `ClientName`
- login: `admin` ( & `root`)
- mdp : ``********************`

### Snapshot sauvegarde
 
- Proﬁl normal : 7 versions toutes les 24h sur la semaine (24h, 48h, 72h, 96h, 120h et 144h soit 7 jours).

### Configuration opérations FLEX

- Entre 23h et 6h du matin, on n’alloue plus que 1 CPU et 1 Giga de RAM au lieu de 4 et 4 le reste du temps.

## Connexion SSH

```bash
ssh admin@SEVER_IP
su root
```

Création d’un user lespolypodes + ajout de `lespolypodes` au groupe des sudoers

```bash
adduser lespolypodes
password for lespolypodes : `********************
adduser lespolypodes sudo
```

## Install serveur

Adding French locales

```bash
sudo locale-gen fr_FR.UTF-8
```

Commenting the single line in file `/etc/apt/sources.list.d/gandi.list` (causes `Duplicate sources.list entry...` error)

Update `apt` sources

```bash
apt-get update
apt-get upgrade
apt-get dist-upgrade
```

Basic Shell enhancements

```bash
apt-get install vim zsh curl ngrep tree htop sysstat di discus pydf hardinfo
lynx ack-grep pandoc most exuberant-ctags linux-headers-generic
build-essential manpages-fr manpages-fr-extra manpages-dev
```

Zsh FTW

```bash
curl -L http://install.ohmyz.sh | sh
chsh 
```

- Login Shell: `/bin/zsh`

LAMP, the bases

```bash
apt-get install apache2 apache2-mpm-prefork libapache2-mod-php5
apache2-utils php5 php5-dev phpmyadmin mysql-server imagemagick
```

Mot de passe root MySQL: `WZtxj8VHklM!`

LAMP, extensions

```bash
apt-get install php-apc php5-xdebug php5-mysql php5-sqlite php5-cli
php5-curl php-pear php5-gd php5-imagick php5-imap php5-xsl
php5-common php5-mcrypt php5-memcache php5-ps php5-pspell
php5-recode php5-snmp php5-tidy php5-intl
```

NodeJs

```bash
apt-get install python-software-properties python g++ make
apt-get install software-properties-common
add-apt-repository ppa:chris-lea/node.js
apt-get update
apt-get install nodejs
npm cache clear
```

Other CLI-related tools

```bash
sudo apt-get install tidy markdown git git-core git-doc git-svn git-email tig
```

Current `lespolypodes` Linux user becomes an Apacher

```bash
sudo adduser lespolypodes www-data
```

Adding `ClientName` as ServerName to Apache2 in `/etc/apache2/apache2.conf`

Enabling Apache2 mods

```bash
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod deflate
sudo a2enmod expires
sudo a2enmod setenvif
sudo service apache2 restart
```

## PHP

Configuration de php.ini (cli & apache2) pour la production : 

```
[Date]
date.timezone = Europe/Paris

[Phar]
# http://php.net/phar.readonly
phar.readonly = Off

; http://php.net/phar.require-hash
phar.require_hash = Off

detect_unicode = Off
suhosin.executor.include.whitelist = phar
```

Installation de `composer` :

- dans le fichier .zshrc, ajouter $HOME/bin aux variables de $PATH (séparées par des ":")
- installer composer en local :

```bash
mkdir ~/bin
cd ~/bin
curl -s http://getcomposer.org/installer | php
mv composer.phar composer
chmod +x composer
```

## Base de donnée et sauvegardes locales

Configuration de fail2ban :

- http://doc.ubuntu-fr.org/fail2ban

Configuration de PhpMyAdmin : Modification de lʼalias `phpmyadmin` en `myVerySecretPathToPhpMy4dm1nnn` dans le fichier `/etc/apache2/conf.d/phpmyadmin.conf`

```bash
vim /etc/apache2/conf.d/phpmyadmin.conf
service apache2 reload
```

Création dʼun utilisateur sql et dʼune base attachée : `ClientName_prod` / `ClientName_prod` / `********************`

Création et configuration du script de backup (avec le $HOME et le user `lespolypodes`). Les backups sont générés dans le répertoire `/var/backups/mysql` tous les matin à 01h00 via la crontab de l'utilisateur `lespolypodes`.

```bash
sudo mkdir /var/backups/mysql
cd ~/bin
curl https://gist.github.com/ronanguilloux/1595563 > automysqlbackup.sh
vim automysqlbackup.sh
chmod a+x automysqlbackup.sh
crontab -e
```



