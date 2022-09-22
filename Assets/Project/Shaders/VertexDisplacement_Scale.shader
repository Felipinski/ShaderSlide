/*
This shader move each vertex based on its normal. This will not work properly with flat surfaces
*/
Shader "Custom/VertexDisplacement/VertexDisplacement_Scale"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Scale("Scale", Range(0, 2)) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

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
                //This line of code enable us to use normals from our object                
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
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

            float _Scale;

            //Function to move vertex
            float4 moveVertex(float4 vertex, float3 normal)
            {
                //Move vertex based on its normal.
                vertex.xyz += normal * _Scale;

                return vertex;
            }

            v2f vert(appdata v)
            {
                v2f o;

                v.vertex = moveVertex(v.vertex, v.normal);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                o.viewDir = WorldSpaceViewDir(v.vertex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
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
