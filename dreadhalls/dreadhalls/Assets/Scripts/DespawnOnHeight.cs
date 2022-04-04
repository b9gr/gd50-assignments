using System;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DespawnOnHeight : MonoBehaviour
{
	private CharacterController characterController;
	private float heightThreshold;

	void Awake()
	{
		characterController = GetComponent<CharacterController>();
		heightThreshold = GameObject.Find("FloorParent").transform.position.y;
	}

	void Update() {
		if (characterController.transform.position.y < heightThreshold)
		{
			SceneManager.LoadScene("GameOver");
		}
	}
}