container=$(buildah from ubuntu)
buildah run $container -- apt-get -y update
buildah run $container -- apt-get install -y libsodium-dev libzmq3-dev git gcc pkg-config make
#buildah run -e DEBIAN_FRONTEND=noninteractive $container -- apt-get install -y --no-install-recommends tzdata
#buildah run $container -- apt-get install -y software-properties-common
#buildah run $container -- apt-add-repository -y ppa:longsleep/golang-backports
#buildah run $container -- apt-get -y update
buildah run $container -- apt-get -y install golang-go
TMPGOPATH=$(buildah run $container -- go env GOPATH)
buildah config --env GOPATH=$TMPGOPATH --env DASTARD_DEV_PATH=$TMPGOPATH/src/github.com/usnistgov $container 
buildah run $container -- bash -c 'mkdir -p $GOPATH/bin; mkdir -p $DASTARD_DEV_PATH; cd $DASTARD_DEV_PATH; git clone https://github.com/usnistgov/dastard; cd dastard; make build && ./dastard --version; make install'
buildah config --workingdir $TMPGOPATH/bin --cmd ./dastard $container
buildah unmount $container

buildah commit $container dastard:latest

buildah rm $container
