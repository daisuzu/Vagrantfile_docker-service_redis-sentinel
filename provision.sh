#!/bin/sh

# install docker
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
yum install -y docker-engine
service docker restart
chkconfig docker on

# build image of redis-sentinel
cd /vagrant/redis-sentinel; docker build -t daisuzu/redis-sentinel:3.2 .; cd -

# start redis
docker run --name redis -d -p 6379:6379 redis:3.2
if [ "$ROLE" != "master" ]; then
    docker run --rm --link redis:redis redis:3.2 redis-cli -h redis slaveof 192.168.33.101 6379
fi

if [ "$ROLE" != "master" ]; then
    # join to docker swarm
    /vagrant/swarm-join.sh

    if [ "$ROLE" == "lastnode" ]; then
        # update num of redis-sentinel
        docker service scale redis-sentinel=3
    fi

    exit
fi

# initialize docker swarm
docker swarm init --advertise-addr=192.168.33.101

# create script for join docker swarm
echo '#!/bin/sh' > /vagrant/swarm-join.sh
docker swarm join-token manager | tail -n +2 >> /vagrant/swarm-join.sh
chmod +x /vagrant/swarm-join.sh

# start redis-sentinel
docker service create --name=redis-sentinel -p 26379:26379 -e MASTER_IP=192.168.33.101 --replicas=1 daisuzu/redis-sentinel:3.2

# build image of redis-app
cd /vagrant/redis-app/docker; docker build -t daisuzu/redis-app .; cd -

# start redis-app
docker service create --name app -p 8080:8080 daisuzu/redis-app --addr='redis-sentinel:26379'
