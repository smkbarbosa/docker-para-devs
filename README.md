# Docker Para Desenvolvedores e SysAdmin
_Local: UFT (Reitoria)_

_Instrutor: Aislan Max (aislan[a]uft.edu.br)_

Prática 1)
* Instanciar mysql
```
docker container run -d --name db -e MYSQL_ROOT_PASSWORD=dbdbdb -e MYSQL_DATABASE=wordpress --restart=allways mysql:5.7
```
* Instanciar wordpress e ligar no 
```
docker container run -d -P --link db:db --name web1 wordpress
```
* Instanciar drupal e ligar no mysql
```
docker container run -d -P --link db:db --name web2 drupal
```
* Instanciar o phpmyadmin
```
docker container run -d -p 8010:80 -e MYSQL_ROOT_PASSWORD=dbdbdb --name phpmyadmin --link db:db  phpmyadmin/phpmyadmin

```


### DockerFile

* FROM
* LABEL
* ENV
* CMD
* WORKDIR
* COPY
* ADD
* VOLUME
* RUN
* EXPOSE
* USER
* ENTRYPOINT

### Construindo um dockerfile

```
docker build -t <name>:1 .
```


### Utilizando redes
O Docker permite que o usuário crie redes, permitindo que os containers se enxerguem sem a necessidade de passar o parâmetro link na linha de comando
```
docker network create -d bridge <nome da rede>
```

Exemplo de uso
```
docker container run -d --name db --net <nome da rede> mysql
docker container run -d -P --name web --net <nome da rede> wordpress
```


### Preparando para apontar as falhas
Se precisar ter um limite de reinicializações em caso de falha:

```
docker run -d --name restart-3 --restart=on-failure:3 php:7-apache
```
Ou

```
docker run -d --name restart-always --restart=restart:always php:7-apache
```

### Logs
Para visualizar os logs de um container

```
docker container logs -f <container>
```

Existem alguns drives de log que podem ser utilizados no docker:
- none
- json-file
- syslog
- journald
- gelf
- fluentd
- awslogs
- awslogs
- splunk
- etwlogs
- gcplogs

Criar link simbolico do arquivo de log para outra saida

```exemplo
ln -sf /dev/stdout /var/log/apache2/access.log
ln -sf /dev/stderr /var/log/apache2/error.log
```

### Problemas Comuns
Problemas comuns que ocorrem com os logs
- espaço em disco
- travamento de instância
- consumo de memória

Para resolver, podemos utilizar o logrotate:
- logrotate --> /etc/logrotate.d/docker

```
/var/lib/docker/containers/*/*.log {
    daily
    rotate 3   ## --> qtd de dias de retenção do log
    compress
    delaycompress
    missingok
    copytruncate
}

docs.docker.com/config/containers/logging/configure
```

### EntryPoint Exemplo

```entrypoint
#!/bin/bash
set -e
set - start.sh "$@"
exec "$@"
```

```start.sh
#!/bin/bash
set -e
exec /usr/sbin/httpd -DFOREGROUND "$@"
```

###### Nota
PS: Uma imagem pronta para produção deve ter:
- expose
- workdir
- entrypoint
- volumes
- logs

###### Remover todas as imagens:

```
docker rmi $(docker images -qa) --force
```

###### Remover os containers
```
docker container stop $(docker container ls -q)
docker container rm $(docker container ls -qa)
```

### Docker Compose

```
version: '3'
services:
  web:
    build: .
    ports:
    - "5000:5000"
    volumes:
    - .:/code
    - logvolume01:/var/log
    links:
    - redis
  redis:
    image: redis
volumes:
  logvolume01: {}
```

### Boas práticas
- um app por container
- instale apenas o que você precisa
- revise quem tem acesso aos hosts do Docker
- Use a versão mais recente
- Evite rodar container como root


### Criando imagens com Alpine

O Alpine é uma distribuição criada exclusivamente para o Docker

###### Parâmetros
- add: adiciona pacotes
- del: remove pacotes
- fix: tenta reparar ou reinstalar um pacote
- update: atualiza a lista de pacotes
- info: imprime a lista de pacotes instalados ou disponíveis
- search: pesquisa pacotes
- upgrade: upgrade dos pacotes instalados
- cache: operações de manutenção no cache local de repositório
- version: comparar versões de pacotes instalados e disponíveis

Para checar os arquivos dentro de uma imagem:
```
docker container run --rm -it <container> <comando>
```

### Registry e DockerHub

##### DockerHub
Para criar a tag da imagem:
```
docker image tag <imagem> <usuario>/<imagem>
```

Para enviar para o dockerhub:
```
docker login

docker image push <usuario>/<imagem>
```

Se precisar manter uma cópia de algum repositório, para evitar possíveis atualizações pelos mantenedores.
Nota: essa imagem é alguma que você já tenha feito o download
```
docker image tag <imagem>:<versao> <usuario>:<imagem>
docker image push <usuario>/<imagem>
```

##### Registry

O registry2 é o sistema de repositório privado disponibilizado pelo Docker

Instalar o registry:
```
docker container run -d -p 5000:5000 --name registry registry:2
```

Baixar a imagem do docker hub
```
docker pull alpine
```

Alterando a tag para enviar para o registry
```
docker image tag alpine localhost:5000/alpine 
```

Enviando 
```
docker push localhost:5000/alpine 
```

#### Criando um bundle de certificado

```
mv <certificado>.crt <certificado>.cer
cat <certificado>.cer interdiate.pem > <certificado>.crt
```

### Docker Machine

  O Docker machine é um app para gerenciar imagens em servidores remotos

  Instalação: https://docs.docker.com/machine/install-machine/
  
  Dependências para testar em desenvolvimento (Linux): 
  - Virtualbox

  ```
  docker-machine create -d virtualbox default
  ```


  ### Swarm
  Permite a criação de clusters docker

  - Utiliza rede do tipo **overlay**
  - Nodes: manager / worker
  - service:
  - stack:
  - node:
  - secret: gerencia dados sensíveis

 ###### Criando um nó docker
  ```
docker-machine create -d virtualbox manager
docker-machine create -d virtualbox node1
docker-machine create -d virtualbox node2
  ```

cria env para acessar manager
```
docker-machine env manager
eval $(docker-machine env manager) ## Acessa o env do docker
```

iniciar o swarm
```
docker swarm init --advertise-addr=<ip do servidor>
```

Será gerado um token para adicionar as maquinas clientes deste manager.

vamos iniciar os outros nodes

```
docker-machine env node01
eval $(docker-machine env node01)
docker swarm join --token <token> <ip>
```
```
docker-machine env node02
eval $(docker-machine env node02)
docker swarm join --token <token> <ip>
```

#### docker stack e docker service



se for usar linha de comando
```
docker service 
```

Se for usar docker-compose.yml
```
docker stack deploy --compose-file=<file>
```

- exemplo de paralelismo
```
docker service update --limit-cpu 0.3 --update-parallelism 1 ### Limite de cpu=0.3 | Paralelismo=1
docker service update --limit-cpu 0.3 --update-parallelism 2 ### Limite de cpu=0.3 | Paralelismo=2

```

