    local success, result = pcall(function()
        -- Get both anticheat scripts with error handling
        local AC1, AC2
        repeat
            AC1 = LocalPlayer.PlayerScripts:FindFirstChild("LocalScript")
            AC2 = LocalPlayer.PlayerScripts:FindFirstChild("LocalScript2")
            task.wait()
        until AC1 and AC2
        
        -- Multiple hook layers for kick function
        local MainKickFunction = getsenv(AC1).kick
        local OldKick = hookfunction(MainKickFunction, function() return task.wait(9e9) end)
        hookfunction(OldKick, function() return task.wait(9e9) end)
        
        -- Comprehensive connection disabling
        for _, Script in pairs({AC1, AC2}) do
            for _, Event in pairs({"Changed", "ChildAdded", "DescendantAdded"}) do
                for _, Connection in pairs(getconnections(Script[Event])) do
                    Connection:Disable()
                end
            end
        end
        
        -- Enhanced value spoofing
        local mt = getrawmetatable(game)
        local old = mt.__index
        setreadonly(mt, false)
        
        mt.__index = newcclosure(function(self, k)
            local spoofedValues = {
                JumpPower = 50,
                HipHeight = 2,
                Gravity = 146,
                WalkSpeed = 16,
                Health = 100
            }
            if spoofedValues[k] then return spoofedValues[k] end
            return old(self, k)
        end)
        
        -- Advanced remote handling
        for _, remote in pairs({"lag", "kick", "ban"}) do
            local remoteEvent = game:GetService("ReplicatedStorage"):FindFirstChild(remote)
            if remoteEvent then
                for _, conn in pairs(getconnections(remoteEvent.OnClientEvent)) do
                    conn:Disable()
                end
                remoteEvent.OnClientEvent:Connect(function() return end)
            end
        end
        
        -- Protect against script reloading
        game:GetService("RunService").Heartbeat:Connect(function()
            if not AC1 or not AC2 or AC1.Disabled or AC2.Disabled then
                SecureAnticheat()
            end
        end)
    end)

    if success then
        print("Enhanced anticheat security enabled!")
    else
        warn("Security initialization error:", result)
        task.wait(1)
        SecureAnticheat()
    end
