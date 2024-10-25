
docker buildx build . -f Dockerfile.gitlab -t  quay.io/$MY_QUAY_USER/dance-bootstrap-app:rhtap-runner-gitlab
docker push  quay.io/$MY_QUAY_USER/dance-bootstrap-app:rhtap-runner-gitlab