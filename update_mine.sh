#$1 should be version number
#rm version_manifest.json
if [ -z  "$1"]; then
	wget https://launchermeta.mojang.com/mc/game/version_manifest.json
	version=$(jq '.versions | .[0] | .url' version_manifest.json | tr -d ",\"")
	fileversionname=$(jq '.versions | .[0] | .id' version_manifest.json | tr -d ",\"")
	echo "getting latest version: $fileversionname"

else
	fileversionname=$1
	version=$(jq '.versions[] | select(.id==$ARGS.positional[0]) | .url' version_manifest.json --args $fileversionname | tr -d ",\"")
	echo "bird $version the bird"
fi
wget $version

version_sha1=$(jq '.downloads | .server | .sha1' "$fileversionname.json" | tr -d ".\"")
echo $version_sha1
wget https://launcher.mojang.com/v1/objects/$version_sha1/server.jar

cp -r minecraft/world world
rm -r minecraft
mkdir minecraft
mv server.jar minecraft/server.jar

cd minecraft
echo $(pwd)
java -Xmx1024M -Xms1024M -jar server.jar nogui

cp ../eula.txt eula.txt
cp -r world minecraft/world
java -Xmx1024M -Xms1024M -jar server.jar nogui

cp -r world ../world


