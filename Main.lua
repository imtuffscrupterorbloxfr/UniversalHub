
local event = Instance.new("RemoteEvent")
event.Name = "DevAbilityEvent"
event.Parent = game.ReplicatedStorage

local DEV_ID = 123456789 -- PUT YOUR USERID HERE

local invinciblePlayers = {}
local noclipPlayers = {}

local function isDev(player)
	return player.UserId == DEV_ID
end

event.OnServerEvent:Connect(function(player, action)

	if not isDev(player) then
		player:Kick("Unauthorized dev ability usage.")
		return
	end

	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChild("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end

	-- SPEED BOOST
	if action == "SPEED" then
		hum.WalkSpeed = 50
		task.delay(5, function()
			if hum then hum.WalkSpeed = 16 end
		end)
	end

	-- GOD MODE
	if action == "GOD" then
		invinciblePlayers[player] = not invinciblePlayers[player]
	end

	-- NOCLIP
	if action == "NOCLIP" then
		noclipPlayers[player] = not noclipPlayers[player]
	end

	-- SUPER SLAM
	if action == "SLAM" then
		hrp.Velocity = Vector3.new(0,100,0)
		task.wait(0.6)
		hrp.Velocity = Vector3.new(0,-200,0)
		task.wait(0.3)

		for _, npc in pairs(workspace:GetDescendants()) do
			if npc:IsA("Model") and npc ~= char then
				local nh = npc:FindFirstChild("Humanoid")
				local root = npc:FindFirstChild("HumanoidRootPart")
				if nh and root and nh.Health > 0 then
					if (hrp.Position - root.Position).Magnitude < 20 then
						nh:TakeDamage(50)
					end
				end
			end
		end
	end
end)

-- GODMODE LOOP
game:GetService("RunService").Heartbeat:Connect(function()
	for player,_ in pairs(invinciblePlayers) do
		if player.Character then
			local hum = player.Character:FindFirstChild("Humanoid")
			if hum then
				hum.Health = hum.MaxHealth
			end
		end
	end
end)

-- NOCLIP LOOP
game:GetService("RunService").Stepped:Connect(function()
	for player,_ in pairs(noclipPlayers) do
		if player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)
