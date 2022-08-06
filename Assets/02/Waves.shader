Shader "Unlit/Shader3"
{
   Properties // input data
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _ColorStart ("Color Start", Range(0,1)) = 0
        _ColorEnd ("Color End", Range(0,1)) = 1
        _WaveAmp ("Wave amplitude", Range(0,0.2)) = 0.1
    }
    SubShader
    {
        Tags { 
        "RenderType"="Opaque" 
        }


        Pass
        {

            
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
            float _WaveAmp;

            float GetWave(float2 uv){
                float2 uvsCentred = uv * 2 - 1;
                float radialDistance = length(uvsCentred);
                float wave = cos((radialDistance  - _Time.y * 0.1) * 5 * TAU) * 0.5 + 0.5;
                wave *= 1-radialDistance;
                return wave;
            }

            v2f vert (appdata v)
            {
                v2f o;

                //float wave = cos((v.uv.y  - _Time.y * 0.1) * 5 * TAU);
                //float wave2 = cos((v.uv.x  - _Time.y * 0.1) * 5 * TAU);
                //v.vertex.y = wave * wave2 * _WaveAmp;
                v.vertex.y = GetWave(v.uv) *_WaveAmp ;
                o.vertex = UnityObjectToClipPos(v.vertex); // local space to clip space
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv; //* _Scale + _Offset;

                return o;
            }

            

            float InverseLerp (float a, float b, float v){
                return (v-a)/(b-a);
            }

            

            float4 frag (v2f i) : SV_Target
            {
                return GetWave(i.uv);

            }
            ENDCG
        }
    }
}
