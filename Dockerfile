# 1) choose base container
# generally use the most recent tag

# base notebook, contains Jupyter and relevant tools
# See https://github.com/ucsd-ets/datahub-docker-stack/wiki/Stable-Tag 
# for a list of the most current containers we maintain
ARG BASE_CONTAINER=ghcr.io/ucsd-ets/rstudio-notebook:2025.2-stable

FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

# 2) change to root to install packages
# USER root

# RUN apt-get -y install htop

# 3) install packages using notebook user
# USER jovyan

RUN conda install -y scikit-learn scanpy pandas xgboost

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libhdf5-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libglpk-dev \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    cmake \
    && apt-get clean

# Install required R packages
RUN R -e "install.packages(c( \
    'Seurat', \
    'pheatmap', \
    'viridis', \
    'ComplexHeatmap', \
    'remotes' \
))"

# Install Bioconductor packages
RUN R -e "if (!requireNamespace('BiocManager', quietly=TRUE)) install.packages('BiocManager'); \
          BiocManager::install(c('edgeR', 'SeuratDisk', 'monocle3', 'AUCell', 'RcisTarget', 'GENIE3'))"

# Install SCENIC
RUN R -e "remotes::install_github('aertslab/SCENIC')"

# RUN pip install --no-cache-dir networkx scipy

# USER root
# RUN mamba install -c conda-forge r-survey -y && \
#     fix-permissions $CONDA_DIR && \
#     fix-permissions /home/$NB_USER && \
#     mamba clean -a -y

# USER jovyan

# Override command to disable running jupyter notebook at launch
# CMD ["/bin/bash"]
