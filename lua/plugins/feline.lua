local feline = require('feline')
local lsp = require('feline.providers.lsp')
local git = require('feline.providers.git')
local icons = require('nvim-web-devicons')
--local nonicons = require('nvim-nonicons')
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

local vi_mode_colors = {
    NORMAL = colors.bg_blue,
    OP = colors.bg_blue,
    INSERT = colors.bg_green,
    VISUAL = colors.purple,
    LINES = colors.purple,
    BLOCK = colors.purple,
    REPLACE = colors.yellow,
    ['V-REPLACE'] = colors.yellow,
    ENTER = colors.bg_blue,
    MORE = colors.bg_blue,
    SELECT = colors.yellow,
    COMMAND = colors.orange,
    SHELL = colors.bg_blue,
    TERM = colors.bg_blue,
    NONE = colors.orange,
}

M.vi_mode_colors = vi_mode_colors

-- local vi_mode_icon = {
--     NORMAL = nonicons.get("vim-normal-mode"),
--     OP = nonicons.get("vim-normal-mode"),
--     INSERT = nonicons.get("vim-insert-mode"),
--     VISUAL = nonicons.get("vim-visual-mode"),
--     BLOCK = nonicons.get("vim-visual-mode"),
--     REPLACE = nonicons.get("vim-replace-mode"),
--     ['V-REPLACE'] = nonicons.get("vim-replace-mode"),
--     ENTER = nonicons.get("vim-normal-mode"),
--     MORE = nonicons.get("vim-normal-mode"),
--     SELECT = nonicons.get("vim-select-mode"),
--     COMMAND = nonicons.get("vim-command-mode"),
--     SHELL = nonicons.get("vim-terminal-mode"),
--     TERM = nonicons.get("vim-terminal-mode"),
--     NONE = " ",
-- }

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
    local levels = {'Error', 'Warning', 'Hint', 'Information',}
    for _, level in ipairs(levels) do
        if lsp.diagnostics_exist(level) then return level end
    end
    return nil
end

local function error_bg(greyscale)
    local color_map = {
        Error = colors.bg_red,
        Warning = colors.yellow,
        Hint = colors.bg_green,
        Information = colors.bg_blue,
    }
    if greyscale and error_level() then
        return colors.grey
    elseif error_level() then
        return color_map[error_level()]
    else
        return colors.bg1
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
                hl = {fg = colors.bg0, bg = error_bg(greyscale)},
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
        hl.fg = colors.bg0
        hl.bg = vi_mode_colors[vi_mode.get_vim_mode()]
        hl.style = 'bold'
        return hl
    end,
    left_sep = function()
        return {str = ' ', hl = {bg = vi_mode_colors[vi_mode.get_vim_mode()]}}
    end,
    right_sep = makesep(
        'right_filled',
        colors.bg4,
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
            fg = vim.bo.modified and colors.yellow or colors.fg,
            bg = colors.bg4,
            style = vim.bo.modified and 'bold' or nil,
        }
    end,
    left_sep = {str = ' ', hl = {bg = colors.bg4}},
    right_sep = 'right_filled',
})

