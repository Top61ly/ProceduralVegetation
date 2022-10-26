// This shader fills the mesh shape with a color predefined in the code.
Shader "Example/GrassBlade"
{
	Properties
	{ }

	SubShader
	{		
		Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "UniversalMaterialType" = "Lit" "IgnoreProjector" = "True" "ShaderModel"="4.5"}

		Pass
		{		
			Name "ForwardLit"
			Tags { "LightMode" = "UniversalForward" }
			HLSLPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			// -------------------------------------
            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            #pragma multi_compile_fragment _ _LIGHT_LAYERS
            #pragma multi_compile_fragment _ _LIGHT_COOKIES
            #pragma multi_compile _ _FORWARD_PLUS
            #pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma multi_compile_fragment _ DEBUG_DISPLAY
			#pragma multi_compile_instancing
			#pragma instancing_options procedural:setup norenderinglayer assumeuniformscaling nomatrices nolightprobe nolightmap
						
			#include "GrassBladeLitData.hlsl"

			ENDHLSL
		}

		Pass
		{
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }

			ZWrite On
			ColorMask 0
			HLSLPROGRAM
			#pragma target 2.0
			
			#pragma vertex ShadowVert
			#pragma fragment ShadowFrag

			#pragma multi_compile_instancing
			#pragma instancing_options procedural:setup norenderinglayer assumeuniformscaling nomatrices nolightprobe nolightmap

			// -------------------------------------
            // Universal Pipeline keywords

            // This is used during shadow map generation to differentiate between directional and punctual light shadows, as they use different formulas to apply Normal Bias
            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
			#include "GrassBladeLitData.hlsl"

			ENDHLSL
		}
	}
}