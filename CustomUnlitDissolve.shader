Shader "Custom/UnlitDissolveAlpha"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MaskTex ("DissolveTexture", 2D) = "white" {}
        _LowThreshold("LowThreshold", Range(0,1)) = 1
        _HightThreshold("HightThreshold", Range(0,1)) = 1
        _Intensity("Intensity", Range(0,1)) = 1
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
        //Blend One OneMinusSrcAlpha
		ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"


            struct appdata
            {
                float4 vertex : POSITION;
                float3 uv : TEXCOORD0;
                float3 uv2 : TEXCOORD1;
				fixed4 color : COLOR;
            };

            struct v2f
            {
                float3 uv : TEXCOORD0;
                float3 uv2 : TEXCOORD1;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
            };

            sampler2D _MainTex,
                      _MaskTex
                      ;
            fixed _Intensity;
            fixed4 _Color;

            float4 _MainTex_ST;
            float4 _MaskTex_ST;
            fixed _LowThreshold;
            fixed _HightThreshold;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv2.xy = TRANSFORM_TEX(v.uv, _MaskTex);
				o.color = v.color;
				o.uv.z = v.uv.z;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }



            fixed4 frag (v2f i) : SV_Target
            {
                float dissolveMask =  _Intensity;
                // sample the texture
                fixed4 dTex = tex2D(_MaskTex, i.uv2).r;
                fixed4 col = tex2D(_MainTex, i.uv);

                half dissolve = smoothstep(dissolveMask*_LowThreshold, dissolveMask*_HightThreshold, dTex);


				col *= i.color*_Color*dissolve;
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
