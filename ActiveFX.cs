using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Active : MonoBehaviour
{
    public float WaitTime = 0.2f;
    //private WaitForSeconds Delay = new WaitForSeconds(0.2f);
    public ParticleSystem ParticleObjectOn;
    public ParticleSystem ParticleObjectOff;
    public GameObject obj;
    // Start is called before the first frame update
    void Start()
    {
        ParticleObjectOn.Clear();
        ParticleObjectOff.Clear();
        obj.SetActive(false);

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            ParticleObjectOn.Clear();
            ParticleObjectOn.Play();

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
            ParticleObjectOff.Clear();
            ParticleObjectOff.Play();
            
            StartCoroutine(LateCall());

            IEnumerator LateCall()
            {
                //yield return Delay;
                yield return new WaitForSeconds(WaitTime);
                obj.SetActive(false);
            }
        }
    }
}
