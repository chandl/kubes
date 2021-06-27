#!/usr/bin/env bash 

NAMESPACE=media

echo "Creating namespace $NAMESPACE"
sudo k3s kubectl create namespace $NAMESPACE


echo "Setting up volumes"
sudo k3s kubectl apply -f volumes.yml -n $NAMESPACE

echo "Setting up ingress"
sudo k3s kubectl apply -f ingress.yml -n $NAMESPACE 

echo "Setting up transmission"
sudo k3s kubectl apply -f transmission.yml -n $NAMESPACE


echo "Setting up Jackett"
echo "{
  \"BasePathOverride\": \"/jackett\"
}" | sudo tee /mnt/hdd/config/jackett/Jackett/ServerConfig.json
sudo k3s kubectl apply -f jackett.yml -n $NAMESPACE

echo "Setting up Sonarr"
sudo mkdir -p /mnt/hdd/config/sonarr/
echo "<Config>
  <UrlBase>/sonarr</UrlBase>
</Config>" | sudo tee /mnt/hdd/config/sonarr/config.xml
sudo k3s kubectl apply -f sonarr.yml -n $NAMESPACE

echo "Setting up Radarr"
sudo mkdir -p /mnt/hdd/config/radarr/
echo "<Config>
  <UrlBase>/radarr</UrlBase>
</Config>" | sudo tee /mnt/hdd/config/radarr/config.xml
sudo k3s kubectl apply -f radarr.yml -n $NAMESPACE

echo "Setting up Jellyfin"
sudo k3s kubectl apply -f jellyfin.yml -n $NAMESPACE

echo "Finished creating services - Pods: "
sudo k3s kubectl get pods -n $NAMESPACE
echo "Services: "
sudo k3s kubectl get svc -n $NAMESPACE

echo "Now, you need to manually set up some services..."
echo -e "\tJackett - Add one or more indexers, but not too many..."

echo -e "\tSonarr - Configure the connection to Transmission into Settings / Download Client / Add (Transmission) using the hostname and port transmission:9091"
echo -e "\tSonarr - Add Root folder as /tv in settings -> media management"
echo -e "\tSonarr - Configure Jackett as Indexer - torznab URL: http://jackett:9117/api/v2.0/indexers/all/results/torznab "

echo -e "\Radarr - Add Root folder as /movies in settings -> media management"
echo -e "\Radarr - Configure Jackett as Indexer - torznab URL: http://jackett:9117/api/v2.0/indexers/all/results/torznab "
