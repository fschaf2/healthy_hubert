using Godot;
using System;

public partial class Player : CharacterBody2D
{
    public const int MaxSpeed = 120;
    public const int XAcceleration = 10;
    public const int XDeceleration = 30;
    public const int XFriction = 10;
    public const int Gravity = 15;
    public const int JumpSpeed = 180;
    public const int MaxJumpFrames = 15;
    private int jumpFrames = 0;
    private Boolean bufferJump = false;
    public override void _PhysicsProcess(double delta)
    {
        Vector2 currentVelocity = Velocity;
        currentVelocity.Y += Gravity;
        currentVelocity=HandleXInput(currentVelocity, Input.GetAxis("Move_Left","Move_Right"));
        if (Input.IsActionJustPressed("ui_accept"))
        {
            if (IsOnFloor())
            {
                jumpFrames = MaxJumpFrames;
            }
            else if (Math.Sign(currentVelocity.Y) == 1)
            {
                bufferJump = true;
            }
        }

        if (bufferJump)
        {
            if (IsOnFloor())
            {
                bufferJump = false;
                jumpFrames = MaxJumpFrames;
            }
        }

        if (Input.IsActionJustReleased("ui_accept"))
        {
            jumpFrames = 0;
            bufferJump = false;
        }
        
        if (Input.IsActionPressed("ui_accept"))
        {
            if (jumpFrames > 0)
            {
                currentVelocity.Y = -JumpSpeed;
                jumpFrames -= 1;
                bufferJump = false;
            }
        }
        SetVelocity(currentVelocity);
        MoveAndSlide();
    }

  
    public Vector2 HandleXInput(Vector2 currentVelocity, float axis)
    {
        if (Math.Sign(axis) == Math.Sign(currentVelocity.X))
        {
            currentVelocity.X += XAcceleration*Math.Sign(currentVelocity.X);
        }
        else if (Math.Sign(axis) == Math.Sign(currentVelocity.X) * -1)
        {
            currentVelocity.X -= XDeceleration*Math.Sign(currentVelocity.X);
        }
        else if (currentVelocity.X == 0)
        {
            currentVelocity.X += XAcceleration*Math.Sign(axis);
        }
        else
        {
            if (Math.Sign(currentVelocity.X - XFriction * Math.Sign(currentVelocity.X)) == Math.Sign(currentVelocity.X))
            {
                currentVelocity.X -= XFriction*Math.Sign(currentVelocity.X);
            }
            else
            {
                currentVelocity.X = 0;
            }
        }
        currentVelocity.X=Mathf.Clamp(currentVelocity.X,-MaxSpeed,MaxSpeed);
        return currentVelocity;
    }
}