# DePaula

Ferramentas para criar um pendrive bootável com Ubuntu.

## Pré-requisitos

Instale os seguintes pacotes e execute os comandos com privilégios de administrador (use `sudo`):

* `alien` - conversão de formatos de pacote.
* `dnf` - gerenciador de pacotes usado nos passos de instalação.
* Direitos de administrador.

## Identificando o dispositivo correto

Antes de gravar a imagem, descubra qual é o pendrive alvo usando `lsblk`:

```bash
$ lsblk
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda      8:0    0 100G  0 disk
├─sda1   8:1    0  95G  0 part /
└─sda2   8:2    0   5G  0 part [SWAP]
sdb      8:16   1  16G  0 disk
└─sdb1   8:17   1  16G  0 part /media/usb
```

No exemplo acima o pendrive é `sdb`. **Todos os dados do dispositivo escolhido serão apagados**, portanto confirme o caminho antes de continuar.

## Uso do script

O repositório contém o script `usb-ubuntu.sh` que procura automaticamente um pendrive de aproximadamente 59GB, 64GB ou 113GB e grava nele a imagem do Ubuntu 24.04.2. Execute:

```bash
sudo ./usb-ubuntu.sh
```

Responda `s` quando solicitar confirmação. Após a conclusão, o pendrive estará pronto para boot.
