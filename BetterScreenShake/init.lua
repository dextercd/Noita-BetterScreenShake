local ffi = require("ffi")

ffi.cdef([[
typedef struct SDL_Window SDL_Window;
SDL_Window* SDL_GL_GetCurrentWindow();
void SDL_GetWindowPosition(SDL_Window* window, int* x, int* y);
void SDL_SetWindowPosition(SDL_Window* window, int x, int y);
]])

local SDL2 = ffi.load("SDL2")

local window

function OnWorldInitialized()
    window = SDL2.SDL_GL_GetCurrentWindow()
end

local function screenshake_strength()
    local GG = 0x012216cc
    return ffi.cast("float***", GG)[0][3][22]
end

local function window_get_pos(w)
    local coord = ffi.new("int[2]")
    SDL2.SDL_GetWindowPosition(w, coord, coord+1)
    return coord[0], coord[1]
end

local function window_set_pos(w, x, y)
    SDL2.SDL_SetWindowPosition(w, x, y)
end

local dir = 0
local next_dir_frames = 0

local last_strength = 0

function OnWorldPreUpdate()
    if window == nil then
        return
    end

    local this_strength = screenshake_strength()

    next_dir_frames = next_dir_frames - 1
    if next_dir_frames <= 0 or this_strength > last_strength then
        local cx, cy = GameGetCameraPos()
        SetRandomSeed(GameGetFrameNum(), cx + cy)
        dir = dir + math.pi + (Random()-0.5) * math.pi/2
        dir = math.fmod(dir, 2 * math.pi)
        if dir < 0 then
            dir = 2*math.pi - dir
        end
        next_dir_frames = Random(2, 5)
    end

    local effective = math.sqrt(this_strength * 8)
    if effective > 1 then
        local dy = math.sin(dir) * effective
        local dx = math.cos(dir) * effective
        local x, y = window_get_pos(window)
        window_set_pos(window, x + dx, y + dy)
    end

    last_strength = this_strength
end
