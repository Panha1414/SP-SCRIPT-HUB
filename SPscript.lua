--==================================================
--       SP ROBLOX SCRIPT HUB PRO
--       Developer: Sopha Panha
--       UI Library: Rayfield (custom premium theme)
--       Version: Delta-2.745.1142+
--==================================================

local LOGO_ID = 116345727167504
local VERSION = "Delta-2.745.1142"

--==================================================
-- [1] PREMIUM CUSTOM THEME (dark + cyan/teal + soft purple)
--==================================================

local SPTheme = {
    TextColor = Color3.fromRGB(240, 245, 255),

    Background = Color3.fromRGB(8, 10, 18),
    Topbar = Color3.fromRGB(12, 15, 26),
    Shadow = Color3.fromRGB(0, 0, 0),

    NotificationBackground = Color3.fromRGB(14, 17, 28),
    NotificationActionsBackground = Color3.fromRGB(45, 226, 200),

    TabBackground = Color3.fromRGB(15, 18, 30),
    TabStroke = Color3.fromRGB(40, 48, 72),
    TabBackgroundSelected = Color3.fromRGB(40, 220, 215),
    TabTextColor = Color3.fromRGB(160, 170, 195),
    SelectedTabTextColor = Color3.fromRGB(6, 10, 18),

    ElementBackground = Color3.fromRGB(16, 20, 34),
    ElementBackgroundHover = Color3.fromRGB(28, 26, 52),
    SecondaryElementBackground = Color3.fromRGB(11, 14, 24),
    ElementStroke = Color3.fromRGB(112, 72, 235),
    SecondaryElementStroke = Color3.fromRGB(45, 52, 78),

    SliderBackground = Color3.fromRGB(35, 60, 110),
    SliderProgress = Color3.fromRGB(45, 226, 200),
    SliderStroke = Color3.fromRGB(80, 240, 210),

    ToggleBackground = Color3.fromRGB(14, 17, 28),
    ToggleEnabled = Color3.fromRGB(45, 226, 200),
    ToggleDisabled = Color3.fromRGB(85, 92, 115),
    ToggleEnabledStroke = Color3.fromRGB(80, 240, 210),
    ToggleDisabledStroke = Color3.fromRGB(110, 118, 140),
    ToggleEnabledOuterStroke = Color3.fromRGB(112, 72, 235),
    ToggleDisabledOuterStroke = Color3.fromRGB(45, 50, 72),

    DropdownSelected = Color3.fromRGB(26, 24, 48),
    DropdownUnselected = Color3.fromRGB(16, 20, 34),

    InputBackground = Color3.fromRGB(11, 14, 24),
    InputStroke = Color3.fromRGB(112, 72, 235),
    PlaceholderColor = Color3.fromRGB(125, 135, 160)
}

--==================================================
-- [2] LOAD RAYFIELD + WINDOW
--==================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "SP ROBLOX SCRIPT HUB",
    Icon = LOGO_ID,
    LoadingTitle = "SP ROBLOX SCRIPT",
    LoadingSubtitle = "Premium Script Hub  •  By Sopha Panha",
    ShowText = "SP HUB",
    Theme = SPTheme,
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SP_ROBLOX_SCRIPT",
        FileName = "SP_Hub"
    },

    Discord = { Enabled = false, Invite = "SPROBLOX", RememberJoins = true },
    KeySystem = false
})

--==================================================
-- [2.1] CUSTOM LOGO (GitHub logo.png)
--==================================================

local LOGO_URL = "https://raw.githubusercontent.com/Panha1414/SP-SCRIPT-HUB/main/logo.png"

