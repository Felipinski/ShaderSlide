/*
This shader reads the the stencil buffer to check if should be rendered
But how it works?
In this case (Configured in the project material):
Stencil
{
    Ref 1
    Comp NotEqual
}
Reads the stencil buffer and compare with 1. If the current stencil buffer is NOT EQUAL to 1, the object will be rendered.
In the StencilMask.shader, we will write 1 to the stencil buffer.

To make it work, this material should render AFTER the Stencil Mask material.
*/
Shader "Custom/Stencil/StencilObject"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        /*
        This stencil properties uses built in variables to show enums in the inspector that represents 
        - Comparison type
        - Operation        
        */
        _Stencil("Stencil ID", Int) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp("Stencil Comparison", Int) = 0
    }
    SubShader
    {/*
        Make it render AFTER the stencil mask. So it'll READ the stencil buffer AFTER
        the mask writes into it.
        The smaller the Queue number, the sooner it'll be rendered
        As the MASK is rendered in the Geometry-1 and this shader uses Geometry. It'll 
        render after the mask.
        */
        Tags {"Queue" = "Geometry"}
        LOD 100


        /*
        Stencil scope. This scope defines the stencil configuration using the variables declared in the properties scope
        If the comparison fails, the object don't render.
        */
        Stencil
        {
            //Value to read/write
            Ref[_Stencil]
            //Type of comparison
            Comp[_StencilComp]
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            //This is a custom .cginc created to help appling some shading to this examples
            #include "Common.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                o.viewDir = WorldSpaceViewDir(v.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                col = applyLight(
                    col,
                    normalize(i.worldNormal),
                    normalize(i.viewDir));

                return col;
            }
            ENDCG
        }
    }
}
