FROM python:3.6

WORKDIR /usr/src/app


RUN curl -sL https://deb.nodesource.com/setup_10.x | bash

RUN apt-get update 

RUN apt-get install -y nodejs gdal-bin libspatialindex-dev python3-rtree


COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN jupyter labextension install @ijmbarr/jupyterlab_spellchecker

ENV GDAL_DATA=/usr/local/lib/python3.6/site-packages/fiona/gdal_data
ENV PROJ_DATA=/usr/local/lib/python3.6/site-packages/fiona/proj_data