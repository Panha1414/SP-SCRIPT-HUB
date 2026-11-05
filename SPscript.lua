--==================================================
--   ███████╗██████╗     ██╗  ██╗██╗   ██╗██████╗
--   ██╔════╝██╔══██╗    ██║  ██║██║   ██║██╔══██╗
--   ███████╗██████╔╝    ███████║██║   ██║██████╔╝
--   ╚════██║██╔═══╝     ██╔══██║██║   ██║██╔══██╗
--   ███████║██║         ██║  ██║╚██████╔╝██████╔╝
--   ╚══════╝╚═╝         ╚═╝  ╚═╝ ╚═════╝ ╚═════╝
--       SP ROBLOX SCRIPT HUB PRO v2.4
--       Key + Sound + Combo + Khmer Font
--       Developer: Sopha Panha | UI: Rayfield
--==================================================

local HttpService  = game:GetService("HttpService")
local Players      = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local UIS          = game:GetService("UserInputService")

local LOGO_ID   = 116345727167504
local VERSION   = "Delta-2.745.1142"
local BUILD     = "PRO v2.4"
local ICON_BASE = "https://raw.githubusercontent.com/Panha1414/SP-SCRIPT-HUB/main/"

--===================== BOOT SEQUENCE =====================
print("╔══════════════════════════════════════════╗")
print("║  SP ROBLOX SCRIPT HUB " .. BUILD .. "           ║")
print("║  Khmer Font Edition                      ║")
print("║  By Sopha Panha                          ║")
print("╚══════════════════════════════════════════╝")

for i, step in ipairs({
    "Initializing core services...",
    "Loading Rayfield UI library...",
    "Loading user preferences...",
    "Registering scripts...",
    "Building interface...",
}) do
    print(string.format("  [%d/5] %s", i, step))
    task.wait(0.08)
end

--===================== THEME =====================
local SPTheme = {
    TextColor                     = Color3.fromRGB(235, 240, 250),
    Background                    = Color3.fromRGB(9, 12, 20),
    Topbar                        = Color3.fromRGB(14, 18, 30),
    Shadow                        = Color3.fromRGB(0, 0, 0),
    NotificationBackground        = Color3.fromRGB(14, 18, 30),
    NotificationActionsBackground = Color3.fromRGB(45, 226, 200),
    TabBackground                 = Color3.fromRGB(17, 22, 36),
    TabStroke                     = Color3.fromRGB(34, 42, 64),
    TabBackgroundSelected         = Color3.fromRGB(40, 220, 215),
    TabTextColor                  = Color3.fromRGB(165, 175, 200),
    SelectedTabTextColor          = Color3.fromRGB(6, 10, 18),
    ElementBackground             = Color3.fromRGB(16, 21, 34),
    ElementBackgroundHover        = Color3.fromRGB(30, 28, 56),
    SecondaryElementBackground    = Color3.fromRGB(12, 16, 27),
    ElementStroke                 = Color3.fromRGB(112, 72, 235),
    SecondaryElementStroke        = Color3.fromRGB(40, 48, 72),
    SliderBackground              = Color3.fromRGB(40, 70, 120),
    SliderProgress                = Color3.fromRGB(45, 226, 200),
    SliderStroke                  = Color3.fromRGB(80, 240, 210),
    ToggleBackground              = Color3.fromRGB(14, 18, 30),
    ToggleEnabled                 = Color3.fromRGB(45, 226, 200),
    ToggleDisabled                = Color3.fromRGB(90, 96, 120),
    ToggleEnabledStroke           = Color3.fromRGB(80, 240, 210),
    ToggleDisabledStroke          = Color3.fromRGB(120, 126, 150),
    ToggleEnabledOuterStroke      = Color3.fromRGB(112, 72, 235),
    ToggleDisabledOuterStroke     = Color3.fromRGB(50, 56, 80),
    DropdownSelected              = Color3.fromRGB(28, 26, 52),
    DropdownUnselected            = Color3.fromRGB(16, 21, 34),
    InputBackground               = Color3.fromRGB(12, 16, 27),
    InputStroke                   = Color3.fromRGB(112, 72, 235),
    PlaceholderColor              = Color3.fromRGB(130, 138, 165),
}

