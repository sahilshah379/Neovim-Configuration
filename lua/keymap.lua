-- [[ keymap.lua ]]

-- [[ Local Variables ]]
local telescope_require = require('telescope.builtin')
local tree_require = require('nvim-tree.api')
local leap_require = require('leap')

-- [[ Clipboard ]]
vim.keymap.set('n', '<leader>y', '"+y', {})
vim.keymap.set('v', '<leader>y', '"+y', {})
vim.keymap.set('n', '<leader>p', '"+p', {})
vim.keymap.set('n', '<leader>P', '"+P', {})

-- [[ VS Code Keybindings ]]
vim.keymap.set('n', '<M-k>', ':m .-2<CR>==', {})
vim.keymap.set('n', '<M-j>', ':m .+1<CR>==', {})
vim.keymap.set('v', '<M-k>', ':m \'<-2<CR>gv=gv', {})
vim.keymap.set('v', '<M-j>', ':m \'>+1<CR>gv=gv', {})

-- [[ Window Commands ]]
vim.keymap.set('n', '<leader>w', ':wa<CR>', {})
vim.keymap.set('n', '<leader>q', ':qa<CR>', {})
vim.keymap.set('n', '<leader>e', ':e!<CR>', {})

-- [[ Tree ]]
vim.keymap.set('n', '<leader>t', tree_require.tree.toggle, {})

-- [[ Telescope ]]
vim.keymap.set('n', '<leader>f', telescope_require.find_files, {})
vim.keymap.set('n', '<leader>g', telescope_require.live_grep, {})
vim.keymap.set('n', '<leader>b', telescope_require.buffers, {})
vim.keymap.set('n', '<leader>h', telescope_require.help_tags, {})

-- [[ Coc ]]
vim.opt.updatetime = 300
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
vim.keymap.set('i', '<TAB>', 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
vim.keymap.set('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
vim.keymap.set('i', '<cr>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
vim.keymap.set('n', 'K', '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- [[ Leap ]]
vim.keymap.set('n', 's', function ()
  local focusable_windows = vim.tbl_filter(
    function (win) return vim.api.nvim_win_get_config(win).focusable end,
    vim.api.nvim_tabpage_list_wins(0)
  )
  leap_require.leap { target_windows = focusable_windows }
end)
