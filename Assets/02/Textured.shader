Shader "Unlit/Textured"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RockTex ("Rock Texture", 2D) = "white" {}
        _Pattern ("Pattern", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _RockTex;
            sampler2D _Pattern;


            v2f vert (appdata v)
            {
                v2f o;
                o.worldPos = mul(UNITY_MATRIX_M, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 upDownProjection = i.worldPos.xz;
                //return float4(upDownProjection,0,1);
                float4 moss = tex2D(_MainTex, upDownProjection);
                float4 rock = tex2D(_RockTex, upDownProjection);
                float pattern = tex2D(_Pattern, i.uv).x;
                
                float4 finalColor = lerp(rock, moss, pattern);
                //float4 finalColor = moss * pattern;
                return finalColor;
            }
            ENDCG
        }
    }
}
