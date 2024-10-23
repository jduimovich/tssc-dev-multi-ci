
# get local test repos to patch
source setup-local-dev-repos.sh

# The dev repos should can be enabled for Jenkins, gitlab and github actions
# to enable gitlab, add a remote in the github repo to match the repo in gitlab

OPTIONAL_REPO_UPDATE=$TEST_GITOPS_REPO

#Jenkins 

echo "Update Jenkins file in $BUILD and $GITOPS" 

cp Jenkinsfile $BUILD/Jenkinsfile   
cp Jenkinsfile.gitops $GITOPS/Jenkinsfile
# ENV with params

mkdir -p $BUILD/rhtap
SETUP_ENV=$BUILD/rhtap/env.sh
cp rhtap/env.template.sh $SETUP_ENV
sed -i "s!\${{ values.image }}!quay.io/\${MY_QUAY_USER:-jduimovich0}/bootstrap!g" $SETUP_ENV
sed -i "s!\${{ values.dockerfile }}!Dockerfile!g" $SETUP_ENV
sed -i "s!\${{ values.buildContext }}!.!g" $SETUP_ENV
sed -i "s!\${{ values.repoURL }}!$OPTIONAL_REPO_UPDATE!g" $SETUP_ENV

# Set MY_REKOR_HOST and MY_TUF_MIRROR to 'none' if these services are not available
sed -i 's!export REKOR_HOST=.*$!export REKOR_HOST="\${MY_REKOR_HOST:-http://rekor-server.rhtap.svc}"!' $SETUP_ENV
sed -i 's!export TUF_MIRROR=.*$!export TUF_MIRROR="\${MY_TUF_MIRROR:-http://tuf.rhtap.svc}"!' $SETUP_ENV


# Gitlab CI  
echo "Update .gitlab-ci.yml file in $BUILD and $GITOPS" 
cp .gitlab-ci.yml $BUILD/.gitlab-ci.yml
cp .gitlab-ci.gitops.yml $GITOPS/.gitlab-ci.yml

# Github Actions  
echo "Update .github workflows in $BUILD and $GITOPS"  
echo "WARNING No  .github workflows in $GITOPS"  
cp -r .github $BUILD  
# add  $GITOPS/.github/workflows/* when workflow exists
for wf in $BUILD/.github/workflows/*
do
    echo "Fix WF $wf"
    sed -i 's/workflow_dispatch/push, workflow_dispatch/g'  $wf
    echo "-"
done

function updateRepos() {
    REPO=$1  
    echo 
    echo "Updating $REPO" 
    pushd $REPO
    git add .
    git commit -m "Testing in CI"
    git push 
    echo "Testing for gitlab remote, push if success $REPO" 
    # echo need a remote named gitlab that is based on this repo
    git remote | grep "gitlab"
    ERR=$? 
    if [ $ERR == 0 ]; then
        git push gitlab main 
    else 
        echo "no remote in $REPO for gitlab"
    fi 
    popd
}
updateRepos $BUILD
updateRepos $GITOPS
 
 

