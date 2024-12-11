container=$(buildah from conda-base)

MSPATH=/usr/local/src

buildah run $container -- dnf -y install qt5-qtbase-devel fftw3-devel zeromq-devel
buildah run $container -- conda install -y pyqt
buildah run $container -- pip install git+https://github.com/usnistgov/dastardcommander.git#egg=dastardcommander

buildah run --workingdir=$MSPATH $container -- git clone https://github.com/usnistgov/microscope
buildah run --workingdir=$MSPATH/microscope $container -- /bin/qmake-qt5
buildah run --workingdir=$MSPATH/microscope $container -- make
buildah run --workingdir=$MSPATH/microscope $container -- install -b microscope /usr/local/bin

buildah unmount $container
buildah commit $container dcom:latest
