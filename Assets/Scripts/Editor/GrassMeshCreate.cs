using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class GrassMeshCreate
{
    [MenuItem("GrassManager/Create Grass Test Mesh")]
    public static void CreateGrassMesh()
    {
        Mesh grassMesh = GetHighLodGrassMesh();
        AssetDatabase.CreateAsset(grassMesh, "Assets/grassMesh.mesh");
    }

    // 0---2---4\
    // | / | / | 6
    // 1---3---5/
    public static Mesh GetHighLodGrassMesh()
    {
        Mesh grassMesh = new Mesh();

        List<Vector3> positions = new List<Vector3>(7);
        const float height = 0.2f;
        const float halfWidth = 0.005f;

        for (int i = 0; i < 7; i++)
        {
            int step = i / 2;
            float signWidth = halfWidth * ((i % 2) == 0 ? -1.0f : 1.0f);
            Vector3 vertPos = new Vector3(i == 6 ? 0 : signWidth, step * height / (7 / 2), 0.0f);
            positions.Add(vertPos);
        }
        grassMesh.SetVertices(positions, 0, 7);


        List<int> indices = new List<int>(15)
        {
            1,0,2,1,2,3,3,2,4,3,4,5,5,4,6
        };
        grassMesh.SetIndices(indices, MeshTopology.Triangles, 0);
        grassMesh.RecalculateNormals();
        grassMesh.RecalculateBounds();

        return grassMesh;
    }
}
