Shader "Custom/SHADER_SHIELD"
{
    Properties
    {
        [HDR] _Color ("Color", Color) = (1,1,1,1)
        [HDR] _PointColor ("Point Color", Color) = (1,0,0,1)
        [HDR] _PointColor2 ("Point Color2", Color) = (1,0,0,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _AlphaTex ("Alpha (RGB)", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Fade("Alpha Fade", Range(0,1)) = 0.2
        _Intesity("Alpha Intesity", Range(0,1)) = 1
        _MaskIntesity("Mask Intesity", Range(0,10)) = 1
    }
    SubShader
    {
        Tags {"Queue" = "Transparent" "RenderType"="Transparent" }
        LOD 200
        Cull Off

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _AlphaTex;
        sampler2D _MaskTex;


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_AlphaTex;
            float2 uv_MaskTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        fixed4 _PointColor;
        fixed4 _PointColor2;
        int _PointsSize;
        fixed3 _Point0;
		fixed3 _Point1;
		fixed3 _Point2;
        float _TimeImpact0;
		float _TimeImpact1;
		float _TimeImpact2;

        fixed _Fade;
        fixed _Intesity;
        fixed _MaskIntesity;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            half size = 0;
            fixed p0_emissive = 0;
            fixed p0_emissive2 = 0;
			fixed p1_emissive = 0;
			fixed p1_emissive2 = 0;
			fixed p2_emissive = 0;
			fixed p2_emissive2 = 0;

            p0_emissive += frac(1 - max(0, ((((_Time.y - _TimeImpact0) / 0.6)) - (distance(_Point0.xyz, IN.worldPos) * 0.5) ) ) ) * max(0, (1 - ((_Time.y - _TimeImpact0) / 0.6)));
            p0_emissive2 += max(0, (1 - (distance(_Point0.xyz, IN.worldPos) * 0.2) ) ) * max(0, (1 - ((_Time.y - _TimeImpact0) / 0.6)));

			p1_emissive += frac(1 - max(0, ((((_Time.y - _TimeImpact1) / 0.6)) - (distance(_Point1.xyz, IN.worldPos) * 0.5)))) * max(0, (1 - ((_Time.y - _TimeImpact1) / 0.6)));
			p1_emissive2 += max(0, (1 - (distance(_Point1.xyz, IN.worldPos) * 0.2))) * max(0, (1 - ((_Time.y - _TimeImpact1) / 0.6)));

			p2_emissive += frac(1 - max(0, ((((_Time.y - _TimeImpact2) / 0.6)) - (distance(_Point2.xyz, IN.worldPos) * 0.5)))) * max(0, (1 - ((_Time.y - _TimeImpact2) / 0.6)));
			p2_emissive2 += max(0, (1 - (distance(_Point2.xyz, IN.worldPos) * 0.2))) * max(0, (1 - ((_Time.y - _TimeImpact2) / 0.6)));




            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 alpha = tex2D (_AlphaTex, IN.uv_AlphaTex);
            fixed4 mask_tex = tex2D (_MaskTex, IN.uv_MaskTex);
            fixed mintens = _Intesity;
            fixed mein_intens = _MaskIntesity;
            half a_mask = smoothstep(mintens*1-_Fade, mintens*1+_Fade, alpha);
            half main_mask = smoothstep(_MaskIntesity*1-_Fade, _MaskIntesity*1+_Fade, mask_tex.r);
            o.Albedo = c.rgb;
            o.Emission = ((p0_emissive2 * _PointColor2) + (a_mask * c.a ) + (p0_emissive * _PointColor) + (a_mask * c.a ) * _Color) + 
						 ((p1_emissive2 * _PointColor2) + (a_mask * c.a) + (p1_emissive * _PointColor) + (a_mask * c.a) * _Color) + 
						 ((p2_emissive2 * _PointColor2) + (a_mask * c.a) + (p2_emissive * _PointColor) + (a_mask * c.a) * _Color);
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = (a_mask * c.a) * main_mask;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
