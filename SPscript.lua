--==================================================
--       SP ROBLOX SCRIPT HUB PRO
--       Developer: Sopha Panha
--       UI Library: Rayfield (custom theme)
--==================================================

local LOGO_ID = 116345727167504
local VERSION = "Delta-2.745.1142"

local SPTheme = {
    TextColor = Color3.fromRGB(235, 240, 250),
    Background = Color3.fromRGB(9, 12, 20),
    Topbar = Color3.fromRGB(14, 18, 30),
    Shadow = Color3.fromRGB(0, 0, 0),
    NotificationBackground = Color3.fromRGB(14, 18, 30),
    NotificationActionsBackground = Color3.fromRGB(45, 226, 200),
    TabBackground = Color3.fromRGB(17, 22, 36),
    TabStroke = Color3.fromRGB(34, 42, 64),
    TabBackgroundSelected = Color3.fromRGB(40, 220, 215),
    TabTextColor = Color3.fromRGB(165, 175, 200),
    SelectedTabTextColor = Color3.fromRGB(6, 10, 18),
    ElementBackground = Color3.fromRGB(16, 21, 34),
    ElementBackgroundHover = Color3.fromRGB(30, 28, 56),
    SecondaryElementBackground = Color3.fromRGB(12, 16, 27),
    ElementStroke = Color3.fromRGB(112, 72, 235),
    SecondaryElementStroke = Color3.fromRGB(40, 48, 72),
    SliderBackground = Color3.fromRGB(40, 70, 120),
    SliderProgress = Color3.fromRGB(45, 226, 200),
    SliderStroke = Color3.fromRGB(80, 240, 210),
    ToggleBackground = Color3.fromRGB(14, 18, 30),
    ToggleEnabled = Color3.fromRGB(45, 226, 200),
    ToggleDisabled = Color3.fromRGB(90, 96, 120),
    ToggleEnabledStroke = Color3.fromRGB(80, 240, 210),
    ToggleDisabledStroke = Color3.fromRGB(120, 126, 150),
    ToggleEnabledOuterStroke = Color3.fromRGB(112, 72, 235),
    ToggleDisabledOuterStroke = Color3.fromRGB(50, 56, 80),
    DropdownSelected = Color3.fromRGB(28, 26, 52),
    DropdownUnselected = Color3.fromRGB(16, 21, 34),
    InputBackground = Color3.fromRGB(12, 16, 27),
    InputStroke = Color3.fromRGB(112, 72, 235),
    PlaceholderColor = Color3.fromRGB(130, 138, 165)
}

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "SP ROBLOX SCRIPT HUB",
    Icon = LOGO_ID,
    LoadingTitle = "SP ROBLOX SCRIPT",
    LoadingSubtitle = "Premium Script Hub | By Sopha Panha",
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

local LOGO_URL = "https://raw.githubusercontent.com/Panha1414/SP-SCRIPT-HUB/main/logo.png"

