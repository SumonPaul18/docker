#
## Working With Docker Hub
#
Build a Docker Image

docker build -t sumonpaul/myhttpd .

docker images

docker login

docker push sumonpaul/myhttpd

docker images

docker rmi sumonpaul/myhttpd:latest
