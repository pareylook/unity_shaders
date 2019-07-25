Shader "CTD/FakeBRDF"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Atten ("Atten", Float) = 1

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM     
        #pragma surface surf Ramp
        #pragma target 3.0

        // Use shader model 3.0 target, to get nicer looking lighting

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        half _FadeShadow;
        half _BrightnesShadow;
        half _Atten;

        half4 LightingRamp (SurfaceOutput s, half3 lightDir, half3  viewDir, half atten)
        {
            fixed NdotL = dot(s.Normal, lightDir);
            NdotL = NdotL * 0.5 + 0.5;
            fixed NdotV = dot(s.Normal, viewDir);


            float diff = NdotL * _FadeShadow + _BrightnesShadow;
            float2 brdfUV = float2(NdotV, diff);
            float3 BRDF = tex2D(_MainTex, float2(NdotV, NdotL)).rgb;

            float4 c;
            // c.rgb = float3(diff, diff, diff);
            c.rgb = BRDF * (atten * _Atten);
            c.a = s.Alpha;
            return c;
        }
        void surf (Input IN, inout SurfaceOutput o)
        {
            // fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            half4 c = _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    // FallBack "Diffuse"
}