table.insert(components.active[1], {
    provider = function()
        return vim.b.lsp_current_function or ''
    end,
    left_sep = ' ',
    right_sep = {' ', {str = 'right', hl = {fg = colors.grey}},},
    enabled = function()
        return (
            (#vim.lsp.buf_get_clients() > 0)
            and vim.b.lsp_current_function
            and vim.b.lsp_current_function ~= ''
        )
    end,
    hl = {fg = colors.grey},
})

--- right side

table.insert(components.active[2], {
    provider = function()
        local count, icon = lsp.diagnostic_errors({icon = '  '})
        return icon .. count .. ' '
    end,
    enabled = function() return lsp.diagnostics_exist('Error') end,
    left_sep = {
        str = 'left_filled',
        hl = {fg = colors.bg_red},
    },
    hl = function() return {fg = colors.bg0, bg = error_bg()} end,
})

table.insert(components.active[2], {
    provider = function()
        local count, icon = lsp.diagnostic_warnings({icon = '  '})
        return icon .. count .. ' '
    end,
    enabled = function() return lsp.diagnostics_exist('Warning') end,
    left_sep = error_sep_curried('Warning'),
    hl = function() return {fg = colors.bg0, bg = error_bg()} end,
})

table.insert(components.active[2], {
    provider = function()
        local count, icon = lsp.diagnostic_hints({icon = ' ﯟ '})
        return icon .. count .. ' '
    end,
    enabled = function() return lsp.diagnostics_exist('Hint') end,
    left_sep = error_sep_curried('Hint'),
    hl = function() return {fg = colors.bg0, bg = error_bg()} end,
})

table.insert(components.active[2], {
    provider = function()
        local count, icon = lsp.diagnostic_info({icon = '  '})
        return icon .. count .. ' '
    end,
    enabled = function() return lsp.diagnostics_exist('Information') end,
    left_sep = error_sep_curried('Information'),
    hl = function() return {fg = colors.bg0, bg = error_bg()} end,
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
            hl = {bg = error_bg(), fg = colors.bg4}
        }
    end,
    right_sep = {str = ' ', hl = {bg = colors.bg4}},
    hl = {bg = colors.bg4},
})
table.insert(components.active[2], {
    provider = 'git_diff_added',
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and gsd['added'] and gsd['added'] > 0
    end,
    left_sep = {str = 'left', hl = {bg = colors.bg4}},
    hl = {bg = colors.bg4},
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
        return {str = str, hl = {bg = colors.bg4}}
    end,
    hl = {bg = colors.bg4},
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
        return {str = str, hl = {bg = colors.bg4}}
    end,
    hl = {bg = colors.bg4},
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
    hl = {bg = colors.bg4},
})

