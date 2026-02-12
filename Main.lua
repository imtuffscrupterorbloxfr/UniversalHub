-- UI creation stuff above

local farming = false

button.MouseButton1Click:Connect(function()
    farming = not farming
    button.Text = farming and "Autofarm: ON" or "Autofarm: OFF"

    if farming then
        startAutoFarm()
    end
end)

function startAutoFarm()
    while farming do
        task.wait(0.2)

        -- autofarm logic here
    end
end

