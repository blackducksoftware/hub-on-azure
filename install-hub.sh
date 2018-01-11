HOST_URL=$1
HUB_VERSION=$2

## Install Docker (https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#set-up-the-repository)
sudo apt-get remove docker docker-engine docker.io
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
sudo apt-get update
sudo apt-get install -y docker-ce=17.09.0~ce-0~ubuntu
sudo service docker start

## Install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
cd /usr/bin
sudo ln -s /usr/local/bin/docker-compose


## Install Java
sudo apt-get -y install default-jre

## Install Hub
cd /
sudo wget https://github.com/blackducksoftware/hub/archive/v${HUB_VERSION}.tar.gz
sudo tar xvf v${HUB_VERSION}.tar.gz
sudo rm v${HUB_VERSION}.tar.gz

echo 
cd /hub-${HUB_VERSION}/docker-compose
echo "sed -i \"s/PUBLIC_HUB_WEBSERVER_HOST\=.*/PUBLIC_HUB_WEBSERVER_HOST\=\$1/g\" /hub-${HUB_VERSION}/docker-compose/hub-webserver.env" | sudo tee /set_hub_url.sh
sudo -s source /set_hub_url.sh $HOST_URL
sudo docker-compose up
