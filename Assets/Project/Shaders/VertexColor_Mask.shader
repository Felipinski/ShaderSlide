/*
This shader uses vertex color to map different textures based on vertex color.
*/
Shader "Custom/VertexColor/VertexColor_Mask"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _DetailsTex("Details Texture", 2D) = "white" {}
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
                //This line of code enable us to use the colors defined by vertex
                float4 color : COLOR;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                //Used float4 to map 2 texture with one TEXCOORD
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
            };

            sampler2D _MainTex, _DetailsTex;
            float4 _MainTex_ST, _DetailsTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                //Use xy to mainTex
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);

                //Use zw to mainTex
                o.uv.zw = TRANSFORM_TEX(v.uv, _DetailsTex);
                //Animate the second UV
                o.uv.zw += float2(0, -_Time.y) * 0.1;

                o.color = v.color;

                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = WorldSpaceViewDir(v.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv.xy);
                fixed4 detailColor = tex2D(_DetailsTex, i.uv.zw);

                //Apply the detail color based on the G channel of our vertex color.
                col = lerp(col, detailColor, i.color.g);

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