task.spawn(function()
    task.wait(1.6)

    local function Fail(msg)
        warn("[SP LOGO] " .. msg)
        pcall(function()
            Rayfield:Notify({
                Title = "SP LOGO ERROR",
                Content = msg,
                Duration = 7
            })
        end)
    end

    local ok, err = pcall(function()
        if not writefile then error("Executor គ្មាន writefile") end
        if not getcustomasset then error("Executor គ្មាន getcustomasset") end

        local data = game:HttpGet(LOGO_URL)
        if #data < 200 then
            error("ទាញ logo បរាជ័យ (size=" .. #data .. ")")
        end

        writefile("SP_logo.png", data)
        local asset = getcustomasset("SP_logo.png")

        local root = (gethui and gethui()) or game:GetService("CoreGui")
        local ray = root:FindFirstChild("Rayfield")
        if not ray then
            for _, c in ipairs({
                game:GetService("CoreGui"),
                game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            }) do
                if c and c:FindFirstChild("Rayfield") then
                    ray = c.Rayfield
                    break
                end
            end
        end
        if not ray then error("រកមិនឃើញ Rayfield GUI") end

        local topbar = ray.Main and ray.Main:FindFirstChild("Topbar")
        local icon = topbar and topbar:FindFirstChild("Icon", true)
        if not icon then error("រកមិនឃើញ Icon ក្នុង Topbar") end

        icon.Image = asset
        icon.ImageTransparency = 0
        icon.Visible = true
        icon.Size = UDim2.new(0, 28, 0, 28)
    end)

    if not ok then Fail(tostring(err)) end
end)

--==================================================
-- [3] HELPERS
--==================================================

local function Notify(title, message, duration)
    Rayfield:Notify({
        Title = title,
        Content = message,
        Duration = duration or 3.5,
        Image = LOGO_ID
    })
end

local function CopyLink(label, link)
    if setclipboard then
        setclipboard(link)
        Notify("SP ROBLOX", label .. " copied!", 3)
    else
        Notify("SP ROBLOX", link, 6)
    end
end

local function LoadScript(scriptName, scriptURL)
    Notify("SP ROBLOX", "កំពុងបើក " .. scriptName .. "...", 3)

    local ok, err = pcall(function()
        local fn = loadstring(game:HttpGet(scriptURL))
        assert(fn, "Cannot compile script")
        fn()
    end)

    if ok then
        Notify("SP ROBLOX", scriptName .. " ដំណើរការរួចរាល់! ✅", 4)
    else
        Notify("SP ROBLOX ERROR", tostring(err), 6)
        warn("[SP HUB ERROR] " .. tostring(err))
    end
end

-- Icon list (GitHub)
local ICON_BASE = "https://raw.githubusercontent.com/Panha1414/SP-SCRIPT-HUB/main/"
local CardIcons = {} -- { title = "...", file = "xxx.png" }

-- Beautiful script card
local function AddScriptCard(tab, name, desc, url, iconFile)
    if iconFile then
        table.insert(CardIcons, { title = name, file = iconFile })
    end

    tab:CreateSection(name)

    tab:CreateParagraph({
        Title = name,
        Content = desc
    })

    tab:CreateButton({
        Name = "▶  Execute Script",
        Callback = function()
            LoadScript(name, url)
        end
    })

    tab:CreateButton({
        Name = "📋  Copy Script",
        Callback = function()
            CopyLink(name .. " script",
                'loadstring(game:HttpGet("' .. url .. '"))()')
        end
    })
end

--==================================================
-- [4] TAB : ANDROID
--==================================================

local AndroidTab = Window:CreateTab("Android", "smartphone")

AndroidTab:CreateParagraph({
    Title = "⚡ Version ចុងក្រោយ: " .. VERSION,
    Content = "ជ្រើសរើស Script ណាមួយខាងក្រោម។ ប្រើ Delta ឬ Executor ដែលស្រដៀងគ្នា។\nIcon នឹងបង្ហាញនៅខាងស្ដាំនៃ card នីមួយៗ។"
})

AddScriptCard(AndroidTab, "🌶️ CHILLI HUB SCRIPT",
    "សម្រាប់ Android • Popular & Stable",
    "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua", "chilli.png")

AddScriptCard(AndroidTab, "⚡ VENYX HUB",
    "Smoother and faster • High performance",
    "https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub", "venyx.png")

AddScriptCard(AndroidTab, "🔵 CODIUMHUB",
    "សម្រាប់ Android និង iOS | RAM 4GB+",
    "https://getcodium.xyz/loader.luau", "codium.png")

--==================================================
-- [5] TAB : iOS
--==================================================

local IOSTab = Window:CreateTab("iOS", "apple")

IOSTab:CreateParagraph({
    Title = "🍎 iOS Scripts",
    Content = "Script ដែលដំណើរការលើ iPhone / iPad។ Icon នឹងបង្ហាញនៅខាងស្ដាំ។"
})

AddScriptCard(IOSTab, "💜 SCRIPT FYY",
    "សម្រាប់ iOS • Optimized",
    "https://FyyCommunity.net", "fyy.png")

AddScriptCard(IOSTab, "🔵 CODIUMHUB",
    "សម្រាប់ Android និង iOS | RAM 4GB+",
    "https://getcodium.xyz/loader.luau", "codium.png")

--==================================================
-- [6] TAB : SUPPORT
--==================================================

local SupportTab = Window:CreateTab("Support", "heart")

SupportTab:CreateSection("❤ SUPPORT ADMIN")

SupportTab:CreateParagraph({
    Title = "ជួយឧបត្ថម្ភ Admin 💖",
    Content = "ជួយឱ្យយើងធ្វើ Link & Script ថ្មីៗបន្ត។ ចំនួនប៉ុន្មានក៏បាន សូមអរគុណ!"
})

SupportTab:CreateButton({
    Name = "🌐  Website (Donate + Top Supporters)",
    Callback = function()
        CopyLink("Website link", "https://sp-roblox.vercel.app")
    end
})

SupportTab:CreateButton({
    Name = "✈️  Contact Admin: @sophapanha",
    Callback = function()
        CopyLink("Telegram link", "https://t.me/sophapanha")
    end
})

--==================================================
-- [7] TAB : INFORMATION
--==================================================

local InfoTab = Window:CreateTab("Info", "info")

InfoTab:CreateSection("DEVELOPER")

InfoTab:CreateParagraph({
    Title = "SP ROBLOX SCRIPT",
    Content = "Developer: Sopha Panha (@sophapanha)\nDownload Apps & Utilities\nPremium Script Hub"
})

InfoTab:CreateSection("SOCIAL MEDIA")

InfoTab:CreateButton({
    Name = "▶️  YouTube: @sp_roblox1",
    Callback = function()
        CopyLink("YouTube link", "https://youtube.com/@sp_roblox1")
    end
})

InfoTab:CreateButton({
    Name = "✈️  Telegram Channel: @SPROBLOX",
    Callback = function()
        CopyLink("Telegram link", "https://t.me/SPROBLOX")
    end
})

InfoTab:CreateButton({
    Name = "🌐  SP ROBLOX Website",
    Callback = function()
        CopyLink("Website link", "https://sp-roblox.vercel.app")
    end
})

--==================================================
-- [8] TAB : SETTINGS
--==================================================

local SettingsTab = Window:CreateTab("Settings", "settings")

SettingsTab:CreateSection("UI CONTROL")

SettingsTab:CreateLabel("Press K to Hide / Show UI", "keyboard")

SettingsTab:CreateKeybind({
    Name = "Toggle UI Keybind",
    CurrentKeybind = "K",
    HoldToInteract = false,
    Flag = "SP_ToggleInfo",
    Callback = function() end
})

SettingsTab:CreateSection("CLOSE HUB")

SettingsTab:CreateButton({
    Name = "❌  CLOSE SP ROBLOX HUB",
    Callback = function()
        Rayfield:Destroy()
    end
})

--==================================================
-- [8.1] ROBUST SCRIPT ICONS (find by Title.Text)
--==================================================

task.spawn(function()
    task.wait(2.2)
    if not (writefile and getcustomasset) then
        warn("[SP ICON] writefile / getcustomasset not available")
        return
    end

    local root = (gethui and gethui()) or game:GetService("CoreGui")
    local ray = root:FindFirstChild("Rayfield")
    if not ray then
        for _, c in ipairs({
            game:GetService("CoreGui"),
            game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        }) do
            if c and c:FindFirstChild("Rayfield") then
                ray = c.Rayfield
                break
            end
        end
    end
    if not ray or not ray:FindFirstChild("Main") then
        warn("[SP ICON] Rayfield.Main not found")
        return
    end

    local assets = {}
    local function getAsset(file)
        if assets[file] then return assets[file] end
        local data = game:HttpGet(ICON_BASE .. file)
        if #data < 200 then
            error("ទាញ " .. file .. " មិនបាន (size=" .. #data .. ")")
        end
        local path = "SP_icon_" .. file
        writefile(path, data)
        assets[file] = getcustomasset(path)
        return assets[file]
    end

    local function addIconToParent(parent, asset)
        if parent:FindFirstChild("SPIcon") then return end

        local img = Instance.new("ImageLabel")
        img.Name = "SPIcon"
        img.BackgroundTransparency = 1
        img.AnchorPoint = Vector2.new(1, 0.5)
        img.Position = UDim2.new(1, -14, 0.5, 0)
        img.Size = UDim2.new(0, 42, 0, 42)
        img.Image = asset
        img.ScaleType = Enum.ScaleType.Fit
        img.ZIndex = 10
        img.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = img

        -- soft stroke
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(45, 226, 200)
        stroke.Thickness = 1.2
        stroke.Transparency = 0.55
        stroke.Parent = img
    end

    for _, item in ipairs(CardIcons) do
        local ok, err = pcall(function()
            local asset = getAsset(item.file)

            -- Search every TextLabel whose Text matches the script title
            for _, obj in ipairs(ray.Main:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Name == "Title" then
                    local text = (obj.Text or ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
                    local target = item.title:gsub("%s+", " "):match("^%s*(.-)%s*$")

                    if text == target then
                        -- Prefer the nearest Frame that looks like a card / paragraph / section
                        local parent = obj.Parent
                        while parent and parent ~= ray.Main do
                            if parent:IsA("Frame") then
                                -- Paragraph / SectionTitle style frames usually have BackgroundTransparency < 1
                                -- or contain Content / Title