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
    float hash;
};

//
// Accessors for GrassInstanceData
//
float3 GetPosition(GrassInstanceData value)
{
    return value.position;
}
float GetHash(GrassInstanceData value)
{
    return value.hash;
}

#endif