--===================== PERSISTENCE =====================
local CONFIG_FOLDER = "SP_ROBLOX_SCRIPT"
if makefolder and isfolder and not isfolder(CONFIG_FOLDER) then
    pcall(function() makefolder(CONFIG_FOLDER) end)
end

local FAV_FILE    = CONFIG_FOLDER .. "/Favorites.json"
local RECENT_FILE = CONFIG_FOLDER .. "/Recent.json"
local STATS_FILE  = CONFIG_FOLDER .. "/Stats.json"

local function ReadJSON(path, default)
    if not (readfile and isfile) then return default end
    local ok, data = pcall(function()
        if isfile(path) then
            return HttpService:JSONDecode(readfile(path))
        end
    end)
    if ok and type(data) == "table" then return data end
    return default
end

local function WriteJSON(path, data)
    if not writefile then return end
    pcall(function() writefile(path, HttpService:JSONEncode(data)) end)
end

local SP = {
    Favorites = ReadJSON(FAV_FILE,    {}),
    Recent    = ReadJSON(RECENT_FILE, {}),
    Stats     = ReadJSON(STATS_FILE,  { loaded = 0, failed = 0, copied = 0 }),
}

local function SaveFavorites() WriteJSON(FAV_FILE,    SP.Favorites) end
local function SaveRecent()    WriteJSON(RECENT_FILE, SP.Recent)    end
local function SaveStats()     WriteJSON(STATS_FILE,  SP.Stats)     end

--===================== 🎵 SOUND SYSTEM =====================
local SOUNDS = {
    startup = "rbxassetid://1837727675",
    success = "rbxassetid://9118823103",
    error   = "rbxassetid://9118823302",
    click   = "rbxassetid://6042053626",
    copy    = "rbxassetid://9118823103",
    combo   = "rbxassetid://9046892591",
    fav     = "rbxassetid://9046892591",
}

local SOUND_ENABLED = true
local SOUND_VOLUME  = 0.4

local function PlaySound(name, volume)
    if not SOUND_ENABLED then return end
    local id = SOUNDS[name]
    if not id then return end
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = id
        sound.Volume  = volume or SOUND_VOLUME
        sound.Parent  = SoundService
        sound:Play()
        task.delay(6, function()
            if sound and sound.Parent then sound:Destroy() end
        end)
    end)
end

--===================== SCRIPT REGISTRY =====================
local SCRIPT_REGISTRY = {
    -- ============ ANDROID ============
    {
        id   = "chilli",
        name = "🌶️ CHILLI HUB SCRIPT",
        desc = "សម្រាប់ Android | Fast & Smooth | Delta-friendly",
        url  = "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua",
        icon = "chilli.png",
        cat  = "Android",
    },
    {
        id   = "venyx",
        name = "⚡ VENYX HUB",
        desc = "Smoother and faster | Optimized for low-end devices",
        url  = "https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub",
        icon = "venyx.png",
        cat  = "Android",
    },
    {
        id   = "codium_android",
        name = "🔵 CODIUMHUB",
        desc = "សម្រាប់ Android និង iOS | ត្រូវការ RAM 4GB+",
        url  = "https://getcodium.xyz/loader.luau",
        icon = "codium.png",
        cat  = "Android",
    },
    {
        id   = "tenshi",
        name = "🥚 TENSHI EGG FINDER (NYX)",
        desc = "Egg Finder + Server Hop រកពងល្អៗ។ បើចង់បាន Combo Finder សូម run script នេះបន្ថែម។",
        url  = "https://raw.githubusercontent.com/syss1211/Tenshi-script/main/NYX.lua",
        icon = nil,
        cat  = "Android",
    },

    -- ============ 🔥 COMBO ============
    {
        id    = "venyx_tenshi_combo",
        name  = "🔥 VENYX + TENSHI COMBO",
        desc  = "បើក Venyx Hub និង Tenshi Egg Finder (NYX) ព្រមគ្នាក្នុងពេលតែមួយ! ចុចតែម្តងបានទាំង២ 🚀",
        url   = nil,
        combo = {
            { name = "VENYX HUB",         url = "https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub" },
            { name = "TENSHI EGG FINDER", url = "https://raw.githubusercontent.com/syss1211/Tenshi-script/main/NYX.lua" },
        },
        icon  = "venyx.png",
        cat   = "Android",
    },

    -- ============ iOS ============
    {
        id   = "fyy",
        name = "💜 SCRIPT FYY",
        desc = "សម្រាប់ iOS | iPhone / iPad",
        url  = "https://FyyCommunity.net",
        icon = "fyy.png",
        cat  = "iOS",
    },
    {
        id   = "codium_ios",
        name = "🔵 CODIUMHUB",
        desc = "សម្រាប់ Android និង iOS | ត្រូវការ RAM 4GB+",
        url  = "https://getcodium.xyz/loader.luau",
        icon = "codium.png",
        cat  = "iOS",
    },
}

