using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Active : MonoBehaviour
{
    public float WaitTime = 0.2f;
    //private WaitForSeconds Delay = new WaitForSeconds(0.2f);
    public ParticleSystem ParticleObject;
    public GameObject obj;
    // Start is called before the first frame update
    void Start()
    {
        ParticleObject.Clear();

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            ParticleObject.Clear();
            ParticleObject.Play();

            StartCoroutine(LateCall());

            IEnumerator LateCall()
            {
                //yield return Delay;
                yield return new WaitForSeconds(WaitTime);
                obj.SetActive(true);
            }
        }

        if (Input.GetKeyDown(KeyCode.LeftControl))
        {
            obj.SetActive(false);
        }
    }
}
