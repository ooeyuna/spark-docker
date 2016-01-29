FROM isuper/java-oracle:jdk_8
MAINTAINER Rika Sanai <chensiyi@bao.tv> 

ENV LANG C.UTF-8

## install spark

RUN mkdir -p /data \
    && cd /data \
    && curl -o spark-1.5.0-bin-hadoop2.6.tgz -SL http://d3kbcqa49mib13.cloudfront.net/spark-1.5.0-bin-hadoop2.6.tgz \
    && tar -xzf spark-1.5.0-bin-hadoop2.6.tgz && rm spark-1.5.0-bin-hadoop2.6.tgz \
    && ln -s spark-1.5.0-bin-hadoop2.6 spark

## install python

ENV PYTHON_VERSION 3.4.0
ENV PYTHON_PIP_VERSION 7.1.2

RUN apt-get update \
    && apt-get install -y python3-pip

RUN cd /usr/bin \
	&& ln -s easy_install-3.4 easy_install \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config

## permission

RUN useradd -ms /bin/bash spark \
     && chown -R spark /data

# spark env
ENV SPARK_HOME /data/spark
ENV PYTHONHASHSEED 0
ENV PYSPARK_PYTHON /usr/bin/python3

ADD conf/spark-defaults.conf /data/spark/conf/spark-defaults.conf
ADD conf/spark-env.sh /data/spark/conf/spark-env.sh

EXPOSE 7077 8080

WORKDIR /data/spark

