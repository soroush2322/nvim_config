-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- What should you know before start customizing nvim??
--   The customization language for nvim is Lua, Lua is a fast and interesting scripting language
--   You should have a basic familiarity with Lua, Read this short guide to gain some basic knowledge:
--     - https://learnxinyminutes.com/docs/lua
--   After learning some Lua, you should read the nvim documentation to start using Lua in nvim:
--     - https://neovim.io/doc/user/lua-guide
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- What does customizing nvim include??
--   I divide the entire process of customizing nvim into four sections:
--     - Choosing the right options
--     - Configure and install plugins
--     - Setting up autocommands
--     - Other cases
--   I will write the details of each section in their respective parts
--   Remember that i will only write about the ones i use myself here
--   There are many customizable options that I will learn and add over time
--   Also, read the content from start to finish, as i aimed to avoid repetition
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- vim.opt is a Lua table that serves as an API for managing over 300 default options in nvim
-- vim.opt allowing you to easily customize the editor's settings in whatever way you prefer
-- You can view the list of these options with brief descriptions in nvim using this command:
--   - :help option-list

vim.opt.number = true -- print the line number in front of each line
vim.opt.relativenumber = true -- show relative line number in front of each line
-- Using both together shows the current line number and relative distances to other lines

vim.opt.scrolloff = 10 -- minimum nr. of lines above and below cursor
-- Using this option keeps your cursor reasonably centered on the screen while coding

vim.opt.tabstop = 2 -- number of spaces that <Tab> in file uses
vim.opt.shiftwidth = 2 -- number of spaces to use for (auto)indent step
-- These options should be the same value so that >> or << moves lines by same tab width

vim.opt.expandtab = true -- use spaces when <Tab> is inserted
-- It might not be your preference, but I prefer using spaces instead of the tab character

vim.opt.history = 1000 -- number of command-lines that are remembered
-- This option is set to 100 by default, which might be too low

vim.opt.cursorline = true -- highlight the screen line of the cursor
-- This option might not look good with the default nvim theme on your system

vim.opt.ignorecase = true -- use IM when starting to edit a command line
vim.opt.smartcase = false -- no ignore case when pattern has uppercase
-- Enabling both makes case sensitivity apply only when the search starts with an uppercase letter

vim.opt.wrap = false -- long lines wrap and continue on the next line
-- This option is enabled by default and personally bothers me, but your preference might differ

vim.opt.signcolumn = "yes" -- when and how to display the sign column
-- Without this option, your code will shift left and right after activating plugins

vim.opt.clipboard = "unnamedplus" -- use the clipboard as the unnamed register
-- This setting allows nvim to use the system clipboard for copy and paste operations by default

vim.opt.list = true -- show <Tab> and <EOL>
vim.opt.listchars = { trail = "·", tab = "  " } -- characters for displaying in list mode
-- These two options, with this setting, show unnecessary trailing spaces

vim.opt.autoindent = true -- take indent for new line from previous line

vim.opt.timeout = false -- time out on mappings and key codes

-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- We use plugin managers to handle plugins and their dependencies
-- Each plugin has unique customization options, detailed in its ocumentation
-- lazy.nvim is a popular nvim plugin manager, Other options include packer and vundle and etc...
-- To install lazy.nvim and ensure you're always using the latest version, use the following code:

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
    "clone",
    "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- You can find this code and other information about lazy.nvim from its developer:
--   - https://github.com/folke/lazy.nvim
-- Use this command in nvim to access and verify lazy.nvim installation:
--   - :Lazy

-- After installing lazy.nvim, find your preferred packages at this address:
--   - https://dotfyle.com/neovim/plugins/trending
-- Each plugin is installed using a table, with first argument in this format:
--   - "github_owner/github_repo"
-- The other arguments have specific uses, that we use some of them later
-- You can also use this command to view the lazy.nvim interface in nvim:
--    - :Lazy

