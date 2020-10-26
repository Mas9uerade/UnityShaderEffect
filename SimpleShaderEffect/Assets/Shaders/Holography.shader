// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Holography"
{
	Properties
	{
		_MainTex("Sprite Texture", 2D) = "white" {}
		_Color("Color", Color) = (1.0000, 1.0000, 1.0000, 1.0000)
	}
		SubShader
		{
			Tags
			{
				"RenderType" = "Transparent"
			}


			ZWrite Off
			Cull Off
			Blend One One

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
	

				#include "UnityCG.cginc"
				#include "UnityUI.cginc"

				struct appdata
				{
					float4 vertex   : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float4 vertex   : SV_POSITION;
					half2 uv  : TEXCOORD0;
				};

				sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform float4 _Color;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = tex2D(_MainTex, i.uv) * _Color;
					col.rgb *= col.a * _Color.a;
					return col;
				}
				ENDCG
			}
		}
}
