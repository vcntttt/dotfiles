-- Input configuration

local input = {
    kb_layout = HOST_KB_LAYOUT or "us",
    kb_options = HOST_KB_OPTIONS or "compose:caps",
    accel_profile = HOST_ACCEL_PROFILE or "flat",
}

if HOST_TOUCHPAD then
    input.touchpad = HOST_TOUCHPAD
end

hl.config({
    input = input,
    -- Uncomment the section below to enable software cursors; this can help with cursor display or behavior issues
    -- cursor = {
    --     no_hardware_cursors = 1,
    -- },
})

if HOST_GESTURES then
    hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
    hl.gesture({ fingers = 3, direction = "down",       action = "close" })
    hl.gesture({ fingers = 3, direction = "up",         action = "fullscreen" })
    hl.gesture({ fingers = 3, direction = "left",       action = "float" })
end
