using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class GrassVertexBuffer
{
    public ComputeBuffer VertexBuffer { get { return m_VertexDataBuffer; } }

    private ComputeBuffer m_VertexDataBuffer;
}
