using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadTitleScene : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetAxis("Submit") == 1) {
			Destroy(GameObject.Find("WhisperSource")); 
			// LevelCounter.level = 1;
			SceneManager.LoadScene("Title");
		}
	}
}