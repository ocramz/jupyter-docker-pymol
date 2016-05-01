FROM jupyter/scipy-notebook
MAINTAINER Marco Zocca, zocca.marco gmail 


USER root

# # # environment variables
ENV PYMOL_VERSION 1.8.2.0
ENV PYMS_DIR /home/scripts/PyMol
ENV DATASETS_DIR /home/datasets
ENV IPYNBS_DIR /home/scripts/iPython

# # useful directories
RUN mkdir -p ${PYMS_DIR}
RUN mkdir -p ${DATASETS_DIR}
RUN mkdir -p ${IPYNBS_DIR}

# # scripts and datasets (FIXME: better use VOLUME instead, see Dockerfile docs)

ADD scripts/ ${PYMS_DIR}
ADD datasets/ ${DATASETS_DIR}
ADD ipymol/ ${IPYNBS_DIR}



RUN apt-get update 

# # # bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh



# # PyMol dependencies
RUN apt-get install -y freeglut3 freeglut3-dev libpng3 libpng-dev libfreetype6 libfreetype6-dev pmw python-dev glew-utils libglew-dev libxml2-dev 

# # # fetch and install PyMOl

RUN wget --no-verbose https://sourceforge.net/projects/pymol/files/pymol/1.8/pymol-v${PYMOL_VERSION}.tar.bz2
RUN tar jxf pymol-v${PYMOL_VERSION}.tar.bz2
RUN rm pymol-v*
WORKDIR pymol
RUN python setup.py build install



# # iPyMol deps
RUN pip install numpy ipymol matplotlib



# # # clean temp data
RUN apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*





# docker run -d -p 8888:8888 jupyter/scipy-notebook