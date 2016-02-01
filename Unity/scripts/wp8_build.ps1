# newline endings seem important!
# this was written in notepad on windows machine!

cp defines\wp8.rsp Assets\smcs.rsp

$UnityArgs = @('-batchmode', '-quit', '-projectPath', $pwd, '-executeMethod', 'MediaBrixUnityBuild.PerformWP8Build', '-logFile', 'out.txt')

& 'C:\Program Files (x86)\Unity\Editor\Unity.exe' $UnityArgs

