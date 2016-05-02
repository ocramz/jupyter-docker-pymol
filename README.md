# jupyter-docker-pymol

Travis CI: [![Build Status](https://travis-ci.org/ocramz/jupyter-docker-pymol.svg?branch=master)](https://travis-ci.org/ocramz/jupyter-docker-pymol)

Container-based installation of `pymol`, with interaction through the browser via Jupyter notebook (based on `jupyter/scipy-notebook`).

The installation contains also `numpy`, `scipy` and `matplotlib` among other things, so it can be alse used for a variety of scientific Python work.


## Instructions


* Retrieve image from Docker hub :

    docker pull ocramz/jupyter-docker-pymol

* Run image :
  
    docker run -d -p 8888:8888 ocramz/jupyter-docker-pymol

* Point your browser to the IP of the Docker machine at port 8888, e.g.

    192.168.0.3:8888

* Within Jupyter, start a Python 3 document

* Set up a connection to PyMol:

    from ipymol import viewer as pm
    pm.start()







## Requirements

* Docker

* `docker-machine` running in the current shell; calling `docker-machine`



## Caveat

At present, this setup is intended for local use only (i.e. the Docker image, along with all the computational payload i.e. PyMol and the Python interpreter, is running on the same host that runs the browser). 

There is *NO* authentication to the notebooks and the Jupyter user is `root`.





## Credits

Carlos Hernandez (ipymol) , https://github.com/cxhernandez/ipymol