require("lazy").setup({


	-- This plugin is the most popular themes used for nvim
	{
		"folke/tokyonight.nvim",

		-- The config argument takes a function that runs after the plugin loads
		config = function()
			-- vim.cmd is used to execute vim commands in the configuration
			-- We want the colorscheme of this theme to be set after it loads
			vim.cmd("colorscheme tokyonight-night")
		end,
	},


	-- This plugin is the most installed plugin for nvim
	-- It is used for better syntax highlighting
  -- Treesitter needs a parser of any language to apply its syntax highlighting
  -- You can install the parser for each language with this command:
  --   - :TSInstall <name>
	{
		"nvim-treesitter/nvim-treesitter",

		config = function()
			-- Some plugins have a standard setup() function that must be used for activation
			-- This function applies plugin configurations, detailed in the plugin's documentation
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
		    })
    end
	},


	-- This plugin is a file explorer that i prefer over the default nvim file explorer
	-- Other popular options to try include mini.file and nvim-tree.lua
	{
		"stevearc/oil.nvim",

		-- Sometimes a plugin requires another as a prerequisite
		-- Of course nvim-web-devicons requires several plugins, but one writing is enough
		dependencies = { "nvim-tree/nvim-web-devicons" },

		config = function()
			require("oil").setup({
				view_options = { show_hidden = true },
			})
		end,
	},


	-- This plugin highlights hex color codes and names, Useful for front-end developers
	{
		"brenoprata10/nvim-highlight-colors",

		config = function()
			require("nvim-highlight-colors").setup({
				-- I recommend checking other options in the plugin's GitHub repository
				render = "forground",
			})
		end,
	},


  -- This plugin auto-completes pairs like () or [] for faster coding
  {
    "windwp/nvim-autopairs",

    config = function()
      require('nvim-autopairs').setup({})
    end
  },


  -- This plugin manages Git repos and highlights file changes
  -- This plugin also provides useful functions with keymaps to be defined later
  {
		"lewis6991/gitsigns.nvim",

		config = function()
			require("gitsigns").setup({})
		end,
	},


  -- This plugin simplifies LSP integration in nvim for error-detection and auto-completion
  -- If you don't know what LSP is and what it does, Please read this page first:
  --   - https://microsoft.github.io/language-server-protocol
  {
    "neovim/nvim-lspconfig",

    -- These dependencies aren't essential, but you'll manage LSP manually without them
    dependencies = {
      -- Using Mason to manage LSPs is very simple, Refer to its documentation here:
      --   - https://github.com/williamboman/mason.nvim
      -- Mason is a LSP manager that simplifies managing LSPs, Just use this command:
      --   - :Mason
      "williamboman/mason.nvim",
      -- We use mason-lspconfig to bridge Mason and lspconfig
      "williamboman/mason-lspconfig.nvim",
    },

    -- You would need to load each LSP installed by Mason into lspconfig
    -- Using setup_handlers function, you can automatically identify mason downloaded LSPs
    -- Here we load the default settings, Each LSP offers many customization options
    -- If the LSP for a language is loaded, pressing Shift+K anywhere will show its documentation
    config = function()
      local lspconfig = require('lspconfig')
      require("mason").setup({})
      require('mason-lspconfig').setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({})
        end
      })
    end
  },


  -- nvim-cmp is an autocompletion tool with multiple suggestion sources
  {
    "hrsh7th/nvim-cmp",

    -- Each of these provides different sources to help nvim-cmp offer varied suggestions
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Suggestions from the LSP of the current file
      "hrsh7th/cmp-buffer", -- Suggestions from the current file's buffer
      "hrsh7th/cmp-path", -- Suggestions from system paths
    },

    config = function()

      -- The setup function for nvim-cmp takes several key inputs, two of which are crucial
      local cmp = require("cmp")
      cmp.setup({

        -- Here, we provide nvim-cmp with the resources specified by the plugin
        sources = cmp.config.sources(
          {{ name = "nvim_lsp" }},
          {{ name = "buffer" }},
          {{ name = "path" }}
        ),

        -- Here, we set the key mappings for suggestions, which you can customize
        -- You can change this section according to your taste and nvim-cmp documentation
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm(),
          ["<C-Space>"] = function() if cmp.visible() then cmp.close() else cmp.complete() end end
        }),

      })

    end
  }


})


-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- In nvim, a keymap is a configuration that maps specific commands to particular keybindings
-- Certainly, you can customize each keymap for nvim as you prefer
-- We set keymaps with this structure, note that the last argument is optional:
--   - vim.keymap.set(<mode>, <lhs>, <rhs>, <opts>)


vim.keymap.set("n", "<Space>q", ":q<CR>")
-- Quickly executes the q command

vim.keymap.set("n", "<Space>w", ":w<CR>")
-- Quickly executes the w command

vim.keymap.set('n', '<Esc>', ":nohlsearch<CR>")
-- Quickly executes the nohlsearch command

vim.keymap.set("n", "<Space>a", "gg0vG$")
-- Equivalent to Ctrl+A in other text editors

vim.keymap.set("n", "<Space>t", ":b#<CR>")
-- Go to the last closed buffer if it exists
-- We usually work with two files simultaneously, this helps switch between them

vim.keymap.set("n", "<Space>e", ":w<CR><CMD>Oil<CR>")
-- Shortcut to open the Oil file explorer and navigate between files
-- Also, save the current file's changes each time you switch to Oil

-- vim.keymap.set("n", "<C-z>", "u")
-- vim.keymap.set("n", "<S-C-z>", "<C-r>")
-- If you're new to nvim and used to Ctrl+Z and Shift+Ctrl+Z, uncomment these

-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- I don’t have a specific category for these settings yet, they will be expanded later


-- I haven’t decided on the status line yet, but I know I don't want it cluttered
-- You can install the lualine plugin to customize it, for now, this is easier for me
vim.o.statusline = "%t %= %{mode()}"
vim.o.cmdheight = 0


-- Automods are functions defined to respond to specific events
-- There are many predefined events in nvim, you can find them in the documentation
-- Defining a new automod is easy, For example, this automod highlights text when it is yanked
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
