-- AMARKINGS ADMIN UI (LOCAL SCRIPT)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

--------------------------------------------------
-- 🔐 ADMIN KEY SETTINGS
--------------------------------------------------

local ADMIN_KEY = "AMARKINGS-ADMIN-2026" -- CHANGE THIS
local hasAccess = false

--------------------------------------------------
-- CHARACTER FUNCTIONS
--------------------------------------------------

local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHum()
	return getChar():WaitForChild("Humanoid")
end

local function getHRP()
	return getChar():WaitForChild("HumanoidRootPart")
end

--------------------------------------------------
-- UI
--------------------------------------------------

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AmarkingsUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,520)
frame.Position = UDim2.new(0.5,-150,0.5,-260)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "AMARKINGS ADMIN PANEL"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

--------------------------------------------------
-- 🔐 KEY SYSTEM UI
--------------------------------------------------

local keyBox = Instance.new("TextBox", frame)
keyBox.Size = UDim2.new(1,-20,0,40)
keyBox.Position = UDim2.new(0,10,0,60)
keyBox.PlaceholderText = "Enter Admin Key..."
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
keyBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBox)

local keyBtn = Instance.new("TextButton", frame)
keyBtn.Size = UDim2.new(1,-20,0,40)
keyBtn.Position = UDim2.new(0,10,0,110)
keyBtn.Text = "Unlock"
keyBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
keyBtn.TextColor3 = Color3.new(1,1,1)
keyBtn.Font = Enum.Font.GothamBold
keyBtn.TextScaled = true
Instance.new("UICorner", keyBtn)

--------------------------------------------------
-- FEATURE BUTTON MAKER
--------------------------------------------------

local function makeButton(text,y)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1,-20,0,40)
	btn.Position = UDim2.new(0,10,0,y)
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Text = text
	btn.Visible = false
	Instance.new("UICorner", btn)
	return btn
end

local function makeBox(placeholder,y)
	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(1,-20,0,35)
	box.Position = UDim2.new(0,10,0,y)
	box.PlaceholderText = placeholder
	box.Text = ""
	box.BackgroundColor3 = Color3.fromRGB(40,40,40)
	box.TextColor3 = Color3.new(1,1,1)
	box.Visible = false
	Instance.new("UICorner", box)
	return box
end

--------------------------------------------------
-- FEATURES (LOCKED BY DEFAULT)
--------------------------------------------------

local flyBtn = makeButton("Fly: OFF",170)
local speedBtn = makeButton("Speed: OFF",220)
local godBtn = makeButton("Godmode: OFF",270)
local tpBtn = makeButton("Click TP: OFF",320)
local hpBtn = makeButton("Show NPC HP: OFF",370)
local targetBox = makeBox("Enter NPC Name",420)
local autoFightBtn = makeButton("Auto-Fight: OFF",460)

--------------------------------------------------
-- 🔓 UNLOCK FUNCTION
--------------------------------------------------

local function unlockFeatures()
	hasAccess = true
	keyBox.Visible = false
	keyBtn.Visible = false

	flyBtn.Visible = true
	speedBtn.Visible = true
	godBtn.Visible = true
	tpBtn.Visible = true
	hpBtn.Visible = true
	targetBox.Visible = true
	autoFightBtn.Visible = true
end

keyBtn.MouseButton1Click:Connect(function()
	if keyBox.Text == ADMIN_KEY then
		keyBtn.Text = "ACCESS GRANTED"
		keyBtn.BackgroundColor3 = Color3.fromRGB(0,200,100)
		unlockFeatures()
	else
		keyBtn.Text = "WRONG KEY"
		keyBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
	end
end)

--------------------------------------------------
-- FLY
--------------------------------------------------

local flying = false
local bv

flyBtn.MouseButton1Click:Connect(function()
	if not hasAccess then return end
	flying = not flying
	flyBtn.Text = flying and "Fly: ON" or "Fly: OFF"

	local hrp = getHRP()

	if flying then
		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)

		RunService.RenderStepped:Connect(function()
			if flying and bv then
				bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
			end
		end)
	else
		if bv then bv:Destroy() end
	end
end)

--------------------------------------------------
-- SPEED
--------------------------------------------------

local speedOn = false
speedBtn.MouseButton1Click:Connect(function()
	if not hasAccess then return end
	speedOn = not speedOn
	speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
	getHum().WalkSpeed = speedOn and 40 or 16
end)

--------------------------------------------------
-- GODMODE
--------------------------------------------------

local godOn = false
godBtn.MouseButton1Click:Connect(function()
	if not hasAccess then return end
	godOn = not godOn
	godBtn.Text = godOn and "Godmode: ON" or "Godmode: OFF"
end)

RunService.Heartbeat:Connect(function()
	if godOn and hasAccess then
		local hum = getHum()
		if hum then hum.Health = hum.MaxHealth end
	end
end)

--------------------------------------------------
-- CLICK TP
--------------------------------------------------

local tpOn = false
tpBtn.MouseButton1Click:Connect(function()
	if not hasAccess then return end
	tpOn = not tpOn
	tpBtn.Text = tpOn and "Click TP: ON" or "Click TP: OFF"
end)

UserInputService.InputBegan:Connect(function(input,gp)
	if gp then return end
	if tpOn and hasAccess and input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mouse = player:GetMouse()
		if mouse.Hit then
			getChar():MoveTo(mouse.Hit.Position)
		end
	end
end)

--------------------------------------------------
-- AUTO FIGHT
--------------------------------------------------

local fighting = false

autoFightBtn.MouseButton1Click:Connect(function()
	if not hasAccess then return end
	fighting = not fighting
	autoFightBtn.Text = fighting and "Auto-Fight: ON" or "Auto-Fight: OFF"

	if fighting then
		task.spawn(function()
			while fighting and hasAccess do
				task.wait(0.3)

				local hrp = getHRP()
				local hum = getHum()

				local tool = getChar():FindFirstChildOfClass("Tool")
				if not tool then
					for _, t in pairs(player.Backpack:GetChildren()) do
						if t:IsA("Tool") then
							hum:EquipTool(t)
							tool = t
							break
						end
					end
				end

				local closest
				local shortest = math.huge

				for _, npc in pairs(workspace:GetDescendants()) do
					if npc:IsA("Model") and npc ~= getChar() and npc.Name:lower():find(targetBox.Text:lower()) then
						local nh = npc:FindFirstChild("Humanoid")
						local nhrp = npc:FindFirstChild("HumanoidRootPart")
						if nh and nhrp and nh.Health > 0 then
							local dist = (hrp.Position - nhrp.Position).Magnitude
							if dist < shortest then
								shortest = dist
								closest = npc
							end
						end
					end
				end

				if closest then
					local nhrp = closest:FindFirstChild("HumanoidRootPart")
					if nhrp then
						hrp.CFrame = nhrp.CFrame * CFrame.new(0,0,-3)
					end
					if tool then
						tool:Activate()
					end
				end
			end
		end)
	end
end)
