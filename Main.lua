local event = game.ReplicatedStorage:WaitForChild("HubEvent")

local farmingPlayers = {}

local function getClosestNPC(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local closest
    local shortest = math.huge

    if workspace:FindFirstChild("NPCs") then
        for _, npc in pairs(workspace.NPCs:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                if npc.Humanoid.Health > 0 then
                    local dist = (hrp.Position - npc.HumanoidRootPart.Position).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = npc
                    end
                end
            end
        end
    end

    return closest
end

event.OnServerEvent:Connect(function(player, action, state)

    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    -- SPEED
    if action == "Speed" then
        humanoid.WalkSpeed = state and 50 or 16
    end

    -- JUMP
    if action == "Jump" then
        humanoid.JumpPower = state and 100 or 50
    end

    -- FARM
    if action == "Farm" then
        farmingPlayers[player] = state

        if state then
            task.spawn(function()
                while farmingPlayers[player] do
                    task.wait(0.4)

                    if not player.Character then break end
                    local npc = getClosestNPC(player.Character)

                    if npc then
                        humanoid:MoveTo(npc.HumanoidRootPart.Position)

                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                        end
                    end
                end
            end)
        end
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    farmingPlayers[player] = nil
end)
