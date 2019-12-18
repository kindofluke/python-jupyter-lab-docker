FROM python:3.6

WORKDIR /usr/src/app


RUN curl -sL https://deb.nodesource.com/setup_10.x | bash

RUN apt-get update 

RUN apt-get install -y nodejs gdal-bin libspatialindex-dev python3-rtree

#============================================
# Google Chrome
#============================================
# Curtosy of https://github.com/SeleniumHQ/docker-selenium/blob/master/NodeChrome/Dockerfile
# can specify versions by CHROME_VERSION;
#  e.g. google-chrome-stable=53.0.2785.101-1
#       google-chrome-beta=53.0.2785.92-1
#       google-chrome-unstable=54.0.2840.14-1
#       latest (equivalent to google-chrome-stable)
#       google-chrome-beta  (pull latest beta)
#============================================
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    ${CHROME_VERSION:-google-chrome-stable} \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*



#============================================
# Chrome webdriver
#============================================
# can specify versions by CHROME_DRIVER_VERSION
# Latest released version will be used by default
#============================================
ARG CHROME_DRIVER_VERSION="latest"
RUN CD_VERSION=$(if [ ${CHROME_DRIVER_VERSION:-latest} = "latest" ]; then echo $(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE); else echo $CHROME_DRIVER_VERSION; fi) \
  && echo "Using chromedriver version: "$CD_VERSION \
  && wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CD_VERSION/chromedriver_linux64.zip \
  && rm -rf /opt/selenium/chromedriver \
  && unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && rm /tmp/chromedriver_linux64.zip \
  && mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CD_VERSION \
  && chmod 755 /opt/selenium/chromedriver-$CD_VERSION \
&&  ln -fs /opt/selenium/chromedriver-$CD_VERSION /usr/bin/chromedriver




COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN jupyter labextension install @ijmbarr/jupyterlab_spellchecker
RUN jupyter nbconvert --generate-config
COPY jupyter_nbconvert_config.py /root/.jupyter/jupyter_nbconvert_config.py
RUN pip install jupytext nb_black
RUN jupyter lab build
RUN pip install --user https://github.com/rogerbinns/apsw/releases/download/3.28.0-r1/apsw-3.28.0-r1.zip \
--global-option=fetch --global-option=--version --global-option=3.28.0 --global-option=--all \
--global-option=build --global-option=--enable-all-extensions



ENV GDAL_DATA=/usr/local/lib/python3.6/site-packages/fiona/gdal_data
ENV PROJ_DATA=/usr/local/lib/python3.6/site-packages/fiona/proj_data
