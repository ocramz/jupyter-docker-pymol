FROM jupyter/scipy-notebook
MAINTAINER Marco Zocca, zocca.marco gmail 

USER root
# ENV GRANT_SUDO yes
# USER jovyan

# # # environment variables
ENV PYMOL_VERSION 1.8.2.0
ENV USER jovyan

ENV PYMS_DIR /home/${USER}/scripts/PyMol
ENV DATASETS_DIR /home/${USER}/datasets
ENV IPYNBS_DIR /home/${USER}/scripts/iPython

# # useful directories
RUN mkdir -p ${PYMS_DIR}
RUN mkdir -p ${DATASETS_DIR}
RUN mkdir -p ${IPYNBS_DIR}

# # scripts and datasets (FIXME: better use VOLUME instead, see Dockerfile docs)

ADD scripts/ ${PYMS_DIR}
ADD datasets/ ${DATASETS_DIR}
ADD ipymol/ ${IPYNBS_DIR}


# # # # # # root for administration
USER root

# # # update APT index
RUN apt-get update 

# # # bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh




# # PyMol dependencies
RUN apt-get install -y build-essential freeglut3 freeglut3-dev libpng3 libpng12-dev libpng-dev libfreetype6 libfreetype6-dev pmw python-dev glew-utils libglew-dev libxml2-dev 

RUN conda install -y conda-build

# # # restore non-root jupyter user
USER jovyan

# # # fetch and install PyMol
WORKDIR /home/${USER}
RUN wget --no-verbose https://sourceforge.net/projects/pymol/files/pymol/1.8/pymol-v${PYMOL_VERSION}.tar.bz2
RUN tar jxf pymol-v${PYMOL_VERSION}.tar.bz2
RUN rm pymol-v*
WORKDIR pymol
RUN python setup.py build install



# # iPyMol 
RUN conda skeleton pypi ipymol
RUN conda build ipymol
# RUN pip install ipymol  # # matplotlib and numpy already present in Conda



# # # clean temp data
USER root
RUN sudo apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER jovyan



RUN conda list





ENTRYPOINT tini -- start-notebook.sh

# docker run -d -p 8888:8888 ocramz/jupyter-docker-pymol