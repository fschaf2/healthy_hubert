using Godot;
using System;

public partial class MainGame : Node2D
{
    public override void _Ready()
    {
        Input.SetMouseMode(Input.MouseModeEnum.Hidden);
    }
}
