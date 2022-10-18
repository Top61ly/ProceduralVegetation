//
// This file was automatically generated. Please don't edit by hand. Execute Editor command [ Edit > Rendering > Generate Shader Includes ] instead
//

#ifndef GRASSVERTEXDATA_CS_HLSL
#define GRASSVERTEXDATA_CS_HLSL
// Generated from GrassVertexData
// PackingRules = Exact
struct GrassVertexData
{
    float3 position;
    float hash;
};

//
// Accessors for GrassVertexData
//
float3 GetPosition(GrassVertexData value)
{
    return value.position;
}
float GetHash(GrassVertexData value)
{
    return value.hash;
}

#endif
