Shader "Custom/RGB2GrayWhite" 
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
	_NormalTex("Sprite Texture", 2D) = "white" {}
	_StencilComp("Stencil Comparison", Float) = 8
		_Stencil("Stencil ID", Float) = 0
		_StencilOp("Stencil Operation", Float) = 0
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		_StencilReadMask("Stencil Read Mask", Float) = 255
	}

		SubShader
	{
		Tags
	{
		"Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
		"PreviewType" = "Plane"
		"CanUseSpriteAtlas" = "True"
	}

		Stencil
	{
		Ref[_Stencil]
		Comp[_StencilComp]
		Pass[_StencilOp]
		ReadMask[_StencilReadMask]
		WriteMask[_StencilWriteMask]
	}

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest[unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		GrabPass{}
		Pass
	{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
#include "UnityUI.cginc"

		struct appdata_t
	{
		float4 vertex   : POSITION;
		float4 color    : COLOR;
		float2 texcoord : TEXCOORD0;
	};
	struct v2f
	{
		float4 vertex   : SV_POSITION;
		half2 texcoord  : TEXCOORD0;
		float4 worldPosition : TEXCOORD1;
	};

	v2f vert(appdata_t IN)
	{
		v2f OUT;
		OUT.worldPosition = IN.vertex;
		OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);
		OUT.texcoord = half2(IN.texcoord.x, 1 - IN.texcoord.y);
		return OUT;
	}

	sampler2D _MainTex;
	uniform half4 _MainTex_TexelSize;

	sampler2D _GrabTexture;
	uniform half4 _GrabTexture_TexelSize;

	fixed4 frag(v2f IN) : SV_Target
	{
		fixed4 color = tex2D(_GrabTexture, IN.texcoord);
	float gray = dot(color.rgb, float3(0.299, 0.587, 0.114));
	color.rgb = float3(gray, gray, gray);

	return color;
	}
		ENDCG
	}
	}
}
