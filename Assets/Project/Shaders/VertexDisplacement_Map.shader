/*
This shader map a texture in the vertex shader to use it to displace vertices base on it
*/
Shader "Custom/VertexDisplacement/VertexDisplacement_Map"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _DisplacementTex("Displacement texture", 2D) = "white" {}
        _DisplacementParams("Speed (.xy) | Intensity (.z)", Vector) = (0, 0, 0, 0)
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
                float3 worldNormal : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
            };

            sampler2D _MainTex, _DisplacementTex;
            float4 _MainTex_ST, _DisplacementTex_ST;

            float4 _DisplacementParams;

            float4 moveVertexBasedOnTexture(float4 vertex, float3 normal, float2 uv)
            {
                float4 displacementMap = tex2Dlod(_DisplacementTex, float4(uv + _DisplacementParams.xy * _Time.y, 0, 0));

                vertex.xyz += displacementMap * normal * _DisplacementParams.z;

                return vertex;
            }

            v2f vert(appdata v)
            {
                v2f o;

                v.vertex = moveVertexBasedOnTexture(v.vertex, v.normal, v.uv);

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
