#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"

#include "../ShaderLibrary/GrassInstanceData.cs.hlsl"
#include "../ShaderLibrary/HaltonSequence.hlsl"

// Setup function for unity instancing
void setup(){}

StructuredBuffer<GrassInstanceData> GrassInstanceDataBuffer;

struct Attributes
{
    float4 positionOS : POSITION;
    uint instanceID : SV_InstanceID;
};

struct Varyings
{
    float4 positionHCS : POSITION;
    uint instanceID : SV_InstanceID;
};
		
// Forward Lit Vert and Fragment
Varyings vert(Attributes input)
{
    Varyings output = (Varyings) 0;
            
    GrassInstanceData data = GrassInstanceDataBuffer[input.instanceID];
    float3 pos = data.position;
    
    VertexPositionInputs vertexPostion = GetVertexPositionInputs(pos + input.positionOS);

    output.positionHCS = vertexPostion.positionCS;
    
    return output;
}

half4 frag() : SV_Target
{
    half4 customColor = half4(0, 0.5f, 0, 1);
    return customColor;
}

// Shadow pass

// Shadow Casting Light geometric parameters. These variables are used when applying the shadow Normal Bias and are set by UnityEngine.Rendering.Universal.ShadowUtils.SetupShadowCasterConstantBuffer in com.unity.render-pipelines.universal/Runtime/ShadowUtils.cs
// For Directional lights, _LightDirection is used when applying shadow Normal Bias.
// For Spot lights and Point lights, _LightPosition is used to compute the actual light direction because it is different at each shadow caster geometry vertex.
float3 _LightDirection;
float3 _LightPosition;
Varyings ShadowVert(Attributes input)
{
    Varyings output = (Varyings) 0;
            
    GrassInstanceData data = GrassInstanceDataBuffer[input.instanceID];
    float3 positionWS = input.positionOS + data.position;
    float3 normalWS = float3(0,0,1);

#if _CASTING_PUNCTUAL_LIGHT_SHADOW
    float3 lightDirectionWS = normalize(_LightPosition - positionWS);
#else
    float3 lightDirectionWS = _LightDirection;
#endif
    float4 clipPos = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));

#if UNITY_REVERSED_Z
    clipPos.z = min(clipPos.z, UNITY_NEAR_CLIP_VALUE);
#else
    clipPos.z = max(clipPos.z, UNITY_NEAR_CLIP_VALUE);
#endif

    output.positionHCS = clipPos;

    return output;
}

float4 ShadowFrag(Varyings input) : SV_Target
{
    return 0;
}