
# get local test repos to patch
source setup-local-dev-repos.sh

# The dev repos should can be enabled for Jenkins, gitlab and github actions
# to enable gitlab, add a remote in the github export

#Jenkins 

echo "Update Jenkins file in $BUILD and $GITOPS" 

cp Jenkinsfile $BUILD/Jenkinsfile   
cp Jenkinsfile.gitops $GITOPS/Jenkinsfile

# Gitlab CI  
echo "Update .gitlab-ci.yml file in $BUILD and $GITOPS" 
cp .gitlab-ci.yml $BUILD/.gitlab-ci.yml
cp .gitlab-ci.gitops.yml $GITOPS/.gitlab-ci.yml

# Github Actions  
echo "Update .github workflows in $BUILD and $GITOPS"  
echo "WARNING No  .github workflows in $GITOPS"  
cp -r .github $BUILD  


function updateRepos() {
    REPO=$1  
    echo "Updating $REPO" 
    pusd $REPO
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
        echo "no remote to test gitlab"
    fi 
    popd
}
updateRepos $BUILD
updateRepos $GITOPS
 
 

