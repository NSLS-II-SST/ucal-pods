#! /usr/bin/bash
set -e
set -o xtrace

version="0.0.1"

container=$(buildah from nbs)

buildah run $container -- pip3 install git+https://github.com/NSLS-II-SST/sst_base.git@master
buildah run $container -- pip3 install git+https://github.com/NSLS-II-SST/ucal.git@master
buildah run $container -- pip3 install git+https://github.com/NSLS-II-SST/ucal_sim.git@master

buildah unmount $container

buildah commit $container sst:latest
buildah commit $container sst:$version

buildah rm $container
