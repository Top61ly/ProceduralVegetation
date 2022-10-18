#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

#include "../ShaderLibrary/GrassInstanceData.cs.hlsl"
#include "../ShaderLibrary/HaltonSequence.hlsl"

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