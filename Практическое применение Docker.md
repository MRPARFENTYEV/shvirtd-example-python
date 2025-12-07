# Домашнее задание к занятию «5. Практическое применение Docker»

**ФИО:** Парфентьев В.М. 
## Задача 0

```
docker compose version                                                                                                                          
Docker Compose version 2.39.4

```

## Задача 1
моя ветка 1-devops-newfeature
https://github.com/MRPARFENTYEV/shvirtd-example-python/tree/1-devops-newfeature
```
├── backup
│   ├── dump_20251203_013830.sql
│   ├── dump_20251203_014209.sql
│   ├── dump_20251203_014526.sql
│   ├── dump_20251203_014753.sql
│   ├── dump_20251203_014902.sql
│   ├── dump_20251203_014928.sql
│   ├── dump_20251203_015107.sql
│   ├── dump_20251203_015144.sql
│   ├── dump_20251203_015335.sql
│   ├── dump_20251203_015502.sql
│   ├── dump_20251203_015626.sql
│   ├── dump_20251203_015657.sql
│   ├── dump_20251203_020202.sql
│   ├── dumps20251203_011215.sql
│   ├── dumps20251203_011341.sql
│   ├── dumps20251203_011554.sql
│   ├── dumps20251203_011628.sql
│   ├── dumps20251203_011716.sql
│   ├── dumps20251203_012547.sql
│   ├── dumps20251203_013210.sql
│   ├── dumps20251203_013446.sql
│   └── dumps20251203_013702.sql
├── backup.sh
├── bash-script
├── compose2.yaml
├── compose.yaml
├── crontab.sh
├── Dockerfile.python # <------------- Создайте файл...
├── haproxy
│   ├── haproxy.cfg
│   └── reverse
│       └── haproxy.cfg
├── LICENSE
├── main.py
├── nginx
│   ├── ingress
│   │   ├── default.conf
│   │   └── nginx.conf
│   └── nginx.conf
├── proxy.yaml
├── README.md
├── requirements.txt
├── schema.pdf
└── task6.sh
```
## Задача 3
compose.yaml - в следствие необходимости назван compose2 yaml
```
include:  
  - proxy.yaml  
  
volumes:  
  mysql_data:  
  
services:  
  mysql:  
    image: mysql:8.0  
    restart: always  
    environment:  
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}  
      - MYSQL_ROOT_HOST="%"  
      - MYSQL_DATABASE=${MYSQL_DATABASE}  
      - MYSQL_USER=${MYSQL_USER}  
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}  
    volumes:  
      - mysql_data:/var/lib/mysql  
    ports:  
      - "3307:3306"  # можно оставить для отладки или убрать  
    networks:  
      backend:  
        ipv4_address: 172.20.0.10  
  
  web:  
    build:  
      context: .  
      dockerfile: Dockerfile.python  
    restart: always  
    environment:  
      - DB_HOST=mysql  
      - DB_USER=${MYSQL_USER}  
      - DB_PASSWORD=${MYSQL_PASSWORD}  
      - DB_NAME=${MYSQL_DATABASE}  
    depends_on:  
      - mysql  # без condition, будет использовать встроенный healthcheck MySQL  
    expose:  
      - "5000"  
    networks:  
      backend:  
        ipv4_address: 172.20.0.5  
  
networks:  
  backend:  
    driver: bridge  
    ipam:  
      config:  
        - subnet: 172.20.0.0/24
```

<img width="1280" height="166" alt="image" src="https://github.com/user-attachments/assets/a51e1e29-d237-441f-a2c9-940eba6baa75" />
Подключитесь к БД mysql с помощью команды ```docker exec -ti <имя_контейнера> mysql -uroot -p<пароль root-пользователя>\```
![[Pasted image 20251207151228.png]]
## Задача 4
Напишите bash-скрипт
```
#!/bin/bash

sudo mkdir -p /opt

cd /opt

sudo rm -rf shvirtd-example-python

sudo git clone -b 1-devops-newfeature https://github.com/MRPARFENTYEV/shvirtd-example-python.git

cd shvirtd-example-python

sudo chmod +x *.sh

docker compose -f compose2.yaml up -d

docker compose -f compose2.yaml ps
```

Зайдите на сайт проверки http подключений, например(или аналогичный): ```https://check-host.net/check-http``` и запустите проверку вашего сервиса 
![[Pasted image 20251207151503.png]]

## Задача 5 

```
#!/bin/bash

set -a
source ./.env
set +a
mkdir -p backup

docker run \
    --rm \
    --network shvirtd-example-python_backend \
    -v "$(pwd)"/backup:/backup \
    --entrypoint mysqldump \
    mysql:8 \
    --no-tablespaces \
    -h mysql \
    -P 3306 \
    -u"${MYSQL_USER}" \
    -p"${MYSQL_PASSWORD}" \
    "${MYSQL_DATABASE}" \
    > "backup/dump_$(date +%Y%m%d_%H%M%S).sql"
```

![[Pasted image 20251207151713.png]]
## Задача 6
###Прошу обратить внимание что она выполнена на Manjaro(arch) linux

В Arch/Manjaro версия `dive`, поставляемая через `pacman`, не поддерживает источник `docker-archive`, поэтому tar-файлы от `docker save` она не открывает и всегда пытается обращаться к docker-engine. Это известное ограничение Arch-сборки и не связано с корректностью выполнения задания. Бинарный файл `/bin/terraform` успешно извлечён, задание выполнено.




терраформа на убунте
![[Pasted image 20251207151810.png]]

на манжаре

```
  
docker pull hashicorp/terraform:latest  
  
# 2. Устанавливаем dive  
sudo pacman -S dive                      
  
# 3.  /bin/terraform  
dive hashicorp/terraform:latest  
  
# 4. через docker cp  
docker run -d --name tf-temp hashicorp/terraform:latest sleep 3600  
docker cp tf-temp:/bin/terraform ~/terraform_from_image  
docker rm -f tf-temp  
chmod +x ~/terraform_from_image  
~/terraform_from_image version
```

![[Pasted image 20251207152131.png]]![[Pasted image 20251207152144.png]]


Замечания! Не в обиду, просто трудности с которыми я столкнулся. Претензий не имею.

Мне было сказано убрать healthcheck потому что в mysql уже есть встроенный -  Это все ломает. 
Однако я убрал, мы добились того чтобы приложение надо было перезапускать потому что запросы к бд идут раньше чем созданы таблицы. 
файл compose оставлен только из-за этого пункта. Задание выполнено в Compose2.
Считаю что на вопрос как связать контейнеры не было дано ответа. - был формальный ответ, но не отвечающий на вопрос. 




