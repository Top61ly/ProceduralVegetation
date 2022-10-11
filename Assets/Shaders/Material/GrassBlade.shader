// This shader fills the mesh shape with a color predefined in the code.
Shader "Example/GrassBlade"
{
	Properties
	{ }

	SubShader
	{		
		Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

		Pass
		{		
			HLSLPROGRAM
			
#pragma enable_d3d11_debug_symbols

			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag
			
			#pragma multi_compile_instancing
			#pragma instancing_options procedural:setup 
			
			void setup()
			{

			}
						
			#include "GrassBladeLitData.hlsl"

			ENDHLSL
		}
	}
}