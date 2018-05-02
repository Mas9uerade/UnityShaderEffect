Shader "Custom/GrayscaleEffect" {
	SubShader
	{
		// Draw ourselves after all opaque geometry
		Tags{ "Queue" = "Transparent" }

		// Grab the screen behind the object into _BackgroundTexture
		GrabPass
	{
		"_BackgroundTexture"
	}

		// Render the object with the texture generated above, and invert the colors
		Pass
	{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

		struct v2f
	{
		float4 grabPos : TEXCOORD0;
		float4 pos : SV_POSITION;
	};

	v2f vert(appdata_base v) {
		v2f o;
		// use UnityObjectToClipPos from UnityCG.cginc to calculate 
		// the clip-space of the vertex
		o.pos = UnityObjectToClipPos(v.vertex);
		// use ComputeGrabScreenPos function from UnityCG.cginc
		// to get the correct texture coordinate
		o.grabPos = ComputeGrabScreenPos(o.pos);
		return o;
	}

	sampler2D _BackgroundTexture;
	uniform half4 _BackgroundTexture_TexelSize;
	half4 frag(v2f i) : SV_Target
	{
		half4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabPos);

		float gray = dot(bgcolor.rgb, float3(0.299, 0.587, 0.114));
		bgcolor = (gray, gray, gray);

		return bgcolor;

	}
		ENDCG
	}

	}
}