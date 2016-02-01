#environment vars...
#env:FILE - the file in which we want to replace
#env:CORE_TAG_FILE - the file containing the core sdk version major minor revision build number mbmobile/builds
#env:BUILD_TIMESTAMP


$CORE_VERSION = & cat $env:CORE_TAG_FILE
$VERSION = "$CORE_VERSION $env:BUILD_TIMESTAMP"

echo "replacing $env:FILE to $VERSION"
cp $env:FILE original.txt

$Version = " public static string BUILD_DATE=`"$VERSION`";"

(Get-Content original.txt) -replace '(\s+public\s+static\s+string\s+BUILD_DATE\s*=\s*".*"\s*;)' , $Version | Out-File -encoding UTF8 $env:FILE
