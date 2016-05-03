# jupyter-docker-pymol

Travis CI: [![Build Status](https://travis-ci.org/ocramz/jupyter-docker-pymol.svg?branch=master)](https://travis-ci.org/ocramz/jupyter-docker-pymol)

Container-based installation of `PyMol`, with interaction through the browser via `ipymol` and Jupyter notebook (based on `jupyter/notebook`). A convenient and portable way to draw pretty pictures of chemical molecules, and much more.

The installation also contains `numpy` ans `scipy` among other things, so it can be used for a variety of scientific Python tasks.



![](https://github.com/ocramz/jupyter-docker-pymol/blob/master/fig/png0.png)



## Instructions (setup)


First, note down the IP address of the currently running Docker machine (which is called `dev` in this example) with 

    docker-machine ip dev


1. Retrieve the image from Docker hub :

        docker pull ocramz/jupyter-docker-pymol

   You can retrieve the list of currently available Docker images with the command `docker images`



2. Run image :
  
        docker run -d -p 8888:8888 ocramz/jupyter-docker-pymol

3. Point your browser to the IP address of the Docker machine found initially, and port 8888, i.e.

        <docker-machine-ip>:8888

   where `<docker-machine-ip>` usually starts with `192.168.` 


## Instructions (use)


1. Within Jupyter, start a Python 3 document (or just start with the [example notebook](https://github.com/ocramz/jupyter-docker-pymol/blob/master/ipymol/iPyMol_example.ipynb))


2. Declare inline figure rendering within Jupyter notebooks and setup the connection to PyMol:

        %pylab inline 

        from ipymol import viewer as pm
        pm.start()


3. Run your PyMol tasks, e.g. :

        pm.do('fetch 3odu; as cartoon; bg white;')
        f1 = pm.show()







## Requirements

* Docker (Windows and OSX users should install the Docker Toolbox : https://docs.docker.com/toolbox/overview/)

* `docker-machine` running in the current shell (setup guide : https://docs.docker.com/machine/get-started/)



## Notes

This project uses PyMol 1.8.2.0 and Python 3


## Caveat

At present, this setup is intended for local use only (i.e. the Docker image, along with all the computational payload i.e. PyMol and the Python interpreter, is running on the same host that runs the browser). 

There is *NO* authentication to the notebooks and the Jupyter user is `root`.





## Credits

the PyMol project contributors , pymol.org

the Jupyter and iPython project contributors , jupyter.org

Carlos Hernandez (ipymol) , https://github.com/cxhernandez/ipymol