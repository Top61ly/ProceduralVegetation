#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

#include "../ShaderLibrary/GrassInstanceData.cs.hlsl"
#include "../ShaderLibrary/HaltonSequence.hlsl"

StructuredBuffer<GrassInstanceData> GrassInstanceDataBuffer;

struct Attributes
{
    uint instanceID : SV_InstanceID;
};

struct Varyings
{
    float4 positionOS : POSITION;
    uint instanceID : SV_InstanceID;
};

struct GeometryToFrag
{
    float4 positionHCS : SV_POSITION;
};
					
Varyings vert(Attributes input)
{
    Varyings output = (Varyings) 0;
            
    GrassInstanceData data = GrassInstanceDataBuffer[input.instanceID];
    float3 pos = data.position;
    
    output.positionOS = float4(pos, 1);
    
    return output;
}

GeometryToFrag CreateGeomOutput(float3 posOS)
{
    GeometryToFrag output = (GeometryToFrag) 0;
    
    VertexPositionInputs vertexPostion = GetVertexPositionInputs(posOS);
        
    output.positionHCS = vertexPostion.positionCS;
    return output;
}

//High Lod, vertex count15
// 14
//12-13
//10-11
// 8-9
// 6-7
// 4-5
// 2-3
// 0-1

[maxvertexcount(30)]
void geom(point Varyings points[1], inout TriangleStream<GeometryToFrag> triStream)
{
    Varyings input = points[0];
    
    float3 rootPos = input.positionOS;
    
    const int k_VertexCount = 12;
    float height = 1.0f;
    float width = 0.5f;
    
    GeometryToFrag g2fs[k_VertexCount] =
    {
        (GeometryToFrag) 0, (GeometryToFrag) 0, (GeometryToFrag) 0, (GeometryToFrag) 0,
        (GeometryToFrag) 0, (GeometryToFrag) 0, (GeometryToFrag) 0, (GeometryToFrag) 0,
        (GeometryToFrag) 0, (GeometryToFrag) 0, (GeometryToFrag) 0, (GeometryToFrag) 0,
    };
    
    for (int i = 0; i < k_VertexCount; i++)
    {
        int step = i / 2;
        float signWidth = width * (fmod(i, 2) == 0 ? -1 : 1);
        
        float3 offset = float3(signWidth, step * height / (k_VertexCount / 2), 0);
        g2fs[i] = CreateGeomOutput(rootPos + offset);
    }
    
    for (int p = 0; p < (k_VertexCount - 2); p++)
    {
        triStream.Append(g2fs[p]);
        triStream.Append(g2fs[p + 2]);
        triStream.Append(g2fs[p + 1]);
    }
}

half4 frag() : SV_Target
{
    half4 customColor = half4(0.5, 0, 0, 1);
    return customColor;
}