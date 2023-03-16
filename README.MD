/
![Captura de tela_20230118_111913](https://i.imgur.com/LSO1sWn.png)

### INFRAESTRUTURA COMO CÓDIGO - IaC
--------
#### 1. Vangrant
- Cria e gerencia máquinas virtuais
- Foco em automação
- Para DevOps: Usada para testes de scripts de infraestrutura.
- Evita trabalho manual de instalação de SO.

##### Ciclo de vida 

- Gerencamento de ciclo de vida da máquina :
     - SSH para máquina - vagrant ssh
     - Halt/Shutdown do servidor 
     - Destruir a máquina, apagando discos e metados
     - Suspender/ resumir máquina 
     - Empacotar o estado da máquina e distribuir para o time. 

#####  Vangrantfile : Arquivo de configuração

- Arquivo VangrantFile- Definição da  máquina virtual.
    * Contém  as propriedades físicas da máquina:
           **Cpu, memória, Disco, Foward de portas, tipos de acesso, compartilhamento de disco**.  
  - Arquivo texto de fácil versionamento.
  - Criado no diretório corrente( vagrant init).
  - _Um VagrantFile por diretório_.
  - É possível ter mais de um box por VangrantFile.
  - Para ter mais máquinas virtuais é necessário declará-las no mesmo Vangrantfile. 


##### Vagrant Boxes

- Box: Imagem base de um sistema operacional (debian, centos..).
- Uma nova máquina é clonada a partir do primeiro download.
- A distribuição das máquinas é feita através de um box file.
- Múltiplas máquinas podem utilizar a mesma box.


##### Funcionalidades 

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

##### Comandos Básicos :
 ![Captura de tela_20230117_163551](https://i.imgur.com/EkdsUbi.png) 

 ###### ATENÇÃO :

- Configure o .gitignore para ignorar o diretório .vagrant (o . vagrant armazena muitos dados temporários )
- vagrant destroy apaga a máquina, não a box.
- Execute o destroy após alteraração do script de provisionamento.(_Alterações no script só são executadas no momento de criação da máquina_ )
- Foward de portas obrigatoriamente acima de 1024.( _Abaixo disso são portas  reservadas para o SO_)
- Sempre executar **vagrant reload** após toda alteração no Vangratfile.
- Instalação dos módulos vbguest que são extremamente importantes para instalação de drivers de rede, entre outros.   


#### 2. Ansible 

- É uma utilitário open source utilizado para orquestração e gerenciamento de configuração.
- Serve para automatização e padronização de configurações de hosts virtuais( bare metal e máquinas virtuais)
- Arquitetura simples 
- É _idempontente_ pois garante que a mesma configuração seja mantida mesmo que seja executada mais de uma vez.Não repete a mesma tarefa, como por exemplo, a criação do mesmo diretório.
- Pode ser utilizadado para configurar SaaS, PaaS e afins.

**Arquitetura do  Ansible** 

- Existe dois tipos de máquinas :
  1. Control node 
  2.  Managed hosts.
     - Control Machine : Instalação do Ansible
     - Managed Host : Host inventory
     - Host Inventory : É um arquivo de texto (control node) com a lista de hosts/ips que serão gerenciados pelo Ansible.
- Se comunica por SSH 
- Não precisa de instalação de software no Managed host.

![Captura de tela_20230122_191540](https://i.imgur.com/hW66H7x.png) 

- _**Core Modules**_: Executam a grande maioria das atividades de administração do sistema operacional.
- _**Custom Modules**_: Extende a funcionalidade criando componentes personalizados ( Python).
- _**Playbooks**_: Arquivo texto do tipo YAML com sintaxe pré-definida. São executados em conjunto, grupo ou classificação de hosts que, juntos, formam o inventário do Ansible.
     - São utilizados com regularidade para automatização de infraestrutura de TI como SO e plataformas Kubernetes, redes e  sistemas de segurança .
     - Ajuda a programar instalação de aplicações,serviços, nós de servidores dentre outros sem a sobrecarga de ter que criar tudo do zero manualmente.
     -  Podem ser salvos, reutilizados e compartilhados assim como também suas variáveis, condições e tarefas.
 
 - Um _módulo do Ansible_ é um script que pode ser usado dentro do Ansible playbook.
 - As _plays_ são um conjunto ordenado de tarefas a serem executadas em hosts selecionados no arquivo de inventário do Ansible. As tarefas serão executadas conforme a ordem em que estão escritas.   

 **Configurando arquivo de inventário**
    
   - O arquivo de configuração por default fica no diretório  /etc/ansible/hosts no control-node. 



![Captura de tela_20230202_102916](https://i.imgur.com/EfufaZP.png)



**Introdução aos Playbooks**

- Arquivo de configuração em YAML com uma sequência de passos lógicos que serão executados remotamente a partir do Control-node.
- Toda execução do Ansible deve partir de um playbook.
- Quando um arquivo tem 2 ou 3 tasks não tem uma demonstração explícita do problema que se pode vir a ter ao agrupar em um arquivo playbook todas as tarefas que precisam ser realizadas, mas ao aumentar o número de tasks pode se perceber um problema de gerência de um arquivo único.
- As **_Roles_** foram criadas pensando nesse tipo de problema.

**Roles**

- Organiza as plays do seu Ansible, onde cada pasta tem suas funções específicas para facilitar o uso e implementação do que se deseja aplicar naquele role.
- Atividades que não estão dentro do conjunto de tasks.
- Dentro de uma role temos as seguintes pastas:
     
     - tasks/
     - files/
     - templates/
     - handlers/
     - defaults/
     - vars/ 

- Quando uma pasta com um nome x, tem essas subspastas dentro, com todos os arquivos yaml dentro de cada uma delas, temos uma **role**.
- O ansible automaticamente procurará um arquivo _main.yaml_ dentro da pasta tasks para iniciar as tasks.
- Quando uma task faz uma alteração no sistema, pode ser necessário executar uma task ou tasks adicionais. Por exemplo, uma alteração no arquivo de configuração de um serviço pode exigir que ele seja reiniciado para que a configuração alterada entre em vigor.
-  As _**Handlers**_ são  vistas como tasks inativas que só são adicionadas quando chamadas explicitamente usada a instrução _notify_. São tarefas que só serão executadas quando notificadas, sendo executadas assim que todas as tarefas são concluídas. Usadas para iniciar, recarregar, reiniciar e interromper serviços.


Exemplo de playbook :

- **_name_**: Título do playbook que tem por objetivo dizer o que playbook irá fazer.
- **_hosts_**: Especificação sobre quais hosts podem usar esse playbook.
- **_Tasks_**: Usado para iniciar tarefas que serão executadas no servidor destino.
- **_vars_**: Arquivo de variáveis para deixar o código um pouco mais clean.
        
    - _Atenção_ : Não é uma boa prática colocar senhas no arquivo de configuração sendo indicado o uso de cofre de senhas como Vault, dentre outros..

- **_become_**: Controla o escalonamento de privilégios é usado ou não na execução da task( tarefas).        
  
  - O arquivo deve sempre começar com **três hífens** (---) e o elemento de primeiro nível é sempre uma lista que começa com um filtro chamado **hosts**.







```python
---
- name: Configurar servidor de banco de dados 
  hosts: db01

  user: vagrant
  become: yes      
  vars_files:     
    - vars/main.yaml
  vars:
    - dbname: "db01"
    - dbusername: "root"
    - dbpassword: "devopspratica"
  tasks:
    - name: Configurar hosts lab ansible 
      lineinfile: line "{{item}}" path=etc/hosts
      with_items:
        - 192.168.1.2 control-node
        - 192.168.1.3 app01
        - 192.168.1.4 db01
  roles: 
    - configuração-default-so  
    - role: geerlingguy.mysql    
```

 **Uso do ansible-playbook** 
- _ansible-playbook db.yaml --check_
     - Esse comando serve para fazer a implementação das tarefas solicitadas pelo playbook sendo que o uso do _--check_ não as implementa. 
  

 
 ![Captura de tela_20230202_155947](https://i.imgur.com/lsUwyMS.png)  
