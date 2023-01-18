
![Captura de tela_20230118_111913](https://i.imgur.com/LSO1sWn.png)

### INFRAESTRUTURA COMO CÓDIGO - IaC
--------
#### 1. Vangrant
- Cria e gerencia máquinas virtuais
- Foco em automação
- Para DevOps: Usada para testes de scripts de infraestrutura.
- Evita trabalho manual de instalação de SO.

#### Ciclo de vida 

- Gerencamento de ciclo de vida da máquina :
     - SSH para máquina - vagrant ssh
     - Halt/Shutdown do servidor 
     - Destruir a máquina, apagando discos e metados
     - Suspender/ resumir máquina 
     - Empacotar o estado da máquina e distribuir para o time. 

####  Vangrantfile : Arquivo de configuração

- Arquivo VangrantFile- Definição da  máquina virtual.
    * Contém  as propriedades físicas da máquina:
           **Cpu, memória, Disco, Foward de portas, tipos de acesso, compartilhamento de disco**.  
  - Arquivo texto de fácil versionamento.
  - Criado no diretório corrente( vagrant init).
  - _Um VagrantFile por diretório_.
  - É possível ter mais de um box por VangrantFile.
  - Para ter mais máquinas virtuais é necessário declará-las no mesmo Vangrantfile. 


#### Vagrant Boxes

- Box: Imagem base de um sistema operacional (debian, centos..).
- Uma nova máquina é clonada a partir do primeiro download.
- A distribuição das máquinas é feita através de um box file.
- Múltiplas máquinas podem utilizar a mesma box.


#### Funcionalidades 

- Foward de porta :

```python
config.vm.network "fowarded_port",guest:80,host:8080,host_ip:"127.0.0.1"
````	 
- Diretório compartilhado :

```python
config.vm.synced_folder "data","/data" 
```` 

- Script de provisionamento :

```python
config.vm.provision "shell",inline: <<-SHELL 
apt update
apt install -y ngnix
SHELL
`````

#### Comandos Básicos :
 ![Captura de tela_20230117_163551](https://i.imgur.com/EkdsUbi.png) 

 #### ATENÇÃO :

- Configure o .gitignore para ignorar o diretório .vagrant (o . vagrant armazena muitos dados temporários )
- vagrant destroy apaga a máquina, não a box.
- Execute o destroy após alteraração do script de provisionamento.(_Alterações no script só são executadas no momento de criação da máquina_ )
- Foward de portas obrigatoriamente acima de 1024.( _Abaixo disso são portas  reservadas para o SO_)
- Sempre executar **vagrant reload** após toda alteração no Vangratfile.
- Instalação dos módulos vbguest que são extremamente importantes para instalação de drivers de rede, entre outros.