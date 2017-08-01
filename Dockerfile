# imagem na qual esse arquivo se baseia
FROM ubuntu:16.04  
# responsável por manter essa imagem
MAINTAINER Lucas Duane Gomes Pimenta <lucas.duane@gmail.com>

# verso do nodes que sera utilizada
ENV NODE_VERSION 6.11.1

# instalacao das dependencias básicas
RUN apt-get update && apt-get install -y -q --no-install-recommends \  
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        python \
        rsync \
        software-properties-common \
        wget \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \  
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

# executa a instalação do NodeJS nesse container
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \  
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# instalação de forma global do PM2 
RUN npm install -g pm2  
# instalado de forma global do yarn
RUN npm install -g yarn

# cria a pasta onde ficara os arquivos da aplicação
RUN mkdir -p /var/www/nodejs-docker-pm2

# copia os arquivos do diretório atual para o diretório
# /var/www/<nome da aplicacação> do container 
COPY . /var/www/nodejs-docker-pm2

# define o diretório de trabalho
WORKDIR /var/www/nodejs-docker-pm2

# instala as dependencias da aplicacão
RUN yarn install

# expõe a porta 4000 deste container
EXPOSE 4000

# executa o comando pm2-dev usando o arquivo de configuração `processes.json`
CMD ["pm2-dev", "processes.json"]