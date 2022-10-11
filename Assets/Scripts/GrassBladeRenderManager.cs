using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using System.Runtime.InteropServices;


public class GrassBladeRenderManager : MonoBehaviour
{
    [SerializeField] private Mesh m_TestMesh;
    [SerializeField] private Material m_Material;
    [SerializeField] private ComputeShader m_GrassGenerateCS;
    private ComputeBuffer m_InstanceBuffer;
    private ComputeBuffer m_IndirectBuffer;
    private CommandBuffer m_Cmd;

    private const string k_CommandBufferName = "Grass Blade Instance";

    private const string k_GenrateGrassBladeKernelName = "GenerateGrassBlade";
    private int m_GenerateGrassBladeKernel = -1;

    private const string k_InitIndirectKernelName = "InitInidrect";
    private int m_InitIndirectKernel = -1;

    private int RWIndirectBufferName = Shader.PropertyToID("RWIndirectArgsBuffer");
    private int RWGrassInstanceDataBufferName = Shader.PropertyToID("RWGrassInstanceDataBuffer");
    private int GrassInstanceDataBufferName = Shader.PropertyToID("GrassInstanceDataBuffer");

    private void OnEnable()
    {
        m_Cmd = CommandBufferPool.Get(k_CommandBufferName);
        m_InstanceBuffer = new ComputeBuffer(10240, Marshal.SizeOf(typeof(GrassInstanceData)), ComputeBufferType.Default);
        m_IndirectBuffer = new ComputeBuffer(5, 4, ComputeBufferType.IndirectArguments);

        m_GenerateGrassBladeKernel = m_GrassGenerateCS.FindKernel(k_GenrateGrassBladeKernelName);
        m_InitIndirectKernel = m_GrassGenerateCS.FindKernel(k_InitIndirectKernelName);

        uint[] data = { 0, 0, 0, 0, 0 };
        data[0] = 1;
        data[1] = 0;
        data[2] = 0;
        data[3] = 0;        

        m_IndirectBuffer.SetData(data);

        m_Material.SetBuffer(GrassInstanceDataBufferName, m_InstanceBuffer);
    }

    private void Update()
    {
        m_Cmd.Clear();
        InitPass(m_Cmd);
        GenerateInstanceDataPass(m_Cmd);
        Graphics.ExecuteCommandBuffer(m_Cmd);

        RenderGrassBlade();
    }

    void InitPass(CommandBuffer cmd)
    {
        m_Cmd.SetComputeBufferParam(m_GrassGenerateCS, m_InitIndirectKernel, RWIndirectBufferName, m_IndirectBuffer);
        m_Cmd.DispatchCompute(m_GrassGenerateCS, m_InitIndirectKernel, 1, 1, 1);
    }

    void GenerateInstanceDataPass(CommandBuffer cmd)
    {
        cmd.SetComputeBufferParam(m_GrassGenerateCS, m_GenerateGrassBladeKernel, RWIndirectBufferName, m_IndirectBuffer);
        cmd.SetComputeBufferParam(m_GrassGenerateCS, m_GenerateGrassBladeKernel, RWGrassInstanceDataBufferName, m_InstanceBuffer);

        cmd.DispatchCompute(m_GrassGenerateCS, m_GenerateGrassBladeKernel, 1, 1, 1);
    }

    void RenderGrassBlade()
    {
        //Graphics.DrawMeshInstancedIndirect(m_TestMesh, 0, m_Material, new Bounds(Vector3.zero, Vector3.one * 10240), m_IndirectBuffer);
        Graphics.DrawProceduralIndirect(m_Material, new Bounds(Vector3.zero, Vector3.one * 10240), MeshTopology.Points, m_IndirectBuffer);
    }

    private void OnDisable()
    {
        m_InstanceBuffer?.Dispose();
        m_IndirectBuffer?.Dispose();
    }
}
