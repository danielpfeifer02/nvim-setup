-- Add LuaRocks paths so Neovim can find lyaml
package.path = package.path .. ";/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua"
package.cpath = package.cpath .. ";/usr/local/lib/lua/5.1/?.so"

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    command = "silent! lcd %:p:h",
})

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- setup plugins
require("lazy").setup({
  -- plugin list
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  -- { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-telescope/telescope-file-browser.nvim", dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" } },
  { "navarasu/onedark.nvim", priority = 1000, lazy = false },
  { "scottmckendry/cyberdream.nvim", lazy = false, priority = 1000, },
  { "olimorris/codecompanion.nvim", opts = {}, dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" } },
  { "folke/noice.nvim", event = "VeryLazy", opts = {}, dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    -- `nvim-notify` is only needed, if you want to use the notification view.
    -- If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify" } },  
  { "hrsh7th/cmp-cmdline" },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true
  },

  {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      }
    }
  },

  -- TODO: https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md

  keys = {
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
  -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- Other
    -- { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
  
  }
})

require('nvim-web-devicons').setup()

-- basic settings
vim.o.number = true
vim.o.relativenumber = true
vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- LSP setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd" }
})
require("lspconfig").clangd.setup({})

-- Autocomplete setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args) require("luasnip").lsp_expand(args.body) end
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }
})

-- vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", {desc = "Dismiss Noice Message"})

-- Telescope keybindings
require("telescope").setup({})
-- vim.keymap.set("n", "<leader>ff", ":Telescope file_browser hidden=true<CR>")
-- vim.keymap.set("n", "<leader>tfb", ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>")


require("telescope").setup({
  extensions = {
    file_browser = {
      hijack_netrw = true,
    },
  },
})

require("telescope").load_extension("noice")

-- vim.keymap.set("n", "<leader>ff", ":Telescope file_browser hidden=true<CR>")

-- Enhanced version: opens in current file's directory and adds 't' keybinding
vim.keymap.set("n", "<leader>fe", function()
  require("telescope").extensions.file_browser.file_browser({
    path = "%:p:h",
    select_buffer = true,
    hidden = true,
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local function open_terminal_in_selection()
	local entry = action_state.get_selected_entry()
	local path = entry and entry.path or vim.fn.getcwd()

	local stat = vim.loop.fs_stat(path)
	if stat and stat.type == "file" then
    	  path = vim.fn.fnamemodify(path, ":h")
  	end

  	actions.close(prompt_bufnr)

  	-- Open a terminal in a new horizontal split
  	vim.cmd("split")
  	vim.cmd("enew")  -- create a new empty buffer
  	vim.bo.buflisted = false
  	vim.bo.buftype = "terminal"

  	-- Open shell in correct directory
  	local shell = os.getenv("SHELL") or "bash"
  	vim.fn.termopen(shell, { cwd = path })

  	-- Optional: go into insert mode so the terminal is ready
  	vim.cmd("startinsert")
	end


      map("n", "t", open_terminal_in_selection)

      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      -- Custom <CR> behavior
      map("i", "<CR>", function()
        local entry = action_state.get_selected_entry()
        local path = entry and (entry.path or entry.value)
        if path and path:match("%.pdf$") then
          vim.fn.jobstart({ "zathura", path }, { detach = true })
          actions.close(prompt_bufnr)
        else
          actions.select_default(prompt_bufnr)
        end
      end)

      map("n", "<CR>", function()
        local entry = action_state.get_selected_entry()
        local path = entry and (entry.path or entry.value)
        if path and path:match("%.pdf$") then
          vim.fn.jobstart({ "zathura", path }, { detach = true })
          actions.close(prompt_bufnr)
        else
          actions.select_default(prompt_bufnr)
        end
      end)

      return true
    end,
  })
end, { desc = "File browser with terminal on 't'" })
--]]


-- NvimTree
require("nvim-tree").setup({
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    local function custom_open()
      local node = api.tree.get_node_under_cursor()
      if node and node.name:match("%.pdf$") then
        vim.fn.jobstart({ "zathura", node.absolute_path }, { detach = true })
      else
        api.node.open.edit()
      end
    end

    -- Override the default `<CR>` behavior
    vim.keymap.set("n", "<CR>", custom_open, { buffer = bufnr, noremap = true, silent = true })
  end
})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")

-- Onedark Color Scheme
--[[
require("onedark").setup({
  style = "warmer", -- "dark", "darker", "cool", "deep", "warm", "warmer", "light"
})
require("onedark").load()
]]

vim.cmd.colorscheme("wildcharm")

-- Syncing
vim.keymap.set("n", "<leader>sync", ":Lazy sync<CR>", { desc = "Run Lazy sync" })

-- Code companion 
vim.api.nvim_set_keymap('n', '<leader>cca', ':CodeCompanionAction<CR>', { noremap = true, silent = true })

require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "openai",
    },
    inline = {
      adapter = "openai",
    },
  },
  adapters = {
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
        env = {
          api_key = "cmd:cat ~/.config/nvim/tokens/openai.token",
        },
      })
    end,
    copilot = nil,
  },
})

-- Terminal

-- Autocomplete



-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})

-- Zeal
vim.api.nvim_create_user_command("Zeal", function(opts)
  local query = opts.args ~= "" and opts.args or vim.fn.expand("<cword>")
  vim.fn.jobstart({ "zeal", query }, { detach = true })
end, {
  nargs = "*",
  desc = "Open Zeal with the given query (or word under cursor)",
})

vim.keymap.set("n", "<leader>z", "<cmd>Zeal<cr>", { desc = "Search word in Zeal" })

