Shader "Unlit/Panner"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Color Texture", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "white" {}
        _SpeedU ("Speed U", Float) = 0
        _SpeedV ("Speed V", Float) = 0
        _MIntensity ("Mask Intensity", Float) = 0
        _MFade ("Mask Fade", Float) = 0
        [Space (20)][Header (Dissolve)]
        _DissolveTex ("Dissolve Texture", 2D) = "white" {}
        _DIntensity ("Dissolve Intensity", Float) = 0
        _DFade ("Dissolve Fade", Float) = 0
        _DSpeedU ("Speed U", Float) = 0
        _DSpeedV ("Speed V", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Blend SrcAlpha One
        ZWrite On
        ZTest Less
        LOD 100

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
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 color : COLOR0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 vertex : SV_POSITION;
                float4 color : COLOR0;
            };

            sampler2D _MainTex;
            sampler2D _MaskTex;
            sampler2D _DissolveTex;
            float4 _MainTex_ST;
            float4 _MaskTex_ST;
            float4 _DissolveTex_ST;
            fixed _SpeedU;
            fixed _SpeedV;
            fixed _DSpeedU;
            fixed _DSpeedV;
            fixed _MIntensity;
            fixed _MFade;
            fixed _DIntensity;
            fixed _DFade;
            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.color = v.color;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv1 = TRANSFORM_TEX(v.uv1, _MaskTex);
                o.uv2 = TRANSFORM_TEX(v.uv2, _DissolveTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {   
                //offset color
                fixed PannerU = _SpeedU * _Time;
                fixed PannerV = _SpeedV * _Time;         
                i.uv += fixed2(PannerU, PannerV);

                // offset dissolve
                fixed DPannerU = _DSpeedU * _Time;
                fixed DPannerV = _DSpeedV * _Time;         
                i.uv2 += fixed2(DPannerU, DPannerV);


                // sample the texture
                fixed4 col_tex = tex2D(_MainTex, i.uv);
                fixed4 col_tex2 = tex2D(_MainTex, i.uv);
                fixed4 mask_tex = tex2D(_MaskTex, i.uv1);
                fixed4 dissolve_tex = tex2D(_DissolveTex, i.uv2);
                half mask = smoothstep(_MIntensity * 1 -_MFade, _MIntensity * 1+_MFade, mask_tex);
                half dissolve = smoothstep(_DIntensity * 1 -_DFade, _DIntensity * 1+_DFade, dissolve_tex);
                dissolve -= mask;
                dissolve = clamp(dissolve,0,1);
                col_tex *= dissolve;
                col_tex*=(1-(mask*dissolve))*_Color;
                col_tex*=col_tex2.z;
                return col_tex*i.color;
            }
            ENDCG
        }
    }
}
