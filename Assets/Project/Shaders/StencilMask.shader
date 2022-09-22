/*
This shader writes into the the stencil buffer
Stencil
{
    Ref 1
    Comp Always
    Pass Replace
}
ALWAYS write/REPLACE the Reference value 1 to the stencil buffer where this object is rendered.
In the StencilObject.shader we'll read this value to hide it, or not.

To make it work, this material should render BEFORE the Stencil Object material.
*/
Shader "Custom/Stencil/StencilMask"
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
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilOp("Stencil Operation", Int) = 0
    }
    SubShader
    {
        Blend SrcAlpha OneMinusSrcAlpha

        /*
        Make it render BEFORE the stencil mask. So it can WRITE in the stencil buffer BEFORE
        the object.
        The smaller the Queue number, the sooner it'll be rendered
        */
        Tags { "Queue" = "Geometry-1"}
        LOD 100

        /*
        Stencil scope. This scope defines the stencil configuration using the variables declared in the properties scope
        */
        Stencil
        {
            //Value to read/write
            Ref[_Stencil]
            //Type of comparison
            Comp[_StencilComp]
            //Defines if the stencil will write and how
            Pass[_StencilOp]
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return 0;
            }
            ENDCG
        }
    }
}
