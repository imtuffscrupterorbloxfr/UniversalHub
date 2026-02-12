-- AMARKINGS Anti-Cheat (Server-Side)
-- Place in ServerScriptService

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- SETTINGS
local MAX_WALKSPEED = 20
local MAX_JUMPPOWER = 60
local MAX_TELEPORT_DISTANCE = 100 -- studs per check
local CHECK_INTERVAL = 1

-- Store last positions
local playerData = {}

local function setupPlayer(player)
	player.CharacterAdded:Connect(function(character)

		local humanoid = character:WaitForChild("Humanoid")
		local hrp = character:WaitForChild("HumanoidRootPart")

		playerData[player] = {
			LastPosition = hrp.Position
		}

		-- Detect WalkSpeed changes
		humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			if humanoid.WalkSpeed > MAX_WALKSPEED then
				warn(player.Name .. " tried to change WalkSpeed.")
				humanoid.WalkSpeed = 16
			end
		end)

		-- Detect JumpPower changes
		humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
			if humanoid.JumpPower > MAX_JUMPPOWER then
				warn(player.Name .. " tried to change JumpPower.")
				humanoid.JumpPower = 50
			end
		end)

		-- Detect health tampering
		humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			if humanoid.Health > humanoid.MaxHealth then
				warn(player.Name .. " tried to modify health.")
				humanoid.Health = humanoid.MaxHealth
			end
		end)

		-- Detect BodyMovers (fly hacks)
		RunService.Heartbeat:Connect(function()
			if character:FindFirstChildOfClass("BodyVelocity") or
			   character:FindFirstChildOfClass("BodyGyro") then
				warn(player.Name .. " possible fly exploit detected.")
				player:Kick("Fly exploits are not allowed.")
			end
		end)
	end)
end

-- Teleport check loop
task.spawn(function()
	while true do
		task.wait(CHECK_INTERVAL)

		for _, player in pairs(Players:GetPlayers()) do
			local character = player.Character
			if character and character:FindFirstChild("HumanoidRootPart") then

				local hrp = character.HumanoidRootPart
				local data = playerData[player]

				if data then
					local distance = (hrp.Position - data.LastPosition).Magnitude

					if distance > MAX_TELEPORT_DISTANCE then
						warn(player.Name .. " teleported too far.")
						player:Kick("Teleport exploit detected.")
					end

					data.LastPosition = hrp.Position
				end
			end
		end
	end
end)

Players.PlayerAdded:Connect(setupPlayer)

Players.PlayerRemoving:Connect(function(player)
	playerData[player] = nil
end)
  -- AMARKINGS UI: UPGRADED SURGERY EDITION
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Key system
local KEY = "amarkings123"

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "AmarkingsKey"

local keyBox = Instance.new("TextBox", screenGui)
keyBox.Size = UDim2.new(0,200,0,40)
keyBox.Position = UDim2.new(0.5,-100,0.5,-20)
keyBox.PlaceholderText = "Enter Admin Key"
keyBox.TextScaled = true

local submitBtn = Instance.new("TextButton", screenGui)
submitBtn.Size = UDim2.new(0,200,0,40)
submitBtn.Position = UDim2.new(0.5,-100,0.5,30)
submitBtn.Text = "Submit"
submitBtn.TextScaled = true

submitBtn.MouseButton1Click:Connect(function()
	if keyBox.Text == KEY then
		screenGui:Destroy()
	else
		keyBox.Text = ""
		keyBox.PlaceholderText = "Wrong Key!"
	end
end)

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.Name = "AmarkingsUI"
gui.ResetOnSpawn = false

-- Menu Icon
local iconBtn = Instance.new("ImageButton", gui)
iconBtn.Size = UDim2.new(0,50,0,50)
iconBtn.Position = UDim2.new(0,20,0,20)
iconBtn.Image = "rbxassetid://6031075938"
iconBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", iconBtn)

-- Box Menu
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,250,0,400)
frame.Position = UDim2.new(0,20,0,80)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Visible = false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

iconBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "AMARKINGS UI"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

-- Helpers
local function getChar() return player.Character or player.CharacterAdded:Wait() end
local function getHum() return getChar():WaitForChild("Humanoid") end
local function getHRP() return getChar():WaitForChild("HumanoidRootPart") end

local function makeButton(text,pos)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9,0,0,35)
	b.Position = UDim2.new(0.05,0,0,pos)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.TextScaled = true
	b.Text = text
	Instance.new("UICorner", b)
	return b
end

local function makeBox(placeholder,pos)
	local b = Instance.new("TextBox", frame)
	b.Size = UDim2.new(0.9,0,0,30)
	b.Position = UDim2.new(0.05,0,0,pos)
	b.PlaceholderText = placeholder
	b.Text = ""
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Instance.new("UICorner", b)
	return b
