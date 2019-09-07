Shader "Colored Self Shadow" 
{
Properties 
{
	_DiffuseVal ("Diffuse Val", Range(0,1)) = 1
	_MainCol ("Color", Color) = (1,1,1,1)
	_ShadowColor ("Self Shadow Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
}
SubShader 
{
	Tags { "RenderType"="Opaque" }
	LOD 200

CGPROGRAM
#pragma surface surf CSLambert
sampler2D _MainTex;
float _DiffuseVal;
float4 _ShadowColor;
float4 _MainCol;

struct Input 
{
	float2 uv_MainTex;
};

half4 LightingCSLambert (SurfaceOutput s, half3 lightDir, half atten) 
{
	fixed diff = max (0, dot (s.Normal, lightDir));

	fixed4 c;
	c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 2);
	
	//shadow colorization
	c.rgb += _ShadowColor.xyz * max(0.0,(1.0-(diff*atten*2))) * _DiffuseVal;
	c.a = s.Alpha;
	return c;
}

void surf (Input IN, inout SurfaceOutput o) 
{
	half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainCol;
	o.Albedo = c.rgb;
	o.Alpha = c.a;
}

ENDCG    
}

Fallback "Diffuse"
}
