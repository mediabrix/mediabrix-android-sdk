# newline endings seem important!
# this was written in notepad on windows machine!

cp defines\win81.rsp Assets\smcs.rsp

mkdir -Path Builds\win81

$UnityArgs = @('-batchmode', '-quit', '-projectPath', $pwd, '-executeMethod', 'MediaBrixUnityBuild.PerformWin81Build', '-logFile', 'out.txt')

& 'C:\Program Files (x86)\Unity\Editor\Unity.exe' $UnityArgs