table.insert(components.active[2], {
    provider = ' ',
    hl = function()
        local hl = {}
        hl.fg = colors.bg0
        hl.bg = vi_mode_colors[vi_mode.get_vim_mode()]
        return hl
    end,
    left_sep = makesep(
        'left_filled',
        function()
            local gsd = vim.b.gitsigns_status_dict
            local git_active = gsd and gsd.head and #gsd.head > 0
            if git_active then
                return colors.bg4
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
        hl.fg = colors.bg0
        hl.bg = vi_mode_colors[vi_mode.get_vim_mode()]
        return hl
    end,
    right_sep = makesep(
        ' ',
        function() return vi_mode_colors[vi_mode.get_vim_mode()] end,
        colors.bg4
    ),
})
table.insert(components.active[2], {
    provider = file_osinfo,
    hl = function()
        local hl = {}
        hl.fg = colors.bg0
        hl.bg = vi_mode_colors[vi_mode.get_vim_mode()]
        return hl
    end,
    right_sep = makesep(
        ' ',
        function() return vi_mode_colors[vi_mode.get_vim_mode()] end,
        colors.bg4
    ),
})
table.insert(components.active[2], {
    provider = ' ',
    hl = function()
        local hl = {}
        hl.fg = colors.bg0
        hl.bg = vi_mode_colors[vi_mode.get_vim_mode()]
        return hl
    end,
    left_sep = makesep(
        'left',
        function() return vi_mode_colors[vi_mode.get_vim_mode()] end,
        colors.bg0
    ),
})
table.insert(components.active[2], {
    provider = 'line_percentage',
    hl = function()
        local hl = {}
        hl.fg = colors.bg0
        hl.bg = vi_mode_colors[vi_mode.get_vim_mode()]
        return hl
    end,
    right_sep = makesep(
        ' ',
        function() return vi_mode_colors[vi_mode.get_vim_mode()] end,
        colors.bg0
    )
})

--- inactive left side

table.insert(components.inactive[1], {
    provider = '   ',
    hl = {
        bg = colors.grey,
    },
    right_sep = makesep(
        'right_filled',
        colors.bg2,
        colors.grey
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
            fg = colors.grey,
            bg = colors.bg2,
            style = vim.bo.modified and 'bold' or nil,
        }
    end,
    left_sep = {str = ' ', hl = {bg = colors.bg2}},
    right_sep = 'right_filled',
})

--- inactive right

table.insert(components.inactive[2], {
    provider = function() return lsp.diagnostic_errors({icon = '  '}) .. ' ' end,
    enabled = function() return lsp.diagnostics_exist('Error') end,
    left_sep = {
        str = 'left_filled',
        hl = {fg = colors.grey},
    },
    hl = function() return {fg = colors.bg0, bg = colors.grey} end,
})
table.insert(components.inactive[2], {
    provider = function() return lsp.diagnostic_warnings({icon = '  '}) .. ' ' end,
    enabled = function() return lsp.diagnostics_exist('Warning') end,
    left_sep = error_sep_curried('Warning', true),
    hl = function() return {fg = colors.bg0, bg = colors.grey} end,
})
table.insert(components.inactive[2], {
    provider = function() return lsp.diagnostic_hints({icon = ' ﯟ '}) .. ' ' end,
    enabled = function() return lsp.diagnostics_exist('Hint') end,
    left_sep = error_sep_curried('Hint', true),
    hl = function() return {fg = colors.bg0, bg = colors.grey} end,
})
table.insert(components.inactive[2], {
    provider = function() return lsp.diagnostic_info({icon = '  '}) .. ' ' end,
    enabled = function() return lsp.diagnostics_exist('Information') end,
    left_sep = error_sep_curried('Information', true),
    hl = function() return {fg = colors.bg0, bg = colors.grey} end,
})

table.insert(components.inactive[2], {
    provider = 'git_branch',
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and gsd.head and #gsd.head > 0
    end,
    left_sep = function()
        return {
            str = 'left_filled',
            hl = {bg = error_bg(true), fg = colors.bg2}
        }
    end,
    right_sep = {str = ' ', hl = {bg = colors.bg2}},
    hl = {bg = colors.bg2, fg=colors.grey},
})
table.insert(components.inactive[2], {
    provider = 'git_diff_added',
    enabled = function()
        local gsd = vim.b.gitsigns_status_dict
        return gsd and gsd['added'] and gsd['added'] > 0
    end,
    left_sep = {str = 'left', hl = {bg = colors.bg2, fg=colors.grey}},
    hl = {bg = colors.bg2, fg=colors.grey},
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
        return {str = str, hl = {bg = colors.bg2, fg=colors.grey}}
    end,
    hl = {bg = colors.bg2, fg=colors.grey},
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
        return {str = str, hl = {bg = colors.bg2, fg=colors.grey}}
    end,
    hl = {bg = colors.bg2, fg=colors.grey},
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
    hl = {bg = colors.bg2},
})

table.insert(components.inactive[2], {
    provider = ' ',
    hl = {
        fg = colors.bg0,
        bg = colors.bg4,
    },
    left_sep = makesep(
        'left_filled',
        function()
            local gsd = vim.b.gitsigns_status_dict
            local git_active = gsd and gsd.head and #gsd.head > 0
            if git_active then
                return colors.bg2
            else
                return error_bg(true)
            end
        end,
        colors.bg4
    ),
})
table.insert(components.inactive[2], {
    provider = 'file_encoding',
    hl = {
        fg = colors.grey,
        bg = colors.bg4,
    },
    right_sep = makesep(
        ' ',
        colors.bg4,
        colors.bg2
    ),
})
table.insert(components.inactive[2], {
    provider = file_osinfo,
    hl = {
        fg = colors.grey,
        bg = colors.bg4,
    },
    right_sep = makesep(
        ' ',
        colors.bg4,
        colors.bg4
    ),
})
table.insert(components.inactive[2], {
    provider = ' ',
    hl = {
        fg = colors.grey,
        bg = colors.bg4,
    },
    left_sep = makesep(
        'left',
        colors.bg4,
        colors.grey
    ),
})
table.insert(components.inactive[2], {
    provider = 'line_percentage',
    hl = {
        fg = colors.grey,
        bg = colors.bg4,
    },
    right_sep = makesep(
        ' ',
        colors.bg4,
        colors.grey
    )
})

--- install

feline.setup({
    colors = {
        bg = colors.bg1,
        fg = colors.fg,
    },
    components = components,
})

return M
