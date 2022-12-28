local feline = require('feline')
local lsp = require('feline.providers.lsp')
local git = require('feline.providers.git')
local icons = require('nvim-web-devicons')
local vi_mode = require('feline.providers.vi_mode')

local getwin = vim.api.nvim_get_current_win

local M = {}

-- reference
--
-- black
-- bg0
-- bg1
-- bg2
-- bg3
-- bg4
-- bg_red
-- diff_red
-- bg_green
-- diff_green
-- bg_blue
-- diff_blue
-- diff_yellow
-- fg
-- red
-- orange
-- yellow
-- green
-- blue
-- purple
-- grey
-- none
local colors = {}
local function setupcolors()
    local cols = vim.fn["sonokai#get_palette"](vim.g.sonokai_style)
    for key, val in pairs(cols) do
        colors[key] = val[1]
    end
end
setupcolors()

M.colors = colors

local nightfox = require('nightfox.colors').init()
M.nightfox = nightfox

local vi_mode_colors = {
    NORMAL = nightfox.blue,
    OP = nightfox.blue,
    INSERT = nightfox.green,
    VISUAL = nightfox.magenta_br,
    LINES = nightfox.magenta_br,
    BLOCK = nightfox.magenta_br,
    REPLACE = nightfox.yellow_br,
    ['V-REPLACE'] = nightfox.yellow_br,
    ENTER = nightfox.blue,
    MORE = nightfox.blue,
    SELECT = nightfox.yellow_br,
    COMMAND = nightfox.orange_br,
    SHELL = nightfox.blue,
    TERM = nightfox.blue,
    NONE = nightfox.orange_br,
}

M.vi_mode_colors = vi_mode_colors

local vi_mode_icon = {
    NORMAL = 'N',
    OP = 'N',
    INSERT = 'I',
    VISUAL = 'V',
    LINES = 'VL',
    BLOCK = 'VB',
    REPLACE = 'R',
    ['V-REPLACE'] = 'VR',
    ENTER = 'N',
    MORE = 'N',
    SELECT = 'S',
    COMMAND = 'C',
    SHELL = 'T',
    TERM = 'T',
    NONE = " ",
}

local function file_osinfo()
    local os = vim.bo.fileformat:upper()
    local icon
    if os == 'UNIX' then
        icon = ''
    elseif os == 'MAC' then
        icon = ''
    else
        icon = ''
    end
    return icon
end

local function error_level()
    local levels = { "ERROR", "WARN", "INFO", "HINT", }
    for _, level in ipairs(levels) do
        if lsp.diagnostics_exist(level) then return level end
    end
    return nil
end

local function error_bg(greyscale)
    local color_map = {
        ERROR = nightfox.error,
        WARN = nightfox.warning,
        INFO = nightfox.info,
        HINT = nightfox.hint,
    }
    if greyscale and error_level() then
        return nightfox.bg_search
    elseif error_level() then
        return color_map[error_level()]
    else
        return nightfox.bg_statusline
    end
end

local function is_highest_error(level)
    return level == error_level()
end

local function error_sep_curried(level, greyscale)
    return function()
        local is_highest = is_highest_error(level)
        if is_highest then
            return {
                str = 'left_filled',
                hl = {fg = error_bg(greyscale)},
            }
        else
            return {
                str = 'left',
                hl = {fg = nightfox.bg_statusline, bg = error_bg(greyscale)},
            }
        end
    end
end

local function makesep(sep, bg, fg)
    return function()
        local resolve_bg = (type(bg) == 'function') and bg() or bg
        local resolve_fg = (type(fg) == 'function') and fg() or fg
        return {str = sep, hl = {bg = resolve_bg, fg = resolve_fg}}
    end
end

local components = {
    active = {
        {},
        {},
    },
    inactive = {
        {},
        {},
    }
}

--- left side

table.insert(components.active[1], {
    provider = function()
        return vi_mode_icon[vi_mode.get_vim_mode()] .. ' '
    end,
    hl = function()
        local hl = {}
        hl.fg = nightfox.black
        hl.bg = vi_mode_colors[vi_mode.get_vim_mode()]
        hl.style = 'bold'
        return hl
    end,
    left_sep = function()
        return {str = ' ', hl = {bg = vi_mode_colors[vi_mode.get_vim_mode()]}}
    end,
    right_sep = makesep(
        'right_filled',
        nightfox.bg_visual,
        function() return vi_mode_colors[vi_mode.get_vim_mode()] end
    ),
})

