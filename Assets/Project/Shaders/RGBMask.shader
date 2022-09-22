/*
This shader uses a texture to define areas where we can customize the color
*/
Shader "Custom/ColorMask/RGB_Mask"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}

        _RGBMaskTex("RGB Mask Texture", 2D) = "white" {}
        _RColor("R color", Color) = (1, 1, 1, 1)
        _GColor("G color", Color) = (1, 1, 1, 1)
        _BColor("B color", Color) = (1, 1, 1, 1)
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

            sampler2D _MainTex, _RGBMaskTex;
            float4 _MainTex_ST, _RGBMaskTex_ST;

            float4 _RColor, _GColor, _BColor;

            float4 applyRGBMask(float4 color, float2 uv)
            {
                fixed4 mask = tex2D(_RGBMaskTex, uv);
                
                fixed4 newColor = 
                    mask.r * _RColor +
                    mask.g * _GColor +
                    mask.b * _BColor;
                
                color = lerp(color, newColor, mask.r + mask.g + mask.b);

                return color;
            }

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

                col = applyRGBMask(col, i.uv);

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
