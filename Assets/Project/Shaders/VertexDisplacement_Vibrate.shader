/*
This shader move every vertex in the same direction, to create a vibration animation
*/
Shader "Custom/VertexDisplacement/VertexDisplacement_Vibrate"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        [Header(Vibration params)]
        /*You can use the same variable to different purposes. It can help you avoid using many variables in your shader.
        Just please, specify what each channel means heh
        In this example, xyz channels represents the movement intensity in each axis.
        The w channel represents the speed of the movement
        */

        _VibrationParams("Axis intensity(.xyz) | Speed(.w)", Vector) = (0, 0, 0, 0)
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
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                    float3 worldNormal : TEXCOORD1;
                    float3 viewDir : TEXCOORD3;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;

                float4 _VibrationParams;

                //Function created to move vertex
                float4 vibrateVertex(float4 vertex)
                {
                    //Animate the vertex in each vertex using sin() and _Time.y variable with our _VibrationParams
                    vertex.x += sin(_Time.y * _VibrationParams.x) * _VibrationParams.w;
                    vertex.y += sin(_Time.y * _VibrationParams.y) * _VibrationParams.w;
                    vertex.z += sin(_Time.y * _VibrationParams.z) * _VibrationParams.w;

                    return vertex;
                }

                v2f vert(appdata v)
                {
                    v2f o;                    

                    v.vertex = vibrateVertex(v.vertex);

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
