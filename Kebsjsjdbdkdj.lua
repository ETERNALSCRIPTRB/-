local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local p = Players.LocalPlayer

p.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    hum.Died:Connect(function()
        print("💀 AKAZA LOCAL CINEMA ATIVADO! (Outros veem normal, tu vê épico)")
        
        
        local camera = workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Scriptable
        local startCFrame = camera.CFrame
        local cfTarget = hrp.CFrame * CFrame.new(10, 8, 20) -- Ângulo Akaza
        local connection
        connection = RunService.RenderStepped:Connect(function(dt)
            if hrp and hrp.Parent then
                cfTarget = cfTarget:Lerp(hrp.CFrame * CFrame.new(math.sin(tick()*3)*12, 6, 18), 0.02) -- Shake lento
                camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(cfTarget.Position, hrp.Position + Vector3.new(0,2,0)), 0.04) -- Super slow mo
            else
                connection:Disconnect()
            end
        end)
        
        -- DETACH CABEÇA + VOO SLOW MO (local physics)
        local head = char:FindFirstChild("Head")
        if head then
            local neck = char:FindFirstChild("Neck", true)
            if neck then neck:Destroy() end
            head.CanCollide = true
            local bvHead = Instance.new("BodyVelocity", head)
            bvHead.MaxForce = Vector3.new(4000,4000,4000)
            bvHead.Velocity = hrp.CFrame.LookVector * 25 + Vector3.new(math.random(-15,15), 50, math.random(-15,15))
            bvHead.Parent = head
            
            -- Tween quart 5s (gira louco)
            TweenService:Create(bvHead, TweenInfo.new(5, Enum.EasingStyle.Quart), {Velocity = bvHead.Velocity * 2}):Play()
            TweenService:Create(head, TweenInfo.new(5, Enum.EasingStyle.Quart), {CFrame = head.CFrame * CFrame.new(0, 80, -100) * CFrame.Angles(math.rad(1080), math.rad(360), math.rad(180))}):Play()
            
            -- SANGUE PARTICULAS (local glow)
            local attach = Instance.new("Attachment", head)
            local particles = Instance.new("ParticleEmitter", attach)
            particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
            particles.Color = ColorSequence.new(Color3.new(1,0,0)) -- Vermelho sangue
            particles.Lifetime = NumberRange.new(1,2)
            particles.Rate = 100
            particles.SpreadAngle = Vector2.new(45,45)
            particles:Start()
            game.Debris:AddItem(particles, 5)
        end
        
        -- HEADLESS RAGDOLL + "LUTA" FAKE (tween limbs socando)
        for _, limb in pairs(char:GetChildren()) do
            if limb:IsA("BasePart") and limb.Name ~= "Head" then
                limb.CanCollide = false
                TweenService:Create(limb, TweenInfo.new(3, Enum.EasingStyle.Bounce), {CFrame = limb.CFrame * CFrame.Angles(math.rad(90), math.rad(180), 0)}):Play() -- Socos fake
            end
        end
        
        -- SOM ÉPICO AKAZA (exploit safe)
        local deathSound = Instance.new("Sound", hrp)
        deathSound.SoundId = "rbxassetid://131961136" -- Som de corte/explosão (Akaza style)
        deathSound.Volume = 0.5
        deathSound:Play()
        
        -- EXPLODE LOCAL (partículas + fling)
        wait(6)
        local explosion = Instance.new("Explosion")
        explosion.Position = hrp.Position
        explosion.BlastRadius = 60
        explosion.BlastPressure = 0 -- Sem dano real
        explosion.Parent = workspace
        
        -- FLING PARTS (ragdoll custom)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part:BreakJoints()
                local bv = Instance.new("BodyVelocity", part)
                bv.MaxForce = Vector3.new(1e5,1e5,1e5)
                bv.Velocity = Vector3.new(math.random(-300,300), math.random(200,600), math.random(-300,300))
                bv.Parent = part
                game.Debris:AddItem(bv, 4)
            end
        end
        
        -- VOLTA CAMERA NORMAL
        wait(5)
        camera.CameraType = Enum.CameraType.Custom
        connection:Disconnect()
        game.Debris:AddItem(deathSound, 2)
        
        print("💥 AKAZA LOCAL COMPLETE! Cabeça voou, explodiu, cinema feito kkk")
    end)
end)

print("Akaza Local Death Mod 2025 carregado! Morre pra ver o show solo (replica impossível sem server inject) 🔥")