table.insert(components.active[1], {
    provider = function()
        local filename = vim.fn.expand('%:.')
        local extension = vim.fn.expand('%:e')
        local fileicon = icons.get_icon(filename, extension, {default = true})
        local modifiedicon = vim.bo.modified and ' ' or ''
        local readonlyicon = (vim.bo.readonly or not vim.bo.modifiable) and ' ' or ''
        return fileicon .. ' ' .. filename .. modifiedicon .. readonlyicon .. ' '
    end,
    hl = function()
        return {
            fg = vim.bo.modified and nightfox.yellow or nightfox.fg,
            bg = nightfox.bg_visual,
            style = vim.bo.modified and 'bold' or nil,
        }
    end,
    left_sep = {str = ' ', hl = {bg = nightfox.bg_visual}},
    right_sep = 'right_filled',
})

table.insert(components.active[1], {
    provider = function()
        return vim.b.lsp_current_function or ''
    end,
    left_sep = ' ',
    right_sep = {' ', {str = 'right', hl = {fg = nightfox.black}},},
    enabled = function()
        return (
            (#vim.lsp.buf_get_clients() > 0)
            and vim.b.lsp_current_function
            and vim.b.lsp_current_function ~= ''
        )
    end,
    hl = {fg = nightfox.black},
})

--- right side

table.insert(components.active[2], {
    provider = function()
        local count, icon = lsp.diagnostic_errors()
        return icon .. count .. ' '
    end,
    enabled = function() return lsp.diagnostics_exist('ERROR') end,
    left_sep = {
        str = 'left_filled',
        hl = {fg = nightfox.error},
    },
    hl = function() return {fg = nightfox.bg_statusline, bg = error_bg()} end,
})

table.insert(components.active[2], {
    provider = function()
        local count, icon = lsp.diagnostic_warnings()
        return icon .. count .. ' '
    end,
    enabled = function() return lsp.diagnostics_exist('WARN') end,
    left_sep = error_sep_curried('WARN'),
    hl = function() return {fg = nightfox.bg_statusline, bg = error_bg()} end,
})

table.insert(components.active[2], {
    provider = function()
        local count, icon = lsp.diagnostic_hints()
        return icon .. count .. ' '
    end,
    enabled = function() return lsp.diagnostics_exist('HINT') end,
    left_sep = error_sep_curried('HINT'),
    hl = function() return {fg = nightfox.bg_statusline, bg = error_bg()} end,
})

table.insert(components.active[2], {
    provider = function()
        local count, icon = lsp.diagnostic_info()
        return icon .. count .. ' '
    end,
    enabled = function() return lsp.diagnostics_exist('INFO') end,
    left_sep = error_sep_curried('INFO'),
    hl = function() return {fg = nightfox.bg_statusline, bg = error_bg()} end,
})

table.insert(components.active[2], {
    provider = function()
        local branch, icon = git.git_branch({}, getwin())
        return ' ' .. icon .. branch
    end,
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and gsd.head and #gsd.head > 0
    end,
    left_sep = function()
        return {
            str = 'left_filled',
            hl = {bg = error_bg(), fg = nightfox.bg_visual}
        }
    end,
    right_sep = {str = ' ', hl = {bg = nightfox.bg_visual}},
    hl = {bg = nightfox.bg_visual},
})
table.insert(components.active[2], {
    provider = 'git_diff_added',
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and gsd['added'] and gsd['added'] > 0
    end,
    left_sep = {str = 'left', hl = {bg = nightfox.bg_visual}},
    hl = {bg = nightfox.bg_visual},
})
table.insert(components.active[2], {
    provider = 'git_diff_changed',
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and gsd['changed'] and gsd['changed'] > 0
    end,
    left_sep = function()
        local gsd = vim.b.gitsigns_status_dict
        local str
        if gsd and gsd['added'] and gsd['added'] > 0 then
            str = ''
        else
            str = 'left'
        end
        return {str = str, hl = {bg = nightfox.bg_visual}}
    end,
    hl = {bg = nightfox.bg_visual},
})
table.insert(components.active[2], {
    provider = 'git_diff_removed',
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and gsd['removed'] and gsd['removed'] > 0
    end,
    left_sep = function()
        local gsd = vim.b.gitsigns_status_dict
        local str
        if gsd and
            (
                (gsd['added'] and gsd['added'] > 0) or
                (gsd['changed'] and gsd['changed'] > 0)
            )
        then
            str = ''
        else
            str = 'left'
        end
        return {str = str, hl = {bg = nightfox.bg_visual}}
    end,
    hl = {bg = nightfox.bg_visual},
})
table.insert(components.active[2], {
    provider = ' ',
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and (
            (gsd['added'] and gsd['added'] > 0) or
            (gsd['changed'] and gsd['changed'] > 0) or
            (gsd['removed'] and gsd['removed'] > 0)
        )
    end,
    hl = {bg = nightfox.bg_visual},
})

table.insert(components.active[2], {
    provider = ' ',
    hl = function()
        local hl = {}
        hl.fg = nightfox.black
        hl.bg = vi_mode_colors[vi_mode.get_vim_mode()]
        return hl
    end,
    left_sep = makesep(
        'left_filled',
        function()
            local gsd = vim.b.gitsigns_status_dict
            local git_active = gsd and gsd.head and #gsd.head > 0
            if git_active then
                return nightfox.bg_visual
            else
                return error_bg()
            end
        end,
        function() return vi_mode_colors[vi_mode.get_vim_mode()] end
    ),
})
table.insert(components.active[2], {
    provider = 'file_encoding',
    hl = function()
        local hl = {}
        hl.fg = nightfox.black
        hl.bg = vi_mode_colors[vi_mode.get_vim_mode()]
        return hl
    end,
    right_sep = makesep(
        ' ',
        function() return vi_mode_colors[vi_mode.get_vim_mode()] end,
        nightfox.bg_statusline
    ),
})
table.insert(components.active[2], {
    provider = file_osinfo,
    hl = function()
        local hl = {}
        hl.fg = nightfox.black
        hl.bg = vi_mode_colors[vi_mode.get_vim_mode()]
        return hl
    end,
    right_sep = makesep(
        ' ',
        function() return vi_mode_colors[vi_mode.get_vim_mode()] end,
        nightfox.bg_statusline
    ),
})
table.insert(components.active[2], {
    provider = ' ',
    hl = function()
        local hl = {}
        hl.fg = nightfox.black
        hl.bg = vi_mode_colors[vi_mode.get_vim_mode()]
        return hl
    end,
    left_sep = makesep(
        'left',
        function() return vi_mode_colors[vi_mode.get_vim_mode()] end,
        nightfox.black
    ),
})
table.insert(components.active[2], {
    provider = 'line_percentage',
    hl = function()
        local hl = {}
        hl.fg = nightfox.black
        hl.bg = vi_mode_colors[vi_mode.get_vim_mode()]
        return hl
    end,
    right_sep = makesep(
        ' ',
        function() return vi_mode_colors[vi_mode.get_vim_mode()] end,
        nightfox.black
    )
})

--- inactive left side

table.insert(components.inactive[1], {
    provider = '   ',
    hl = {
        bg = nightfox.bg_statusline,
    },
    right_sep = makesep(
        'right_filled',
        nightfox.bg_search,
        nightfox.bg_statusline
    )
})

table.insert(components.inactive[1], {
    provider = function()
        local filename = vim.fn.expand('%')
        local extension = vim.fn.expand('%:e')
        local fileicon = icons.get_icon(filename, extension, {default = true})
        local modifiedicon = vim.bo.modified and ' ' or ''
        local readonlyicon = (vim.bo.readonly or not vim.bo.modifiable) and ' ' or ''
        return fileicon .. ' ' .. filename .. modifiedicon .. readonlyicon .. ' '
    end,
    hl = function()
        return {
            fg = nightfox.bg_statusline,
            bg = nightfox.bg_search,
            style = vim.bo.modified and 'bold' or nil,
        }
    end,
    left_sep = {str = ' ', hl = {bg = nightfox.bg_search}},
    right_sep = 'right_filled',
})

--- inactive right

table.insert(components.inactive[2], {
    provider = function()
        local count, icon = lsp.diagnostic_errors()
        return icon .. count .. ' '
    end,
    enabled = function() return lsp.diagnostics_exist('ERROR') end,
    left_sep = {
        str = 'left_filled',
        hl = {fg = nightfox.bg_search},
    },
    hl = function() return {fg = nightfox.bg_statusline, bg = nightfox.bg_search} end,
})
table.insert(components.inactive[2], {
    provider = function()
        local count, icon = lsp.diagnostic_warnings()
        return icon .. count .. ' '
    end,
    enabled = function() return lsp.diagnostics_exist('WARN') end,
    left_sep = error_sep_curried('WARN', true),
    hl = function() return {fg = nightfox.bg_statusline, bg = nightfox.bg_search} end,
})
table.insert(components.inactive[2], {
    provider = function()
        local count, icon = lsp.diagnostic_hints()
        return icon .. count .. ' '
    end,
    enabled = function() return lsp.diagnostics_exist('HINT') end,
    left_sep = error_sep_curried('HINT', true),
    hl = function() return {fg = nightfox.bg_statusline, bg = nightfox.bg_search} end,
})
table.insert(components.inactive[2], {
    provider = function()
        local count, icon = lsp.diagnostic_info()
        return icon .. count .. ' '
    end,
    enabled = function() return lsp.diagnostics_exist('INFO') end,
    left_sep = error_sep_curried('INFO', true),
    hl = function() return {fg = nightfox.bg_statusline, bg = nightfox.bg_search} end,
})

table.insert(components.inactive[2], {
    provider = function()
        local branch, icon = git.git_branch({}, getwin())
        return ' ' .. icon .. branch
    end,
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and gsd.head and #gsd.head > 0
    end,
    left_sep = function()
        return {
            str = 'left_filled',
            hl = {bg = error_bg(true), fg = nightfox.black}
        }
    end,
    right_sep = {str = ' ', hl = {bg = nightfox.black}},
    hl = {bg = nightfox.black, fg=nightfox.white_dm},
})
table.insert(components.inactive[2], {
    provider = 'git_diff_added',
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and gsd['added'] and gsd['added'] > 0
    end,
    left_sep = {str = 'left', hl = {bg = nightfox.black, fg=nightfox.white_dm}},
    hl = {bg = nightfox.black, fg=nightfox.white_dm},
})
table.insert(components.inactive[2], {
    provider = 'git_diff_changed',
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and gsd['changed'] and gsd['changed'] > 0
    end,
    left_sep = function()
        local gsd = vim.b.gitsigns_status_dict
        local str
        if gsd and gsd['added'] and gsd['added'] > 0 then
            str = ''
        else
            str = 'left'
        end
        return {str = str, hl = {bg = nightfox.black, fg=nightfox.white_dm}}
    end,
    hl = {bg = nightfox.black, fg=nightfox.white_dm},
})
table.insert(components.inactive[2], {
    provider = 'git_diff_removed',
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and gsd['removed'] and gsd['removed'] > 0
    end,
    left_sep = function()
        local gsd = vim.b.gitsigns_status_dict
        local str
        if gsd and
            (
                (gsd['added'] and gsd['added'] > 0) or
                (gsd['changed'] and gsd['changed'] > 0)
            )
        then
            str = ''
        else
            str = 'left'
        end
        return {str = str, hl = {bg = nightfox.black, fg=nightfox.white_dm}}
    end,
    hl = {bg = nightfox.black, fg=nightfox.white_dm},
})
table.insert(components.inactive[2], {
    provider = ' ',
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and (
            (gsd['added'] and gsd['added'] > 0) or
            (gsd['changed'] and gsd['changed'] > 0) or
            (gsd['removed'] and gsd['removed'] > 0)
        )
    end,
    hl = {bg = nightfox.black},
})

table.insert(components.inactive[2], {
    provider = ' ',
    hl = {
        fg = nightfox.white_dm,
        bg = nightfox.black,
    },
    left_sep = makesep(
        'left_filled',
        function()
            local gsd = vim.b.gitsigns_status_dict
            local git_active = gsd and gsd.head and #gsd.head > 0
            if git_active then
                return nightfox.black
            else
                return error_bg(true)
            end
        end,
        nightfox.bg_statusline
    ),
})
table.insert(components.inactive[2], {
    provider = 'file_encoding',
    hl = {
        fg = colors.grey,
        bg = nightfox.bg_statusline,
    },
    right_sep = makesep(
        ' ',
        nightfox.bg_statusline,
        colors.bg2
    ),
})
table.insert(components.inactive[2], {
    provider = file_osinfo,
    hl = {
        fg = colors.grey,
        bg = nightfox.bg_statusline,
    },
    right_sep = makesep(
        ' ',
        nightfox.bg_statusline,
        nightfox.bg_statusline
    ),
})
table.insert(components.inactive[2], {
    provider = ' ',
    hl = {
        fg = colors.grey,
        bg = nightfox.bg_statusline,
    },
    left_sep = makesep(
        'left',
        nightfox.bg_statusline,
        colors.grey
    ),
})
table.insert(components.inactive[2], {
    provider = 'line_percentage',
    hl = {
        fg = colors.grey,
        bg = nightfox.bg_statusline,
    },
    right_sep = makesep(
        ' ',
        nightfox.bg_statusline,
        colors.grey
    )
})

--- install

feline.setup({
    theme = {
        bg = nightfox.bg_statusline,
        fg = nightfox.fg,
    },
    components = components,
})

return M
