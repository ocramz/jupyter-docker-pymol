#################################################################
# Dockerfile
#
# Version:          0.1
# Software:         Jupyter-Docker-PyMol (BioDocker edition)
# Software Version: 0.1
# Description:      a portable way of interacting with PyMol via Jupyter notebook
# Website:          github.com/ocramz/jupyter-docker-pymol
# Tags:             Visualization
# Provides:         pymol 1.8.2|jupyter
# Base Image:       biodckr/biodocker:latest
# Build Cmd:        
# Pull Cmd:         
# Run Cmd:          
#################################################################
# FROM jupyter/notebook
FROM biodckr/biodocker:latest

# # https://github.com/jupyter/notebook

MAINTAINER Marco Zocca, zocca.marco gmail 


# # # environment variables
ENV PYMOL_VERSION_G 1.8
ENV PYMOL_VERSION 1.8.2.0

ENV TINI_VER v0.9.0
ENV TINI_SHA faafbfb5b079303691a939a747d7f60591f2143164093727e870b289a44d9872
ENV MINICONDA_VER_G 3
ENV MINICONDA_VER 3.19.0
ENV MINICONDA_VER_BUMP 3.19.1
ENV MINICONDA_SHA 9ea57c0fdf481acf89d816184f969b04bc44dea27b258c4e86b1e3a25ff26aa0
ENV NOTEBOOK_VER 4.2
ENV JUPYTERHUB_VER 0.5

ENV USER biodocker

ENV IPYNBS_DIR /home/${USER}/notebooks/iPyMol
ENV DL_DIR /home/dl

ENV CONDA_DIR /opt/conda
ENV PATH ${CONDA_DIR}/bin:${PATH}
ENV SHELL /bin/bash
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

USER root

RUN mkdir -p ${CONDA_DIR} && \
    chown ${USER} ${CONDA_DIR}

# # Create user with UID=1000 and in the 'users' group
# RUN useradd -m -s /bin/bash -N -u $NB_UID ${USER} && \
#     mkdir -p /opt/conda && \
#     chown ${USER} /opt/conda



# # useful directories
RUN mkdir -p ${IPYNBS_DIR} && \
    mkdir -p ${DL_DIR}

# # add example notebook
ADD ipymol/ ${IPYNBS_DIR}



# # # update APT index and install some build tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo \
    make \
    build-essential\
    git \
    vim \
    jed \
    emacs \
    python3 \
    python3-dev \
    python3-setuptools \
    python3-zmq \
    python-pip \
    python-dev \
    ca-certificates \
    bzip2 \
    unzip \
    libsm6 \
    pandoc \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    pkg-config \
    locales \
    libxrender1 \
    \ # # # PyMol, iPyMol dependencies
    build-essential \
    freeglut3 \
    freeglut3-dev \
    libpng3 libpng12-dev \
    libpng-dev \
    libfreetype6 \
    libfreetype6-dev \
    pmw \
    glew-utils \
    libglew-dev \
    libxml2-dev \
    python3-scipy \
    python3-nose \
    libtiff4-dev \
    libjpeg8-dev \
    zlib1g-dev \
    liblcms2-dev \
    libwebp-dev \
    tcl8.5-dev \
    tk8.5-dev \
    python-tk    && \
    \
    apt-get clean && \
    apt-get purge && \
    \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# # # use bash rather than sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    dpkg-reconfigure locales



# # # Install Tini (Jupyter dep.)
RUN wget --quiet https://github.com/krallin/tini/releases/download/${TINI_VER}/tini && \
    echo "${TINI_SHA} *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini



USER ${USER}


# Setup `biodocker` home directory
RUN mkdir /home/${USER}/work     && \
    mkdir /home/${USER}/.jupyter && \
    mkdir /home/${USER}/.local   && \
    echo "cacert=/etc/ssl/certs/ca-certificates.crt" > /home/${USER}/.curlrc




# Install conda as `biodocker`
RUN cd /tmp && \
    mkdir -p ${CONDA_DIR} && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh && \
    echo "${MINICONDA_SHA} *Miniconda${MINICONDA_VER_G}-${MINICONDA_VER}-Linux-x86_64.sh" | sha256sum -c - && \
    /bin/bash Miniconda${MINICONDA_VER_G}-${MINICONDA_VER}-Linux-x86_64.sh -f -b -p ${CONDA_DIR} && \
    rm Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh && \
    ${CONDA_DIR}/bin/conda install --quiet --yes conda==${MINICONDA_VER_BUMP} && \
    ${CONDA_DIR}/bin/conda config --system --add channels conda-forge && \
    conda clean -tipsy


# Install Jupyter notebook as `biodocker`
RUN conda install --quiet --yes \
    "notebook=${NOTEBOOK_VER}*" \
    terminado \
    && conda clean -tipsy



# Install JupyterHub to get the jupyterhub-singleuser startup script
RUN pip install "jupyterhub==${JUPYTERHUB_VER}"






# # # # PyMol
WORKDIR ${DL_DIR}

RUN wget --no-verbose https://sourceforge.net/projects/pymol/files/pymol/${PYMOL_VERSION_G}/pymol-v${PYMOL_VERSION}.tar.bz2 && \
    tar jxf pymol-v${PYMOL_VERSION}.tar.bz2 && \
    rm pymol-v*

WORKDIR pymol

RUN python3 setup.py build install

# RUN which pymol


# # # # iPyMol + dependencies
# TODO: FIXATE VERSION
RUN pip3 install git+https://github.com/ocramz/ipymol.git@python3


## check installation
RUN pip list







# # Configure container startup
# EXPOSE 8888
# # WORKDIR /tmp
# ENTRYPOINT ["tini", "--"]
# # CMD ["jupyter", "kernelgateway", "--KernelGatewayApp.ip=0.0.0.0"]



USER root

# Add local files as late as possible to avoid cache busting
# Start notebook server
COPY jupyter-minimal-notebook/start-notebook.sh /usr/local/bin/
# Start single-user notebook server for use with JupyterHub
COPY jupyter-minimal-notebook/start-singleuser.sh /usr/local/bin/
COPY jupyter-minimal-notebook/jupyter_notebook_config.py /home/${USER}/.jupyter/

RUN chown -R ${USER}:users /home/${USER}/.jupyter




# Switch back to user to avoid accidental container runs as root
USER ${USER}



# Configure container
EXPOSE 8888

# # working directory
WORKDIR /home/${USER}

VOLUME /home/${USER}


ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "notebook", "--no-browser"]


# docker run --rm -it -p 8888:8888 ocramz/jupyter-docker-pymol