end

-- FEATURE VARIABLES
local y=40
local flyBtn = makeButton("Fly: OFF",y); y=y+40
local speedBox = makeBox("WalkSpeed (Default 16)",y); y=y+35
local speedBtn = makeButton("Set Speed",y); y=y+40
local godBtn = makeButton("Godmode: OFF",y); y=y+40
local tpBtn = makeButton("Click TP: OFF",y); y=y+40
local jumpBox = makeBox("JumpPower (Default 50)",y); y=y+35
local jumpBtn = makeButton("Set Jump",y); y=y+40
local npcBox = makeBox("NPC Name for Auto-Fight",y); y=y+35
local autoFightBtn = makeButton("Auto-Fight: OFF",y); y=y+40
local itemBox = makeBox("Item Name",y); y=y+35
local itemBtn = makeButton("Find Item",y); y=y+40

-- Fly Logic (only when moving)
local flying=false
local bv, bg
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = flying and "Fly: ON" or "Fly: OFF"
	local hrp = getHRP()
	if flying then
		bv = Instance.new("BodyVelocity",hrp)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bv.Velocity = Vector3.new(0,0,0)
		bg = Instance.new("BodyGyro",hrp)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
		bg.CFrame = hrp.CFrame
		RunService.RenderStepped:Connect(function()
			if flying then
				local move = Vector3.new(0,0,0)
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
				bv.Velocity = move*60
				bg.CFrame = workspace.CurrentCamera.CFrame
			end
		end)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

-- Speed
speedBtn.MouseButton1Click:Connect(function()
	local num=tonumber(speedBox.Text)
	if num then getHum().WalkSpeed=num end
end)

-- Godmode
local godOn=false
godBtn.MouseButton1Click:Connect(function()
	godOn = not godOn
	godBtn.Text = godOn and "Godmode: ON" or "Godmode: OFF"
end)
RunService.Heartbeat:Connect(function()
	if godOn then
		local hum = getHum()
		if hum then hum.Health=hum.MaxHealth end
	end
end)

-- Click TP
local tpOn=false
tpBtn.MouseButton1Click:Connect(function()
	tpOn = not tpOn
	tpBtn.Text = tpOn and "Click TP: ON" or "Click TP: OFF"
end)
UserInputService.InputBegan:Connect(function(input,gp)
	if tpOn and input.UserInputType==Enum.UserInputType.MouseButton1 and not gp then
		local mouse=player:GetMouse()
		if mouse.Hit then getChar():MoveTo(mouse.Hit.Position) end
	end
end)

-- JumpPower
jumpBtn.MouseButton1Click:Connect(function()
	local num=tonumber(jumpBox.Text)
	if num then getHum().JumpPower=num end
end)

-- Auto-Fight
local fighting=false
autoFightBtn.MouseButton1Click:Connect(function()
	fighting = not fighting
	autoFightBtn.Text = fighting and "Auto-Fight: ON" or "OFF"
	if fighting then
		task.spawn(function()
			while fighting do
				task.wait(0.3)
				local hrp=getHRP()
				local tool=getChar():FindFirstChildOfClass("Tool")
				if not tool then
					for _,t in pairs(player.Backpack:GetChildren()) do
						if t:IsA("Tool") then
							getHum():EquipTool(t)
							tool=t
							break
						end
					end
				end
				local closest=nil
				local shortest=math.huge
				for _,npc in pairs(workspace:GetDescendants()) do
					if npc:IsA("Model") and npc~=getChar() and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
						if npc.Name:lower():find(npcBox.Text:lower()) then
							local dist=(hrp.Position-npc.HumanoidRootPart.Position).Magnitude
							if dist<shortest then shortest=dist closest=npc end
						end
					end
				end
				if closest then
					hrp.CFrame=closest.HumanoidRootPart.CFrame*CFrame.new(0,0,-3)
					if tool then tool:Activate() end
				end
			end
		end)
	end
end)

-- Item Finder
itemBtn.MouseButton1Click:Connect(function()
	local name=itemBox.Text:lower()
	local found=nil
	for _,obj in pairs(workspace:GetDescendants()) do
		if (obj:IsA("Tool") or obj:IsA("Part") or obj:IsA("Model")) and obj.Name:lower():find(name) then
			found=obj break
		end
	end
	if found then
		local hrp=getHRP()
		hrp.CFrame=found:IsA("Model") and found:GetPrimaryPartCFrame() or found.CFrame+Vector3.new(0,3,0)
		print("Teleported to item:",found.Name)
	else
		print("Item not found")
	end
end)
