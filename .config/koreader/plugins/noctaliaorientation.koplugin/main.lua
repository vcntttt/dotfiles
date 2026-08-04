local UIManager = require("ui/uimanager")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local logger = require("logger")
local rapidjson = require("rapidjson")

local HORIZONTAL_EVENT = "NoctaliaMonitorHorizontal"
local VERTICAL_EVENT = "NoctaliaMonitorVertical"
local POLL_INTERVAL = 1

local NoctaliaOrientation = WidgetContainer:extend{
    name = "noctaliaorientation",
    is_doc_only = false,
    poll_action = nil,
    registered_triggers = false,
    last_event = nil,
}

local function command_json(command)
    local pipe = io.popen(command .. " 2>/dev/null", "r")
    if not pipe then
        return nil
    end

    local raw = pipe:read("*a")
    pipe:close()
    if not raw or raw == "" then
        return nil
    end

    local ok, decoded = pcall(rapidjson.decode, raw)
    return ok and decoded or nil
end

local function is_koreader_client(client)
    local class = client.class or client.initialClass or ""
    local title = client.title or ""
    return class == "KOReader"
        or class:lower():find("koreader", 1, true) ~= nil
        or title == "KOReader"
        or title:match(" %- KOReader$") ~= nil
end

function NoctaliaOrientation:init()
    self.poll_action = function()
        self:poll()
    end

    UIManager:scheduleIn(POLL_INTERVAL, self.poll_action)
    self:registerProfileTriggers()
end

function NoctaliaOrientation:registerProfileTriggers()
    if self.registered_triggers then
        return true
    end

    local profiles = self.ui.profiles
    if not profiles then
        return false
    end

    profiles:registerAutoExecTrigger{
        event = HORIZONTAL_EVENT,
        text = "Noctalia: monitor horizontal",
    }
    profiles:registerAutoExecTrigger{
        event = VERTICAL_EVENT,
        text = "Noctalia: monitor vertical",
    }
    self.registered_triggers = true
    return true
end

function NoctaliaOrientation:find_koreader_monitor(monitors)
    local clients = command_json("hyprctl clients -j")
    if not clients then
        return nil
    end

    for _, client in ipairs(clients) do
        if is_koreader_client(client) then
            for _, monitor in ipairs(monitors) do
                if tostring(monitor.id) == tostring(client.monitor) then
                    return monitor
                end
            end
        end
    end

    return nil
end

function NoctaliaOrientation:poll(force)
    self:registerProfileTriggers()

    local profiles = self.ui.profiles
    if not profiles or not self.ui.document then
        UIManager:scheduleIn(POLL_INTERVAL, self.poll_action)
        return
    end

    local monitors = command_json("hyprctl monitors all -j")
    if not monitors then
        UIManager:scheduleIn(POLL_INTERVAL, self.poll_action)
        return
    end

    local monitor = self:find_koreader_monitor(monitors)
    if not monitor then
        UIManager:scheduleIn(POLL_INTERVAL, self.poll_action)
        return
    end

    local transform = tonumber(monitor.transform) or 0
    local event = transform % 2 == 1 and VERTICAL_EVENT or HORIZONTAL_EVENT
    if force or event ~= self.last_event then
        logger.info("NoctaliaOrientation: applying", event, "for", monitor.name, "transform", transform)
        profiles:executeAutoExecEvent(event)
        self.last_event = event
    end

    UIManager:scheduleIn(POLL_INTERVAL, self.poll_action)
end

function NoctaliaOrientation:onReaderReady()
    self:poll(true)
end

function NoctaliaOrientation:stopPlugin()
    if self.poll_action then
        UIManager:unschedule(self.poll_action)
    end
end

return NoctaliaOrientation
