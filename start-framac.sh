#!/bin/sh
# Ubuntu Xfce webtop
# Connect to http://localhost:3000/

REPO=fredblgr/
IMAGE=docker-webtop-framac
TAG=2025
URL=localhost
PORT=3000
SPORT=3001

debug=0
while [ $# -gt 0 ]
do
	case $1 in
	"-debug" )
		debug=1
	;;
	* )
		echo "# Unrecognized option: $1"
		echo "# Known options are: -debug"
		exit 1
	esac
	shift
done

# Make sure we have the latest version of the image
docker pull ${REPO}${IMAGE}:${TAG} # > /dev/null 2>&1

if [ $debug -gt 0 ]
then
	docker run --rm --tty --interactive \
		--publish ${PORT}:${PORT} \
		--publish ${SPORT}:${SPORT} \
		--volume ${PWD}/config:/config:rw \
		--name ${IMAGE} \
		--entrypoint=bash \
		${REPO}${IMAGE}:${TAG}
else
	docker run --rm --detach \
		--publish ${PORT}:${PORT} \
		--publish ${SPORT}:${SPORT} \
		--volume ${PWD}/config:/config:rw \
		--name ${IMAGE} \
		${REPO}${IMAGE}:${TAG}

	echo "Waiting for container to start..."
	sleep 10
	echo "... done!"
	
	if [ `uname` == "Darwin" ]
	then
		# on MacOS, use open
		open -a firefox http://${URL}:${PORT}
	else
		# elsewhere, try xdg-open
		# and just write what to do if it fails
		xdg-open http://${URL}:${PORT} \
		|| echo "Point your web browser at http://${URL}:${PORT}"
	fi
fi
