Shader "Unlit/shader1"
{
    Properties // input data
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _ColorStart ("Color Start", Range(0,1)) = 0
        _ColorEnd ("Color End", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { 
        "RenderType"="Transparent" 
        "Queue" = "Transparent"
        }


        Pass
        {

            Cull Off
            ZWrite off
            //ZTest GEqual
            Blend One One // additive
            //Blend DstColor zero // multiply
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAl;
                //float4 tangent : TANGENT;
                //float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD1;
                float3 normal : TEXCOORD0;
                float4 vertex : SV_POSITION; // clip space position
            };

            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); // local space to clip space
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv; //* _Scale + _Offset;
                return o;
            }

            // bool 0 1
            // int
            // float (32 bit float)
            // half (16 bit float)
            // fixed (lower precision) -1 to 1
            // float4x4 (C#: Matrix4x4)

            // 0 1 2 3
            // R G B A
            // X Y Z W

            float InverseLerp (float a, float b, float v){
                return (v-a)/(b-a);
            }


            float4 frag (v2f i) : SV_Target
            {
                //float t = saturate(InverseLerp(_ColorStart, _ColorEnd, i.uv.x));

                //return i.uv.y;

                float xOffset = cos(i.uv.x* 8 * TAU) * 0.01;
                float t = cos((i.uv.y + xOffset - _Time.y * 0.1) * 5 * TAU) * 0.5 + 0.5;
                t *= 1 - i.uv.y;

                float topBottomRemover = (abs(i.normal.y) < 0.999);
                float waves = t * topBottomRemover;

                float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);
                return gradient * waves;
            }
            ENDCG
        }
    }
}
