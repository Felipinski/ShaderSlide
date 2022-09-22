using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class EnableCameraFilter : MonoBehaviour
{
    //Material that will be applied to the output texture
    [SerializeField]
    private Material material;

    /*Unity callback the pass a render texture to our material
     * This technique will load a full screen render texture into
     * the memory, so if you're working with low tecnical budget,
     * avoid using it.
    */
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}
