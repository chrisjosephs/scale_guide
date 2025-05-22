-- @description Microtonal Scale Guide Generator (EDO-based)
-- @version 0.1
-- @author GPT
-- @about Creates ghost note guides for microtonal scales using ReaImGui
-- @provides
--   [main] . > Microtonal Scale Guide Generator.lua
-- @requires js_ReaImGui, SWS Extension

local ctx = reaper.ImGui_CreateContext('Microtonal Scale Guide Generator', reaper.ImGui_ConfigFlags_AlwaysAutoResize())
local visible = true
local edo = 12
local step_input = "0, 2, 4, 5, 7, 9, 11"
local root_note = 60
local num_octaves = 5
local duration_seconds = 20 * 60
local scale_name = ""
local scale_presets = {}
local scale_file = reaper.GetResourcePath() .. "/MicrotonalScales.lua"

-- Load scale presets
local function load_scales()
  local f = io.open(scale_file, "r")
  if f then
    local chunk = f:read("*a")
    f:close()
    local ok, loaded = pcall(load("return " .. chunk))
    if ok and type(loaded) == "table" then
      scale_presets = loaded
    end
  end
end

local function save_scales()
  local f = io.open(scale_file, "w")
  if f then
    f:write("return \
")
    f:write(reaper.serialize(scale_presets))
    f:close()
  end
end

-- Serialize helper
function reaper.serialize(t)
  local function serialize_val(val)
    if type(val) == "number" then return tostring(val)
    elseif type(val) == "string" then return string.format('%q', val)
    elseif type(val) == "table" then return reaper.serialize(val)
    end
  end

  local parts = {"{"}
  for k, v in pairs(t) do
    table.insert(parts, string.format("[%q]=%s,", k, serialize_val(v)))
  end
  table.insert(parts, "}")
  return table.concat(parts, "\n")
end

local function parse_steps(input)
  local steps = {}
  for s in input:gmatch("%d+") do
    table.insert(steps, tonumber(s))
  end
  return steps
end

local function create_guide_notes(edo, steps, root, octaves, duration)
  reaper.Undo_BeginBlock()

  local track = reaper.GetSelectedTrack(0, 0)
  if not track then
    track = reaper.InsertTrackAtIndex(reaper.CountTracks(0), true)
    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "Scale Guide", true)
  end

  local item = reaper.CreateNewMIDIItemInProj(track, 0, duration, false)
  local take = reaper.GetMediaItemTake(item, 0)
  local ppq_start = reaper.MIDI_GetPPQPosFromProjTime(take, 0)
  local ppq_end = reaper.MIDI_GetPPQPosFromProjTime(take, duration)

  for octave = 0, octaves - 1 do
    for _, step in ipairs(steps) do
      local note = root + math.floor((octave * edo + step) * 12 / edo + 0.5)
      reaper.MIDI_InsertNote(take, false, false, ppq_start, ppq_end, 0, note, 100, false)
    end
  end

  reaper.MIDI_Sort(take)
  reaper.Undo_EndBlock("Create Microtonal Scale Guide", -1)
end

load_scales()

function loop()
  if not visible then return end

  reaper.ImGui_SetNextWindowSize(ctx, 400, 250, reaper.ImGui_Cond_FirstUseEver())
  local rv, open = reaper.ImGui_Begin(ctx, 'Microtonal Scale Guide Generator', true)
  if not open then
    visible = false
    reaper.ImGui_End(ctx)
    return
  end

  _, edo = reaper.ImGui_InputInt(ctx, "EDO (equal divisions of octave)", edo)
  _, step_input = reaper.ImGui_InputText(ctx, "Scale steps (comma-separated)", step_input)
  _, root_note = reaper.ImGui_InputInt(ctx, "Root MIDI note (e.g. 60 = C4)", root_note)
  _, num_octaves = reaper.ImGui_InputInt(ctx, "Number of octaves", num_octaves)

  if reaper.ImGui_Button(ctx, "Generate Guide Notes") then
    local steps = parse_steps(step_input)
    create_guide_notes(edo, steps, root_note, num_octaves, duration_seconds)
  end

  reaper.ImGui_Separator(ctx)

  _, scale_name = reaper.ImGui_InputText(ctx, "Scale Name", scale_name)
  if reaper.ImGui_Button(ctx, "Save Scale") and scale_name ~= "" then
    scale_presets[scale_name] = { edo = edo, steps = parse_steps(step_input) }
    save_scales()
  end

  reaper.ImGui_SameLine(ctx)
  if reaper.ImGui_Button(ctx, "Load Scale") and scale_presets[scale_name] then
    local preset = scale_presets[scale_name]
    edo = preset.edo
    step_input = table.concat(preset.steps, ", ")
  end

  reaper.ImGui_End(ctx)
  reaper.defer(loop)
end

reaper.defer(loop)
