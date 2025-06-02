-- Add LuaRocks paths so Neovim can find lyaml
package.path = package.path .. ";/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua"
package.cpath = package.cpath .. ";/usr/local/lib/lua/5.1/?.so"

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
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-telescope/telescope-file-browser.nvim", dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" } },
  { "navarasu/onedark.nvim", priority = 1000, lazy = false },
  { "scottmckendry/cyberdream.nvim", lazy = false, priority = 1000, },
  { "olimorris/codecompanion.nvim", opts = {}, dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" } },
})

require('nvim-web-devicons').setup()

-- basic settings
vim.o.number = true
vim.o.relativenumber = true
vim.opt.termguicolors = true

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

-- Telescope keybindings
-- require("telescope").setup({})
-- vim.keymap.set("n", "<leader>ff", ":Telescope file_browser hidden=true<CR>")
-- vim.keymap.set("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>")

require("telescope").setup({
  extensions = {
    file_browser = {
      hijack_netrw = true,
    },
  },
})

vim.keymap.set("n", "<leader>ff", ":Telescope file_browser hidden=true<CR>")

-- Enhanced version: opens in current file's directory and adds 't' keybinding
vim.keymap.set("n", "<leader>fb", function()
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

vim.cmd.colorscheme("cyberdream")

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
