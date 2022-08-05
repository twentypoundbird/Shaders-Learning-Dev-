using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    [SerializeField]
    private Material material;

    [SerializeField, Range(0.01f, 2f)]
    private float speed;

    private const string PROPERTY_KEY = "_PointOffset";

    private Vector2 offset;


    // Update is called once per frame
    void Update()
    {
        if(material == null)
        {
            return;
        }

        Vector2 direction = new Vector2(-Input.GetAxisRaw("Horizontal"), -Input.GetAxisRaw("Vertical")).normalized;
        offset += direction * speed * Time.deltaTime;

        material.SetVector(PROPERTY_KEY, offset);
    }
}
