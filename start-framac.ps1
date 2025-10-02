# Has to be authorized using:
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
#
$REPO="fredblgr/"
$IMAGE="docker-webtop-framac"
$TAG="2025"
$URL="localhost"
$PORT="3000"
$SPORT="3001"
docker pull ${REPO}${IMAGE}:${TAG}
docker run --rm -d -p ${PORT}:${PORT} -v ${PWD}/config:/config:rw --name ${IMAGE}-run ${REPO}${IMAGE}:${TAG}
Start-Sleep -s 5
Start http://${URL}:${PORT}
