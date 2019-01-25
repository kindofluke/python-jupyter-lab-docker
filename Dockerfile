FROM python:3.6

WORKDIR /usr/src/app


RUN curl -sL https://deb.nodesource.com/setup_10.x | bash

RUN apt-get update 

RUN apt-get install -y nodejs gdal-bin



COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN jupyter labextension install @ijmbarr/jupyterlab_spellchecker

