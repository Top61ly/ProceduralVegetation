using System;
using UnityEngine;
using UnityEngine.Rendering;

public class GrassBufferGenerator
{
    class GrassData
    {
        public GrassVertexData[] vertices;
    }

    public static void FillGrassBuffer(ComputeBuffer vertexBuffer, ComputeBuffer indexBuffer, int grassLod = 0, int vertextBufferOffset = 0, int indexBufferOffset = 0)
    {
        GrassData lod0Data = new GrassData();
        lod0Data.vertices = new GrassVertexData[14];
    }

    static void GenerateVertexData(GrassVertexData[] vertices, int lod)
    {

    }
}