local CATEGORIES = {
    { name = "Android", icon = "smartphone", desc = "⚡ ជ្រើសរើស Script ណាមួយខាងក្រោម។ ប្រើ Delta ឬ Executor ដែលស្រដៀងគ្នា។" },
    { name = "iOS",     icon = "apple",      desc = "🍎 Script ដែលដំណើរការលើ iPhone / iPad។" },
}

local function FindScriptByName(name)
    if type(name) == "table" then name = name[1] end
    if not name then return nil end
    name = tostring(name):gsub("^⭐ ", "")
    for _, s in ipairs(SCRIPT_REGISTRY) do
        if s.name == name then return s end
    end
    return nil
end

local function CountFavorites()
    local n = 0
    for _ in pairs(SP.Favorites) do n = n + 1 end
    return n
end

--===================== WINDOW (with KEY SYSTEM) =====================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name        = "SP ROBLOX SCRIPT HUB",
    Icon        = LOGO_ID,
    LoadingTitle    = "SP ROBLOX SCRIPT",
    LoadingSubtitle = "Premium Script Hub " .. BUILD .. " | By Sopha Panha",
    ShowText    = "SP HUB",
    Theme       = SPTheme,
    DisableRayfieldPrompts  = true,
    DisableBuildWarnings    = true,
    ConfigurationSaving = {
        Enabled    = true,
        FolderName = CONFIG_FOLDER,
        FileName   = "SP_Hub",
    },
    Discord = { Enabled = false, Invite = "SPROBLOX", RememberJoins = true },

    --══════════════════ 🔒 KEY SYSTEM ══════════════════
    KeySystem = true,
    KeySettings = {
        Title     = "SP HUB | 🔑 KEY SYSTEM",
        Subtitle  = "Enter your key to unlock SP HUB",
        Note      = "🔑 Get your key: t.me/SPROBLOX\n🌐 Or visit: sp-roblox.vercel.app",
        FileName  = "SP_Hub_Key",
        SaveKey   = true,
        GrabKeyFromSite = false,
        Key = {
            "SP-2024-PREMIUM",
            "SP-VIP-GOLD",
            "SP-DEV-MASTER",
            "SP-BETA-ACCESS",
        },
    },
})

--===================== 🛠️ FORCE UI RESET FUNCTION =====================
local function ResetUIPosition()
    pcall(function()
        local Root = (gethui and gethui()) or game:GetService("CoreGui")
        local RayfieldGui = Root:FindFirstChild("Rayfield")
        if RayfieldGui then
            local MainFrame = RayfieldGui:FindFirstChild("Main")
            if MainFrame and MainFrame:IsA("GuiObject") then
                MainFrame.Position = UDim2.new(0.5, -MainFrame.AbsoluteSize.X / 2, 0.5, -MainFrame.AbsoluteSize.Y / 2)
                print("[SP HUB] បានកែទីតាំង UI មកកណ្តាលវិញ")
            end
        end
    end)
end

task.delay(1.5, ResetUIPosition)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        task.wait(0.1)
        pcall(function()
            local Root = (gethui and gethui()) or game:GetService("CoreGui")
            local RayfieldGui = Root:FindFirstChild("Rayfield")
            if RayfieldGui then
                local MainFrame = RayfieldGui:FindFirstChild("Main")
                if MainFrame and MainFrame:IsA("GuiObject") then
                    if MainFrame.AbsolutePosition.Y < -50 or MainFrame.AbsolutePosition.X < -50 then
                        ResetUIPosition()
                    end
                end
            end
        end)
    end
end)

