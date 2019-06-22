using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
public class ShieldHelper : MonoBehaviour
{
    private float _ImpactSize;
    //public Vector3[] points;
    public Material shieldMatetial;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    int Hit = 0;
    void OnCollisionEnter(Collision collision)
    {           

        shieldMatetial.SetVector("_Points", collision.contacts[0].point);
        shieldMatetial.SetFloat("_TimeImpact", Time.timeSinceLevelLoad);

        //Debug.Log(pos);
        // shieldMatetial.SetInt("_PointsSize", 0);


    }

}
