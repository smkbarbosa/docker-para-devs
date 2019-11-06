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