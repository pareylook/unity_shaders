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

    int hit = 0;
    void OnCollisionEnter(Collision collision)
    {
        //shieldMatetial.SetVector("_Point0", collision.contacts[0].point);
        //shieldMatetial.SetFloat("_TimeImpact0", Time.timeSinceLevelLoad);
        if (hit == 0)
        {
            shieldMatetial.SetVector("_Point0", collision.contacts[0].point);
            shieldMatetial.SetFloat("_TimeImpact0", Time.timeSinceLevelLoad);
            hit++;
        }
        else if (hit == 1)
        {
            shieldMatetial.SetVector("_Point1", collision.contacts[0].point);
            shieldMatetial.SetFloat("_TimeImpact1", Time.timeSinceLevelLoad);
            hit++;
        }
        else if (hit == 2)
        {
            shieldMatetial.SetVector("_Point2", collision.contacts[0].point);
            shieldMatetial.SetFloat("_TimeImpact2", Time.timeSinceLevelLoad);
            hit++;
        }

        if (hit >= 3)
        {
            hit = 0;
        }
        //Debug.Log(pos);
        // shieldMatetial.SetInt("_PointsSize", 0);


    }

}