--===================== HELPERS =====================
local function Notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({
            Title    = tostring(title),
            Content  = tostring(content),
            Duration = duration or 3,
            Image    = LOGO_ID,
        })
    end)
end

local function CopyLink(label, link)
    PlaySound("copy")
    if setclipboard then
        setclipboard(link)
        Notify("📋 Copied", label .. " copied to clipboard!", 3)
    else
        Notify("📋 Link", link, 6)
    end
end

--===================== LOAD SCRIPT =====================
local function LoadScript(script)
    if not script then return end

    if script.combo then
        Notify("🔥 Combo", "កំពុងបើក " .. #script.combo .. " scripts ព្រមគ្នា...", 3)
        local success = 0
        for i, sub in ipairs(script.combo) do
            Notify("⏳ " .. i .. "/" .. #script.combo, sub.name .. " loading...", 2)
            local ok, err = pcall(function()
                local src = game:HttpGet(sub.url)
                assert(type(src) == "string" and #src > 50, "Empty source")
                local fn = loadstring(src)
                assert(fn, "Failed to compile " .. sub.name)
                fn()
            end)
            if ok then
                success = success + 1
                print("[SP HUB] ✓ Combo part: " .. sub.name)
            else
                Notify("❌ Combo Failed", sub.name .. ": " .. tostring(err), 5)
                PlaySound("error")
            end
            if i < #script.combo then task.wait(1.2) end
        end

        if success > 0 then
            SP.Stats.loaded = SP.Stats.loaded + success
            SaveStats()
            for i = #SP.Recent, 1, -1 do
                if SP.Recent[i].id == script.id then table.remove(SP.Recent, i) end
            end
            table.insert(SP.Recent, 1, { id = script.id, name = script.name, time = os.time() })
            while #SP.Recent > 5 do table.remove(SP.Recent) end
            SaveRecent()
            PlaySound("combo", 0.55)
            Notify("🔥 Combo Success", success .. "/" .. #script.combo .. " scripts loaded!", 5)
        else
            SP.Stats.failed = SP.Stats.failed + 1
            SaveStats()
        end
        return
    end

    Notify("⏳ Loading", script.name .. "...", 3)
    local ok, err = false, nil
    for attempt = 1, 2 do
        ok, err = pcall(function()
            local src = game:HttpGet(script.url)
            assert(type(src) == "string" and #src > 50, "Empty or invalid source")
            local fn = loadstring(src)
            assert(fn, "Failed to compile")
            fn()
        end)
        if ok then break end
        if attempt < 2 then task.wait(0.35) end
    end

    if ok then
        SP.Stats.loaded = SP.Stats.loaded + 1
        SaveStats()
        for i = #SP.Recent, 1, -1 do
            if SP.Recent[i].id == script.id then table.remove(SP.Recent, i) end
        end
        table.insert(SP.Recent, 1, { id = script.id, name = script.name, time = os.time() })
        while #SP.Recent > 5 do table.remove(SP.Recent) end
        SaveRecent()
        PlaySound("success")
        Notify("✅ Success", script.name .. " loaded successfully!", 4)
        print("[SP HUB] ✓ Loaded: " .. script.name)
    else
        SP.Stats.failed = SP.Stats.failed + 1
        SaveStats()
        PlaySound("error")
        Notify("❌ Failed", script.name .. "\n" .. tostring(err), 6)
        warn("[SP HUB] ✗ Failed: " .. tostring(err))
    end
end

--===================== UNLOAD =====================
local function CloseLoadedScripts()
    local cleaned = 0
    local roots = {}
    pcall(function()
        table.insert(roots, game:GetService("CoreGui"))
        if gethui then table.insert(roots, gethui()) end
        local lp = Players.LocalPlayer
        if lp and lp:FindFirstChild("PlayerGui") then table.insert(roots, lp.PlayerGui) end
    end)

    local keywords = {
        "rayfield","fluent","orchid","linoria","venyx","chilli",
        "codium","fyy","hub","script","ui","menu","window",
        "library","nyx","tenshi",
    }

    for _, root in ipairs(roots) do
        if root then
            for _, child in ipairs(root:GetChildren()) do
                if child.Name ~= "Rayfield" then
                    local lname = tostring(child.Name):lower()
                    for _, kw in ipairs(keywords) do
                        if lname:find(kw, 1, true) then
                            pcall(function()
                                child:Destroy()
                                cleaned = cleaned + 1
                            end)
                            break
                        end
                    end
                end
            end
        end
    end
    pcall(function()
        if getgenv then
            getgenv().SP_Unload = true
            getgenv().Unload   = true
        end
    end)
    return cleaned
end

--===================== UI BUILDER =====================
local CardIcons = {}

local function BuildScriptCard(tab, script)
    local isFav  = SP.Favorites[script.id] == true
    local prefix = isFav and "⭐ " or ""

    if script.icon then
        table.insert(CardIcons, { title = script.name, file = script.icon })
    end

    tab:CreateSection(prefix .. script.name)
    tab:CreateParagraph({
        Title   = "📌 " .. script.name,
        Content = script.desc,
    })

    tab:CreateButton({
        Name = "▶  EXECUTE — ចុចដើម្បីបើក Script",
        Callback = function()
            PlaySound("click")
            LoadScript(script)
        end,
    })

    if script.url then
        tab:CreateButton({
            Name = "📋  COPY — ចម្លង Script",
            Callback = function()
                SP.Stats.copied = SP.Stats.copied + 1
                SaveStats()
                CopyLink(script.name, 'loadstring(game:HttpGet("' .. script.url .. '"))()')
            end,
        })
    end

    tab:CreateToggle({
        Name         = "⭐ Favorite — ដាក់ក្នុង Favorites",
        CurrentValue = isFav,
        Callback = function(value)
            if value then
                SP.Favorites[script.id] = true
                PlaySound("fav")
                Notify("⭐ Added", script.name .. " ដាក់ក្នុង Favorites", 2)
            else
                SP.Favorites[script.id] = nil
                Notify("☆ Removed", script.name .. " ដកចេញពី Favorites", 2)
            end
            SaveFavorites()
        end,
    })
end

--===================== HOME / QUICK LAUNCH =====================
local HomeTab = Window:CreateTab("🏠 Home", "home")

HomeTab:CreateSection("🚀 Quick Launch")
HomeTab:CreateParagraph({
    Title   = "Welcome to SP HUB " .. BUILD,
    Content = "Version: " .. VERSION .. " | Developer: Sopha Panha\nជ្រើសរើស script ខាងក្រោម ហើយចុច EXECUTE តែម្តង។",
})

local dropdownOptions = {}
for _, s in ipairs(SCRIPT_REGISTRY) do
    local p = SP.Favorites[s.id] and "⭐ " or ""
    table.insert(dropdownOptions, p .. s.name)
end

local quickSelected = nil

HomeTab:CreateDropdown({
    Name            = "🎯 Select script",
    Options         = dropdownOptions,
    MultipleOptions = false,
    Flag            = "QuickLaunchSelect",
    Callback = function(option)
        if type(option) == "table" then option = option[1] end
        if option then quickSelected = tostring(option):gsub("^⭐ ", "") end
    end,
})

HomeTab:CreateButton({
    Name = "▶  QUICK EXECUTE — បើកភ្លាម",
    Callback = function()
        if not quickSelected then
            Notify("⚠️ No Selection", "សូមជ្រើសរើស script មុនសិន", 3)
            return
        end
        PlaySound("click")
        local script = FindScriptByName(quickSelected)
        if script then LoadScript(script) end
    end,
})

HomeTab:CreateButton({
    Name = "📋  QUICK COPY — ចម្លងភ្លាម",
    Callback = function()
        if not quickSelected then
            Notify("⚠️ No Selection", "សូមជ្រើសរើស script មុនសិន", 3)
            return
        end
        local script = FindScriptByName(quickSelected)
        if script and script.url then
            SP.Stats.copied = SP.Stats.copied + 1
            SaveStats()
            CopyLink(script.name, 'loadstring(game:HttpGet("' .. script.url .. '"))()')
        end
    end,
})

--===================== CATEGORY TABS =====================
for _, cat in ipairs(CATEGORIES) do
    local tab = Window:CreateTab(cat.name, cat.icon)
    tab:CreateParagraph({
        Title   = "⚡ Version ចុងក្រោយ: " .. VERSION,
        Content = cat.desc,
    })
    for _, script in ipairs(SCRIPT_REGISTRY) do
        if script.cat == cat.name then
            BuildScriptCard(tab, script)
        end
    end
end

--===================== FAVORITES TAB =====================
local FavTab = Window:CreateTab("⭐ Favorites", "star")
FavTab:CreateParagraph({
    Title   = "Favorites",
    Content = "Script សំណព្វរបស់អ្នក។ (សូម restart hub ដើម្បី refresh tab នេះ)",
})

local favCount = 0
for _, script in ipairs(SCRIPT_REGISTRY) do
    if SP.Favorites[script.id] then
        BuildScriptCard(FavTab, script)
        favCount = favCount + 1
    end
end
if favCount == 0 then
    FavTab:CreateParagraph({
        Title   = "មិនទាន់មាន Favorites",
        Content = "ចុច ⭐ toggle នៅលើ script ណាមួយ ដើម្បីបន្ថែមទៅ Favorites។",
    })
end

--===================== RECENT TAB =====================
local RecentTab = Window:CreateTab("🕒 Recent", "clock")
RecentTab:CreateParagraph({
    Title   = "Recent Scripts",
    Content = "Script ដែលអ្នកបើកចុងក្រោយ (រក្សាទុក 5 ចុងក្រោយ)។",
})

if #SP.Recent == 0 then
    RecentTab:CreateParagraph({
        Title   = "គ្មានប្រវត្តិ",
        Content = "Script ដែលអ្នកបើកនឹងបង្ហាញនៅទីនេះ។",
    })
else
    for _, entry in ipairs(SP.Recent) do
        local script = FindScriptByName(entry.name)
        if script then
            BuildScriptCard(RecentTab, script)
        end
    end
end

--===================== STATS TAB =====================
local StatsTab = Window:CreateTab("📊 Stats", "bar-chart")
StatsTab:CreateSection("📈 Usage Statistics")
StatsTab:CreateParagraph({
    Title   = "Session Overview",
    Content = string.format(
        "✅ Scripts Loaded : %d\n❌ Failed Loads   : %d\n📋 Copies Made    : %d\n⭐ Favorites      : %d\n🕒 Recent         : %d",
        SP.Stats.loaded or 0,
        SP.Stats.failed or 0,
        SP.Stats.copied or 0,
        CountFavorites(),
        #SP.Recent
    ),
})
StatsTab:CreateButton({
    Name = "🔄  RESET STATISTICS",
    Callback = function()
        SP.Stats = { loaded = 0, failed = 0, copied = 0 }
        SaveStats()
        Notify("🔄 Reset", "Statistics ត្រូវបាន reset", 3)
    end,
})

--===================== SUPPORT TAB =====================
local SupportTab = Window:CreateTab("❤️ Support", "heart")
SupportTab:CreateSection("❤ SUPPORT ADMIN")
SupportTab:CreateParagraph({
    Title   = "ជួយឧបត្ថម្ភ Admin 💖",
    Content = "ជួយឱ្យយើងធ្វើ Link & Script ថ្មីៗបន្ត។ ចំនួនប៉ុន្មានក៏បាន សូមអរគុណ!",
})
SupportTab:CreateButton({
    Name = "🌐 Copy Website (Donate + Top Supporters)",
    Callback = function() CopyLink("Website link", "https://sp-roblox.vercel.app") end,
})
SupportTab:CreateButton({
    Name = "✈️ Contact Admin: @sophapanha",
    Callback = function() CopyLink("Telegram link", "https://t.me/sophapanha") end,
})

--===================== INFO TAB =====================
local InfoTab = Window:CreateTab("ℹ️ Info", "info")
InfoTab:CreateSection("DEVELOPER")
InfoTab:CreateParagraph({
    Title   = "SP ROBLOX SCRIPT " .. BUILD,
    Content = "Developer: Sopha Panha (@sophapanha)\nVersion: " .. VERSION .. "\nDownload Apps & Utilities",
})
InfoTab:CreateSection("SOCIAL MEDIA")
InfoTab:CreateButton({
    Name = "▶️  YouTube: @sp_roblox1",
    Callback = function() CopyLink("YouTube link", "https://youtube.com/@sp_roblox1") end,
})
InfoTab:CreateButton({
    Name = "✈️  Telegram Channel: @SPROBLOX",
    Callback = function() CopyLink("Telegram link", "https://t.me/SPROBLOX") end,
})
InfoTab:CreateButton({
    Name = "🌐  SP ROBLOX Website",
    Callback = function() CopyLink("Website link", "https://sp-roblox.vercel.app") end,
})

--===================== SETTINGS TAB =====================
local SettingsTab = Window:CreateTab("⚙️ Settings", "settings")

SettingsTab:CreateSection("UI CONTROL")
SettingsTab:CreateButton({
    Name = "📌  RESET UI POSITION (ទាញមកកណ្តាល)",
    Callback = function()
        ResetUIPosition()
        Notify("🛠️ Fixed", "UI ត្រូវបានទាញមកកណ្តាលវិញ", 3)
    end,
})
SettingsTab:CreateButton({
    Name = "📌  MINIMIZE UI (Safe Mode)",
    Callback = function()
        pcall(function()
            Window:ToggleMinimise()
        end)
    end,
})

--══════════ 🎵 SOUND SETTINGS ══════════
SettingsTab:CreateSection("🎵 SOUND SETTINGS")
SettingsTab:CreateToggle({
    Name         = "Enable Sound Effects",
    CurrentValue = true,
    Flag         = "SP_SoundEnabled",
    Callback = function(value)
        SOUND_ENABLED = value
        if value then PlaySound("click") end
        Notify("🔊 Sound", value and "ដំណើរការ" or "បិទ", 2)
    end,
})

--══════════ 🔒 KEY SYSTEM ══════════
SettingsTab:CreateSection("🔒 KEY SYSTEM")
SettingsTab:CreateButton({
    Name = "🚪  LOGOUT — Clear Saved Key",
    Callback = function()
        local keyPath = CONFIG_FOLDER .. "/SP_Hub_Key.json"
        pcall(function()
            if delfile and isfile and isfile(keyPath) then
                delfile(keyPath)
            end
        end)
        Notify("🚪 Logged Out", "Key cleared. Restart hub to enter new key.", 4)
    end,
})

--══════════ SCRIPT CONTROL ══════════
SettingsTab:CreateSection("SCRIPT CONTROL")
SettingsTab:CreateParagraph({
    Title   = "Unload Script",
    Content = "បើអ្នកចង់ប្តូរ Script ថ្មី សូមចុចប៊ូតុងខាងក្រោមដើម្បីបិទ Script ចាស់សិន (best effort)។",
})
SettingsTab:CreateButton({
    Name = "🛑  CLOSE / UNLOAD SCRIPT",
    Callback = function()
        local count = CloseLoadedScripts()
        if count > 0 then
            Notify("🧹 Cleaned", "បានបិទ Script ប្រហែល " .. count .. " UI(s)", 4)
        else
            Notify("ℹ️ Info", "រកមិនឃើញ Script UI ផ្សេង (ឬបានបិទរួច)", 4)
        end
    end,
})

SettingsTab:CreateSection("CLOSE HUB")
SettingsTab:CreateButton({
    Name = "❌  CLOSE SP ROBLOX HUB",
    Callback = function() Rayfield:Destroy() end,
})

--===================== 🔤 APPLY KHMER FONT =====================
local function ApplyKhmerFont()
    pcall(function()
        local Root = (gethui and gethui()) or game:GetService("CoreGui")
        local RayfieldGui = Root:FindFirstChild("Rayfield")
        if not RayfieldGui then return end
        local MainFrame = RayfieldGui:FindFirstChild("Main")
        if not MainFrame then return end

        for _, obj in ipairs(MainFrame:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                pcall(function()
                    -- ប្រើ Font ខ្មែរស្តង់ដាររបស់ Roblox (Siemreap) ដែលអានស្រួល
                    obj.Font = Enum.Font.Siemreap
                    obj.TextSize = obj.TextSize + 1 -- បង្កើនទំហំអក្សរបន្តិចឱ្យអានងាយ
                    
                    -- ⚠️ ប្រសិនបើអ្នកមាន Asset ID របស់ Kantumruy Pro សូមលុប -- ខាងក្រោមចេញ ហើយដាក់ ID របស់អ្នក
                    -- local fontFace = Font.new("rbxassetid://YOUR_KANTUMRUY_ID_HERE")
                    -- obj.FontFace = fontFace
                end)
            end
        end
        print("[SP HUB] ✓ Khmer Font applied")
    end)
end

-- ពន្យារពេលបន្តិចឱ្យ UI បង្កើតចប់សិន រួចប្តូរ Font
task.delay(1, ApplyKhmerFont)

--===================== ASYNC LOGO LOADER =====================
task.spawn(function()
    task.wait(1.2)
    local ok, err = pcall(function()
        if not writefile or not getcustomasset then
            error("Executor គ្មាន writefile/getcustomasset")
        end
        local data = game:HttpGet(ICON_BASE .. "logo.png")
        if #data < 200 then error("ទាញ logo បរាជ័យ") end
        writefile("SP_logo.png", data)
        local asset = getcustomasset("SP_logo.png")

        local root = (gethui and gethui()) or game:GetService("CoreGui")
        local ray  = root:FindFirstChild("Rayfield")
        if not ray then
            for _, c in ipairs({
                game:GetService("CoreGui"),
                Players.LocalPlayer:FindFirstChild("PlayerGui"),
            }) do
                if c and c:FindFirstChild("Rayfield") then
                    ray = c.Rayfield
                    break
                end
            end
        end
        if not ray then error("រកមិនឃើញ Rayfield GUI") end
        local topbar = ray.Main:FindFirstChild("Topbar")
        local icon   = topbar and topbar:FindFirstChild("Icon", true)
        if not icon then error("រកមិនឃើញ Icon ក្នុង Topbar") end
        icon.Image             = asset
        icon.ImageTransparency = 0
        icon.Visible           = true
    end)
    if ok then
        print("[SP HUB] ✓ Logo loaded")
    else
        warn("[SP HUB] Logo loader: " .. tostring(err))
    end
end)

--===================== ASYNC CARD ICON LOADER =====================
task.spawn(function()
    task.wait(2.2)
    if not (writefile and getcustomasset) then return end

    local root = (gethui and gethui()) or game:GetService("CoreGui")
    local ray  = root:FindFirstChild("Rayfield")
    if not ray then
        for _, c in ipairs({
            game:GetService("CoreGui"),
            Players.LocalPlayer:FindFirstChild("PlayerGui"),
        }) do
            if c and c:FindFirstChild("Rayfield") then
                ray = c.Rayfield
                break
            end
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
        img.Name                   = "SPIcon"
        img.BackgroundTransparency = 1
        img.AnchorPoint            = Vector2.new(1, 0.5)
        img.Position               = UDim2.new(1, -12, 0.5, 0)
        img.Size                   = UDim2.new(0, 40, 0, 40)
        img.Image                  = asset
        img.ScaleType              = Enum.ScaleType.Fit
        img.ZIndex                 = 10
        img.Parent                 = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent       = img

        local stroke = Instance.new("UIStroke")
        stroke.Color        = Color3.fromRGB(45, 226, 200)
        stroke.Thickness    = 1.2
        stroke.Transparency = 0.5
        stroke.Parent       = img
    end

    for _, item in ipairs(CardIcons) do
        pcall(function()
            local asset  = getAsset(item.file)
            local target = (item.title or ""):gsub("%s+", " "):match("^%s*(.-)%s*$")

            for _, obj in ipairs(ray.Main:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Name == "Title" then
                    local text = (obj.Text or ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
                    if text == target then
                        local parent = obj.Parent
                        while parent and parent ~= ray.Main do
                            if parent:IsA("Frame") then
                                if parent:FindFirstChild("Content") or parent:FindFirstChild("Title")
                                    or (parent.Name and (
                                        parent.Name:lower():find("paragraph")
                                        or parent.Name:lower():find("section")
                                    ))
                                then
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
    print("[SP HUB] ✓ Script icons loaded")
end)

--===================== WELCOME + STARTUP SOUND =====================
task.wait(0.3)
PlaySound("startup", 0.5)

Notify("🎉 SP ROBLOX HUB " .. BUILD,
    "Welcome!\nFavorites: " .. CountFavorites() .. " | Version: " .. VERSION,
    6)

print("╔══════════════════════════════════════════╗")
print("║  ✓ SP ROBLOX SCRIPT HUB " .. BUILD .. " loaded")
print("║  Developer: Sopha Panha")
print("║  Status: Ready")
print("╚══════════════════════════════════════════╝")
