# Docker Container for Jupyter Lab with Important Data Science Libraries

This docker image provides a instance of Jupyter with Lab, notebook and important python packages and plugins for my common data science workflow. 

Note that this does not rely on on the official Jupyter docker images (useful for JupyterHub). Uses Python3.6 and pip to install important packages (defined by requirements.txt). 

Also installs Node to compile important JupyterLab plugins such as spellcheck. 

The goal is to allow this image to be used in docker compose. 

A sample `docker-compose.yml`  would be as follows. It's important to utilize a propoer .dockerignore 

```
version: '3'
services:
  notebook:
    image: python-jupyter-lab  
    command: sh -c "pip install -r /code/requirements.txt; jupyter notebook --ip=0.0.0.0 --no-browser --notebook-dir=/code  --NotebookApp.token='' --allow-root"
    ports:
    - "8888:8888"
    volumes:
    - .:/code
    environment:
        - PGPASSWORD

```




