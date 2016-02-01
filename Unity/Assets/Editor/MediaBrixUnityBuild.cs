using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor.Callbacks;

public class MediaBrixUnityBuild : MonoBehaviour {

    static string GetProjectName() {
        string[] s = Application.dataPath.Split('/');
        return s[s.Length - 2];
    }

    static string[] GetScenePaths() {
        string[] scenes = new string[EditorBuildSettings.scenes.Length];

        for (int i = 0; i < scenes.Length; i++) {
            scenes[i] = EditorBuildSettings.scenes[i].path;
        }

        return scenes;
    }

	[MenuItem("File/AutoBuilder/ios")]
	static void PerformiOSBuild () {
        PlayerSettings.productName = "Unity-iPhone";
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.iOS);
		BuildPipeline.BuildPlayer(GetScenePaths(), "Builds/ios",BuildTarget.iOS,BuildOptions.None);
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.iOS);
    }

    [MenuItem("File/AutoBuilder/android")]
    static void PerformAndroidBuild() {
        PlayerSettings.productName = "MediaBrix Unity";
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.Android);
        BuildPipeline.BuildPlayer(GetScenePaths(), "Builds/android/mediabrix-unity.apk", BuildTarget.Android, BuildOptions.None);
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.Android);
    }

	[MenuItem("File/AutoBuilder/wp8")]
	static void PerformWP8Build () {
        PlayerSettings.productName = "MediaBrixUnityWP";
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.WP8Player);
		BuildPipeline.BuildPlayer(GetScenePaths(), "Builds/wp8",BuildTarget.WP8Player, BuildOptions.None);
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.WP8Player);
    }

    [MenuItem("File/AutoBuilder/win81")]
    static void PerformWin81Build() {
        PlayerSettings.productName = "MediaBrixUnity";
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.WSAPlayer);
        BuildPipeline.BuildPlayer(GetScenePaths(), "Builds/win81", BuildTarget.WSAPlayer, BuildOptions.None);
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.WSAPlayer);
    }

    [PostProcessBuild]
    public static void OnPostProcessBuild(BuildTarget target, string path) {
        // Create a new project object from build target
        if (BuildTarget.iOS != target) return;
        UnityEditor.XCodeEditor.XCProject project = new UnityEditor.XCodeEditor.XCProject(path);

        // Find and run through all projmods files to patch the project
        var files = System.IO.Directory.GetFiles(Application.dataPath, "*.projmods", SearchOption.AllDirectories);
        foreach (var file in files) {
            project.ApplyMod(file);
        }

        // Finally save the xcode project to disk
        project.Save();
    }

}
