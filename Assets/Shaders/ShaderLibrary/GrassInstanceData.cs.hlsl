//
// This file was automatically generated. Please don't edit by hand. Execute Editor command [ Edit > Rendering > Generate Shader Includes ] instead
//

#ifndef GRASSINSTANCEDATA_CS_HLSL
#define GRASSINSTANCEDATA_CS_HLSL
// Generated from GrassInstanceData
// PackingRules = Exact
struct GrassInstanceData
{
    float3 position;
    float lod;
};

//
// Accessors for GrassInstanceData
//
float3 GetPosition(GrassInstanceData value)
{
    return value.position;
}
float GetLod(GrassInstanceData value)
{
    return value.lod;
}

#endif
