echo "test "

IMG=quay.io/$MY_QUAY_USER/dance-bootstrap-app:rhtap-runner-github
docker buildx build . -f Dockerfile.github -t $IMG
sudo rm -rf out 
mkdir -p out
docker run -v $(pwd)/out:/out quay.io/$MY_QUAY_USER/dance-bootstrap-app:rhtap-runner-github bash /work/copy-scripts.sh
tree out 