task.spawn(function()
    task.wait(1.5)
    local function Fail(msg)
        warn("[SP LOGO] " .. msg)
        pcall(function()
            Rayfield:Notify({ Title = "SP LOGO ERROR", Content = msg, Duration = 8 })
        end)
    end
    local ok, err = pcall(function()
        if not writefile then error("no writefile") end
        if not getcustomasset then error("no getcustomasset") end
        local data = game:HttpGet(LOGO_URL)
        if #data < 200 then error("logo download failed") end
        writefile("SP_logo.png", data)
        local asset = getcustomasset("SP_logo.png")
        local root = (gethui and gethui()) or game:GetService("CoreGui")
        local ray = root:FindFirstChild("Rayfield")
        if not ray then
            for _, c in ipairs({game:GetService("CoreGui"), game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")}) do
                if c and c:FindFirstChild("Rayfield") then ray = c.Rayfield break end
            end
        end
        if not ray then error("Rayfield not found") end
        local topbar = ray.Main:FindFirstChild("Topbar")
        local icon = topbar and topbar:FindFirstChild("Icon", true)
        if not icon then error("Icon not found") end
        icon.Image = asset
        icon.ImageTransparency = 0
        icon.Visible = true
    end)
    if not ok then Fail(tostring(err)) end
end)

local function Notify(title, message, duration)
    Rayfield:Notify({ Title = title, Content = message, Duration = duration or 3, Image = LOGO_ID })
end

local function CopyLink(label, link)
    if setclipboard then
        setclipboard(link)
        Notify("SP ROBLOX", label .. " copied!", 3)
    else
        Notify("SP ROBLOX", link, 6)
    end
end

local LastLoadedScript = nil

local function CloseLoadedScripts()
    local cleaned = 0
    local roots = {}
    pcall(function()
        table.insert(roots, game:GetService("CoreGui"))
        if gethui then table.insert(roots, gethui()) end
        local lp = game:GetService("Players").LocalPlayer
        if lp then table.insert(roots, lp:FindFirstChild("PlayerGui")) end
    end)

    local keywords = {
        "rayfield", "fluent", "orchid", "linoria", "venyx", "chilli", "spicy",
        "codium", "fyy", "hub", "script", "ui", "menu", "window", "library",
        "nyx", "tenshi", "sirius", "windui", "kavo", "material", "simple",
        "maclib", "orange", "redz", "lumin", "solara"
    }

    local function isOurHub(gui)
        local ok, isOurs = pcall(function()
            local main = gui:FindFirstChild("Main", true)
            if not main then return false end
            local title = main:FindFirstChild("Title", true) or main:FindFirstChildWhichIsA("TextLabel", true)
            if title and title:IsA("TextLabel") then
                local t = tostring(title.Text or "")
                if t:find("SP ROBLOX") or t:find("SP HUB") then return true end
            end
            if main:FindFirstChild("SPIcon", true) then return true end
            return false
        end)
        return ok and isOurs
    end

    for _, root in ipairs(roots) do
        if root then
            for _, child in ipairs(root:GetChildren()) do
                local name = tostring(child.Name):lower()
                local shouldDestroy = false

                if child.Name == "Rayfield" then
                    if not isOurHub(child) then shouldDestroy = true end
                else
                    for _, kw in ipairs(keywords) do
                        if name:find(kw) then
                            shouldDestroy = true
                            break
                        end
                    end
                end

                if shouldDestroy then
                    pcall(function()
                        child:Destroy()
                        cleaned = cleaned + 1
                    end)
                end
            end
        end
    end

    pcall(function()
        if getgenv then
            getgenv().SP_Unload = true
            getgenv().Unload = true
            getgenv().ChilliUnload = true
        end
    end)

    LastLoadedScript = nil
    return cleaned
end

local function LoadScript(scriptName, scriptURL)
    Notify("SP ROBLOX", "Loading " .. scriptName .. "...", 3)
    local ok, err = pcall(function()
        local fn = loadstring(game:HttpGet(scriptURL))
        assert(fn, "Cannot compile script")
        fn()
    end)
    if ok then
        LastLoadedScript = scriptName
        Notify("SP ROBLOX", scriptName .. " loaded successfully! ✅", 4)
    else
        Notify("SP ROBLOX ERROR", tostring(err), 6)
        warn("[SP HUB ERROR] " .. tostring(err))
    end
end

local ICON_BASE = "https://raw.githubusercontent.com/Panha1414/SP-SCRIPT-HUB/main/"
local CardIcons = {}

local function AddScriptCard(tab, name, desc, url, iconFile)
    if iconFile then table.insert(CardIcons, { title = name, file = iconFile }) end
    tab:CreateSection(name)
    tab:CreateParagraph({ Title = name, Content = desc })
    tab:CreateButton({
        Name = "▶  EXECUTE SCRIPT",
        Callback = function() LoadScript(name, url) end
    })
    tab:CreateButton({
        Name = "📋  COPY SCRIPT",
        Callback = function()
            CopyLink(name .. " script", 'loadstring(game:HttpGet("' .. url .. '"))()')
        end
    })
end

-- ANDROID
local AndroidTab = Window:CreateTab("Android", "smartphone")
AndroidTab:CreateParagraph({
    Title = "⚡ Latest Version: " .. VERSION,
    Content = "Select a script below. Works with Delta and similar executors."
})

AddScriptCard(AndroidTab, "🌶️ CHILLI HUB SCRIPT", "For Android | Popular & Stable",
    "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua", "chilli.png")

AddScriptCard(AndroidTab, "⚡ VENYX HUB", "Smoother and faster",
    "https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub", "venyx.png")

AddScriptCard(AndroidTab, "🔵 CODIUMHUB", "Android & iOS | RAM 4GB+",
    "https://getcodium.xyz/loader.luau", "codium.png")

AddScriptCard(AndroidTab, "🥚 TENSHI EGG FINDER (NYX)",
    "Egg Finder + Server Hop. For Combo Finder, run this script again (2nd time).",
    "https://raw.githubusercontent.com/syss1211/Tenshi-script/main/NYX.lua", nil)

-- iOS
local IOSTab = Window:CreateTab("iOS", "apple")
IOSTab:CreateParagraph({ Title = "🍎 iOS Scripts", Content = "Scripts that work on iPhone / iPad." })

AddScriptCard(IOSTab, "💜 SCRIPT FYY", "For iOS | Optimized", "https://FyyCommunity.net", "fyy.png")
AddScriptCard(IOSTab, "🔵 CODIUMHUB", "Android & iOS | RAM 4GB+", "https://getcodium.xyz/loader.luau", "codium.png")

-- SUPPORT
local SupportTab = Window:CreateTab("Support", "heart")
SupportTab:CreateSection("❤ SUPPORT ADMIN")
SupportTab:CreateParagraph({
    Title = "Support the Admin 💖",
    Content = "Help us keep making new links & scripts. Any amount is appreciated. Thank you!"
})
SupportTab:CreateButton({ Name = "🌐 Copy Website (Donate + Top Supporters)", Callback = function() CopyLink("Website link", "https://sp-roblox.vercel.app") end })
SupportTab:CreateButton({ Name = "✈️ Contact Admin: @sophapanha", Callback = function() CopyLink("Telegram link", "https://t.me/sophapanha") end })

-- INFO
local InfoTab = Window:CreateTab("Info", "info")
InfoTab:CreateSection("DEVELOPER")
InfoTab:CreateParagraph({ Title = "SP ROBLOX SCRIPT", Content = "Developer: Sopha Panha (@sophapanha)\nDownload Apps & Utilities" })
InfoTab:CreateSection("SOCIAL MEDIA")
InfoTab:CreateButton({ Name = "▶️  YouTube: @sp_roblox1", Callback = function() CopyLink("YouTube link", "https://youtube.com/@sp_roblox1") end })
InfoTab:CreateButton({ Name = "✈️  Telegram Channel: @SPROBLOX", Callback = function() CopyLink("Telegram link", "https://t.me/SPROBLOX") end })
InfoTab:CreateButton({ Name = "🌐  SP ROBLOX Website", Callback = function() CopyLink("Website link", "https://sp-roblox.vercel.app") end })

-- SETTINGS
local SettingsTab = Window:CreateTab("Settings", "settings")
SettingsTab:CreateSection("UI CONTROL")
SettingsTab:CreateLabel("Press K to Hide / Show UI", "keyboard")
SettingsTab:CreateKeybind({ Name = "Toggle UI Keybind", CurrentKeybind = "K", HoldToInteract = false, Flag = "SP_ToggleInfo", Callback = function() end })

SettingsTab:CreateSection("SCRIPT CONTROL")
SettingsTab:CreateParagraph({
    Title = "Unload Script",
    Content = "Want to switch script? Click the button below to close the current one first (best effort)."
})
SettingsTab:CreateButton({
    Name = "🛑  CLOSE / UNLOAD SCRIPT",
    Callback = function()
        local count = CloseLoadedScripts()
        if count > 0 then
            Notify("SP ROBLOX", "Closed ~" .. count .. " script UI(s)", 4)
        else
            Notify("SP ROBLOX", "No other script UI found (or already closed)", 4)
        end
    end
})

SettingsTab:CreateSection("CLOSE HUB")
SettingsTab:CreateButton({ Name = "❌  CLOSE SP ROBLOX HUB", Callback = function() Rayfield:Destroy() end })

-- ICONS
task.spawn(function()
    task.wait(2.5)
    if not (writefile and getcustomasset) then return end
    local root = (gethui and gethui()) or game:GetService("CoreGui")
    local ray = root:FindFirstChild("Rayfield")
    if not ray then
        for _, c in ipairs({game:GetService("CoreGui"), game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")}) do
            if c and c:FindFirstChild("Rayfield") then ray = c.Rayfield break end
        end
    end
    if not ray or not ray:FindFirstChild("Main") then return end
    local assets = {}
    local function getAsset(file)
        if assets[file] then return assets[file] end
        local data = game:HttpGet(ICON_BASE .. file)
        if #data < 200 then error("download failed") end
        writefile("SP_icon_" .. file, data)
        assets[file] = getcustomasset("SP_icon_" .. file)
        return assets[file]
    end
    local function addIcon(parent, asset)
        if parent:FindFirstChild("SPIcon") then return end
        local img = Instance.new("ImageLabel")
        img.Name = "SPIcon"
        img.BackgroundTransparency = 1
        img.AnchorPoint = Vector2.new(1, 0.5)
        img.Position = UDim2.new(1, -12, 0.5, 0)
        img.Size = UDim2.new(0, 40, 0, 40)
        img.Image = asset
        img.ScaleType = Enum.ScaleType.Fit
        img.ZIndex = 10
        img.Parent = parent
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = img
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(45, 226, 200)
        stroke.Thickness = 1.2
        stroke.Transparency = 0.5
        stroke.Parent = img
    end
    for _, item in ipairs(CardIcons) do
        pcall(function()
            local asset = getAsset(item.file)
            local target = (item.title or ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
            for _, obj in ipairs(ray.Main:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Name == "Title" then
                    local text = (obj.Text or ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
                    if text == target then
                        local parent = obj.Parent
                        while parent and parent ~= ray.Main do
                            if parent:IsA("Frame") then
                                if parent:FindFirstChild("Content") or parent:FindFirstChild("Title")
                                    or (parent.Name and (parent.Name:lower():find("paragraph") or parent.Name:lower():find("section"))) then
                                    addIcon(parent, asset)
                                    break
                                end
                            end
                            parent = parent.Parent
                        end
                    end
                end
            end
        end)
    end
    print("[SP HUB] Script icons loaded")
end)

Notify("SP ROBLOX SCRIPT HUB", "Welcome! SP HUB PRO Loaded Successfully. 🎉", 6)
print("====================================")
print("       SP ROBLOX SCRIPT HUB PRO")
print("       Developer: Sopha Panha")
print("       Status: Loaded Successfully")
print("====================================")
