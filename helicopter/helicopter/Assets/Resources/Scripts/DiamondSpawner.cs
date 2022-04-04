using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DiamondSpawner : MonoBehaviour
{

    public GameObject[] prefabs;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(SpawnDiamonds());
    }

    // Update is called once per frame
    void Update()
    {
    }

    IEnumerator SpawnDiamonds() {
		while (true) {

			// number of coins we could spawn vertically
			int coinsThisRow = Random.Range(1, 2);

			// instantiate all coins in this row separated by some random amount of space
			for (int i = 0; i < coinsThisRow; i++) {
				Instantiate(prefabs[Random.Range(0, prefabs.Length)], new Vector3(26, Random.Range(-10, 10), 10), Quaternion.identity);
			}

			// pause 5-12 seconds until the next coin spawns
			yield return new WaitForSeconds(Random.Range(5, 12));
		}
	}
}
