container=$(buildah from bluesky)

container_package_dir=/usr/local/src
local_package_dir=$HOME/work/nsls-ii-sst

# buildah run $container -- dnf install -y qt5-qtbase-devel
buildah run $container -- conda install -y numpy pyzmq h5py pyqt
buildah run $container -- conda install -yc paulscherrerinstitute pcaspy
buildah run $container -- pip install git+https://github.com/usnistgov/mass.git#egg=mass
buildah copy $container $local_package_dir/tes_scan_server $container_package_dir/tes_scan_server

buildah run --workingdir=$container_package_dir/tes_scan_server $container -- pip3 install .

buildah commit $container tes-server:latest

# buildah rm $container
