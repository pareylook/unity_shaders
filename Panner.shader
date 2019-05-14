Shader "FX/Panner"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Color Texture", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "white" {}
        _MFade("Mask Fade", Range(0,1)) = 0.2
        _MIntesity("Mask Intesity", Float) = 1
        _SpeedU("Color SpeedU", Float) = 1
        _SpeedV("Color SpeedV", Float) = 1
        _DissolveTex ("Dissolve Texture", 2D) = "white" {}
        _SpeedUd("Dissolve SpeedU", Float) = 1
        _SpeedVd("Dissolve SpeedV", Float) = 1
        _Fade("Dissolve Fade", Range(0,1)) = 0.2
        _Intesity("Dissolve Intesity", Float) = 1

        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("BlendSource", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("BlendDestination", Float) = 0
      
    }
    SubShader
    {
        
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Opaque"}
        LOD 100
	    //Blend SrcAlpha One //additive
        //Blend SrcAlpha OneMinusSrcAlpha //stadart
        //Blend One OneMinusSrcAlpha //premult
        Blend [_SrcBlend] [_DstBlend]
        Cull Off
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
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float2 uv3 : TEXCOORD2;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float2 uv3 : TEXCOORD2;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _MaskTex;
            sampler2D _DissolveTex;
            float4 _MainTex_ST;
            float4 _MaskTex_ST;
            float4 _DissolveTex_ST;
            fixed _SpeedU;
            fixed _SpeedV;
            fixed _SpeedUd;
            fixed _SpeedVd;
            fixed _Fade;
            fixed _Intesity;
            fixed _MFade;
            fixed _MIntesity;
            fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv2 = TRANSFORM_TEX(v.uv2, _DissolveTex);
                o.uv3 = TRANSFORM_TEX(v.uv2, _MaskTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //Panner Time
                fixed PannerU = frac(_SpeedU * _Time);
                fixed PannerV = frac(_SpeedV * _Time);
                fixed PannerUd = frac(_SpeedUd * _Time);
                fixed PannerVd = frac(_SpeedVd * _Time);
                i.uv += fixed2(PannerU, PannerV);
                i.uv2 += fixed2(PannerUd, PannerVd);

                //mask Texture Time
                fixed4 mtex = tex2D(_MaskTex, i.uv3);
                fixed mintens = _MIntesity;
                half mask = smoothstep(mintens*1-_MFade, mintens*1+_MFade, mtex);

                //Dissolve Texture Time
                fixed4 dtex = tex2D(_DissolveTex, i.uv2)-mtex;
                //fixed intens = frac(_Intesity * _Time);
                fixed intens = _Intesity;
                half dissolve = smoothstep(intens*1-_Fade, intens*1+_Fade, dtex);
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 ctex = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                dissolve-=mask;
                col*=dissolve;
                //col+=mask;
                col*=(1-mask)*_Color;
                col*=ctex.z;
                col = clamp(col, 0,1);

                return col;
            }
            ENDCG
        }
    }
}
