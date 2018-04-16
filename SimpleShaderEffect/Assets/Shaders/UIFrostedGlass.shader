// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/UIFrostedGlass" 
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
	sampler2D _NormalTex;
	float _RandomParam;
	static const half4 curve4[7] = { half4(0.0205,0.0205,0.0205,0),
		half4(0.0855,0.0855,0.0855,0),
		half4(0.232,0.232,0.232,0),
		half4(0.324,0.324,0.324,1),
		half4(0.232,0.232,0.232,0),
		half4(0.0855,0.0855,0.0855,0),
		half4(0.0205,0.0205,0.0205,0) };
	fixed4 frag(v2f IN) : SV_Target
	{
		half4 nor = tex2D(_NormalTex, IN.texcoord * 4);	
		half4 nor2 = tex2D(_NormalTex, IN.texcoord * 8);
		half4 nor3 = tex2D(_NormalTex, IN.texcoord * 12);


		half4 norcolor1 = tex2D(_GrabTexture, IN.texcoord + (4 * _GrabTexture_TexelSize * nor.xy));
		half4 norcolor2 = tex2D(_GrabTexture, IN.texcoord - (4 * _GrabTexture_TexelSize * nor.yz));
		half4 norcolor3 = tex2D(_GrabTexture, IN.texcoord + (4 * _GrabTexture_TexelSize * nor.zx));
		half4 norcolor21 = tex2D(_GrabTexture, IN.texcoord - (4 * _GrabTexture_TexelSize * nor2.xy));
		half4 norcolor22 = tex2D(_GrabTexture, IN.texcoord + (4 * _GrabTexture_TexelSize * nor2.yz));
		half4 norcolor23 = tex2D(_GrabTexture, IN.texcoord - (4 * _GrabTexture_TexelSize * nor2.zx));
		half4 norcolor31 = tex2D(_GrabTexture, IN.texcoord + (4 * _GrabTexture_TexelSize * nor3.xy));
		half4 norcolor32 = tex2D(_GrabTexture, IN.texcoord - (4 * _GrabTexture_TexelSize * nor3.yz));
		half4 norcolor33 = tex2D(_GrabTexture, IN.texcoord + (4 * _GrabTexture_TexelSize * nor3.zx));
		half4 color = (norcolor1 + norcolor2 + norcolor3
					 + norcolor21 + norcolor22 + norcolor23
					 + norcolor31 + norcolor32 + norcolor33) / 9;
			
		return color;
	}
		ENDCG
	}
	}
}
