--==================================================
--       SP ROBLOX SCRIPT HUB PRO
--       Developer: Sopha Panha
--       UI Library: Rayfield (custom theme)
--==================================================

local LOGO_ID = 116345727167504
local VERSION = "Delta-2.745.1142"

--==================================================
-- [1] CUSTOM THEME (ដូច website: dark + cyan/green + purple)
--==================================================

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

--==================================================
-- [2] LOAD RAYFIELD + WINDOW
--==================================================

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

--==================================================
-- [2.1] CUSTOM LOGO (ទាញពី GitHub: logo.png)
--==================================================

local LOGO_URL = "https://raw.githubusercontent.com/Panha1414/SP-SCRIPT-ROBLOX/main/logo.png"

task.spawn(function()
    local ok, err = pcall(function()
        if not (writefile and getcustomasset) then
            error("Executor មិនគាំទ្រ writefile/getcustomasset")
        end

        local data = game:HttpGet(LOGO_URL)
        writefile("SP_logo.png", data)
        local asset = getcustomasset("SP_logo.png")

        local root = (gethui and gethui()) or game:GetService("CoreGui")
        local ray = root:FindFirstChild("Rayfield")
        local icon = ray and ray.Main.Topbar:FindFirstChild("Icon")

        if icon then
            icon.Image = asset
        else
            error("រកមិនឃើញ Icon នៅក្នុង Rayfield")
        end
    end)

    if not ok then
        warn("[SP LOGO] " .. tostring(err))
    end
end)

--==================================================
-- [3] HELPERS
--==================================================

local function Notify(title, message, duration)
    Rayfield:Notify({
        Title = title,
        Content = message,
        Duration = duration or 3,
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

-- Script "card": ចំណងជើង + ពិពណ៌នា + ប៊ូតុង Execute / Copy (ដូច Copy Script នៅ website)
local function AddScriptCard(tab, name, desc, url)
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
    Content = "ជ្រើសរើស Script ណាមួយខាងក្រោម។ ប្រើ Delta ឬ Executor ដែលស្រដៀងគ្នា។"
})

AddScriptCard(AndroidTab, "🌶️ CHILLI HUB SCRIPT",
    "សម្រាប់ Android",
    "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua")

AddScriptCard(AndroidTab, "⚡ VENYX HUB",
    "Smoother and faster",
    "https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub")

AddScriptCard(AndroidTab, "🔵 CODIUMHUB",
    "សម្រាប់ Android និង iOS | RAM 4GB+",
    "https://getcodium.xyz/loader.luau")

--==================================================
-- [5] TAB : iOS
--==================================================

local IOSTab = Window:CreateTab("iOS", "apple")

IOSTab:CreateParagraph({
    Title = "🍎 iOS Scripts",
    Content = "Script ដែលដំណើរការលើ iPhone / iPad។"
})

AddScriptCard(IOSTab, "💜 SCRIPT FYY",
    "សម្រាប់ iOS",
    "https://FyyCommunity.net")

AddScriptCard(IOSTab, "🔵 CODIUMHUB",
    "សម្រាប់ Android និង iOS | RAM 4GB+",
    "https://getcodium.xyz/loader.luau")

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
    Name = "🌐 Copy Website (Donate + Top Supporters)",
    Callback = function()
        CopyLink("Website link", "https://sp-roblox.vercel.app")
    end
})

SupportTab:CreateButton({
    Name = "✈️ Contact Admin: @sophapanha",
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
    Content = "Developer: Sopha Panha (@sophapanha)\nDownload Apps & Utilities"
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
    Name = "Toggle UI Keybind (ប្តូរ​ក្នុង Rayfield Settings)",
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
-- [9] STARTUP
--==================================================

Notify("SP ROBLOX SCRIPT HUB", "Welcome! SP HUB PRO Loaded Successfully. 🎉", 6)

print("====================================")
print("       SP ROBLOX SCRIPT HUB PRO")
print("       Developer: Sopha Panha")
print("       Status: Loaded Successfully")
print("====================================")