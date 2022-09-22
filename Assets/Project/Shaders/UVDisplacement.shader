/*
This shader manipulate the UV "make the texture move" over the object
*/
Shader "Custom/UVDisplacement/UV_Displacement"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ScrollParams ("Scroll params (.xy)", Vector) = (0, 0, 0, 0)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
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

            float2 _ScrollParams;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                v.uv += _ScrollParams.xy * _Time.y;

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
