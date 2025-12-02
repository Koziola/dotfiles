
-- Reload config with alt + r
hs.hotkey.bind({"alt"}, "r", function()
  hs.reload()
end)

windowMappings = {}

-- Function to capture focused window and bind it to a hotkey
function setWindowHotkey(hotkey)
    -- Get the focused window
    local focusedWindow = hs.window.focusedWindow()

    -- Check if a window is focused
    if focusedWindow then
        local appName = focusedWindow:application():name()
        local windowId = focusedWindow:id()
        windowMappings[hotkey] = {appName = appName, windowId = windowId}
        hs.alert.show("Set " .. hotkey .. " for " .. appName .. " (Window ID: " .. windowId .. ")")
    else
        hs.alert.show("No focused window to map. Verify hammerspoon accessibility is turned on in System Settings > Privacy & Security > Accessibility.")
    end
end

-- Function to focus the mapped window for a specific hotkey
function focusMappedWindow(hotkey)
    local mapping = windowMappings[hotkey]
    if mapping then
        local appName = mapping.appName
        local windowId = mapping.windowId
        
        local app = hs.appfinder.appFromName(appName)
        if app then
            app:activate()
            local window = hs.window.find(windowId)
            if window then
                window:focus()
            else
                hs.alert.show("Window not found.")
            end
        end
    else
        hs.alert.show("No window mapped to " .. hotkey)
    end
end

-- Example: Set hotkey combinations to tag a window
hs.hotkey.bind({"cmd", "alt"}, "m", function() setWindowHotkey("alt+m") end)
hs.hotkey.bind({"cmd", "alt"}, ",", function() setWindowHotkey("alt+,") end)
hs.hotkey.bind({"cmd", "alt"}, ".", function() setWindowHotkey("alt+.") end)
hs.hotkey.bind({"cmd", "alt"}, "/", function() setWindowHotkey("alt+/") end)

-- Example: Focus the window using assigned hotkeys
hs.hotkey.bind({"alt"}, "m", function() focusMappedWindow("alt+m") end)
hs.hotkey.bind({"alt"}, ",", function() focusMappedWindow("alt+,") end)
hs.hotkey.bind({"alt"}, ".", function() focusMappedWindow("alt+.") end)
hs.hotkey.bind({"alt"}, "/", function() focusMappedWindow("alt+/") end)
