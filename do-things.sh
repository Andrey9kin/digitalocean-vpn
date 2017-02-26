set -e

CREDENTIALS=${CREDENTIALS:-user6:password87356##}
VPN=${VPN:-AMS3}
USER=$(echo ${CREDENTIALS} | awk -F : '{print $1}')
PASSWORD=$(echo ${CREDENTIALS} | awk -F : '{print $2}')

echo "Build Digital Ocean snapshot"
echo "Check if there is one already..."
digitalocean-cli image list
IMAGE_ID=$(digitalocean-cli image list 2>&1 | grep softvpn | awk '{print $1}')
if [ ! -z ${IMAGE_ID} ]
then
  echo "Found image id ${IMAGE_ID}"
  echo "Destroying image..."
  digitalocean-cli image destroy ${IMAGE_ID}
else
  echo "Nothing found. Carry on"
fi

echo "Building snapshot..."
CREDENTIALS=${CREDENTIALS} packer build machine.json

echo "Getting image id..."
digitalocean-cli image list
IMAGE_ID=$(digitalocean-cli image list 2>&1 | grep softvpn | awk '{print $1}')
echo "Found image id ${IMAGE_ID}"

echo "Creating droplet..."
digitalocean-cli droplet create --image ${IMAGE_ID} --name softvpn

echo "Waiting for droplet to become active..."
STATUS=$(digitalocean-cli droplet list 2>&1 | grep softvpn | awk '{print $2}')
while [ $STATUS != "active" ]
do
  echo "Still waiting..."
  sleep 10
  STATUS=$(digitalocean-cli droplet list 2>&1 | grep softvpn | awk '{print $2}')
done
echo "Droplet is active"

echo "Give it another 15 sec to load VPN server"
sleep 15

echo "Update VPN ${VPN} config and connect - new ip ${IP}, new user ${USER}, new password ${PASSWORD}"
IP=$(digitalocean-cli droplet list 2>&1 | grep softvpn | awk '{print $3}')
osascript update_vpn.applescript ${VPN} ${IP} ${USER} ${PASSWORD} notasecret