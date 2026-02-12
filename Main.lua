local event = Instance.new("RemoteEvent")
event.Name = "DevAbilityEvent"
event.Parent = game.ReplicatedStorage

local DEV_ID = 123456789 -- PUT YOUR USERID HERE

local RunService = game:GetService("RunService")

local invincible = {}
local flying = {}
local flyData = {}

local function isDev(player)
	return player.UserId == DEV_ID
end

local function getCharData(player)
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChild("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end
	return char, hum, hrp
end

-- CLEANUP ON LEAVE
game.Players.PlayerRemoving:Connect(function(player)
	invincible[player] = nil
	flying[player] = nil
	flyData[player] = nil
end)

event.OnServerEvent:Connect(function(player, action, value)

	if not isDev(player) then
		player:Kick("Unauthorized dev ability usage.")
		return
	end

	local char, hum, hrp = getCharData(player)
	if not char then return end

	--------------------------------------------------
	-- CUSTOM SPEED
	--------------------------------------------------
	if action == "SETSPEED" then
		if typeof(value) == "number" then
			hum.WalkSpeed = math.clamp(value, 0, 200)
		end
	end

	--------------------------------------------------
	-- CUSTOM JUMP
	--------------------------------------------------
	if action == "SETJUMP" then
		if typeof(value) == "number" then
			hum.JumpPower = math.clamp(value, 0, 300)
		end
	end

	--------------------------------------------------
	-- GODMODE TOGGLE
	--------------------------------------------------
	if action == "GOD" then
		invincible[player] = not invincible[player]
	end

	--------------------------------------------------
	-- FLY TOGGLE (Modern Constraints)
	--------------------------------------------------
	if action == "FLY" then
		flying[player] = not flying[player]

		if flying[player] then
			local attachment = Instance.new("Attachment", hrp)

			local linear = Instance.new("LinearVelocity")
			linear.Attachment0 = attachment
			linear.MaxForce = 100000
			linear.VectorVelocity = Vector3.new(0,0,0)
			linear.Parent = hrp

			local align = Instance.new("AlignOrientation")
			align.Attachment0 = attachment
			align.MaxTorque = 100000
			align.Responsiveness = 20
			align.Parent = hrp

			flyData[player] = {attachment = attachment, linear = linear, align = align}

		else
			if flyData[player] then
				for _,v in pairs(flyData[player]) do
					v:Destroy()
				end
				flyData[player] = nil
			end
		end
	end

	--------------------------------------------------
	-- SUPER SLAM (Improved Radius + Knockback)
	--------------------------------------------------
	if action == "SLAM" then
		hrp.AssemblyLinearVelocity = Vector3.new(0,120,0)
		task.wait(0.6)
		hrp.AssemblyLinearVelocity = Vector3.new(0,-250,0)
		task.wait(0.3)

		for _, model in pairs(workspace:GetDescendants()) do
			if model:IsA("Model") and model ~= char then
				local nh = model:FindFirstChild("Humanoid")
				local root = model:FindFirstChild("HumanoidRootPart")
				if nh and root and nh.Health > 0 then
					local dist = (hrp.Position - root.Position).Magnitude
					if dist < 30 then
						nh:TakeDamage(60)
						root.AssemblyLinearVelocity =
							(root.Position - hrp.Position).Unit * 80 + Vector3.new(0,40,0)
					end
				end
			end
		end
	end

	--------------------------------------------------
	-- LIGHTNING STRIKE
	--------------------------------------------------
	if action == "LIGHTNING" then
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false
		part.Material = Enum.Material.Neon
		part.BrickColor = BrickColor.new("Electric blue")
		part.Size = Vector3.new(2,50,2)
		part.Position = hrp.Position + Vector3.new(0,25,0)
		part.Parent = workspace

		game.Debris:AddItem(part,0.3)

		for _, model in pairs(workspace:GetDescendants()) do
			if model:IsA("Model") then
				local nh = model:FindFirstChild("Humanoid")
				local root = model:FindFirstChild("HumanoidRootPart")
				if nh and root then
					if (root.Position - hrp.Position).Magnitude < 15 then
						nh:TakeDamage(75)
					end
				end
			end
		end
	end
end)

--------------------------------------------------
-- GODMODE LOOP
--------------------------------------------------
RunService.Heartbeat:Connect(function()
	for player,_ in pairs(invincible) do
		if player.Character then
			local hum = player.Character:FindFirstChild("Humanoid")
			if hum then
				hum.Health = hum.MaxHealth
			end
		end
	end
end)
