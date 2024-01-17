local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
	{
		-- Git related plugins
		'tpope/vim-fugitive',
		'tpope/vim-rhubarb',

		-- Detect tabstop and shiftwidth automatically
		'tpope/vim-sleuth',

		-- NOTE: This is where your plugins related to LSP can be installed.
		--  The configuration is done below. Search for lspconfig to find it below.
		{
			-- LSP Configuration & Plugins
			'neovim/nvim-lspconfig',
			dependencies = {
				-- Automatically install LSPs to stdpath for neovim
				{ 'williamboman/mason.nvim', config = true },
				'williamboman/mason-lspconfig.nvim',

				-- Useful status updates for LSP
				-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
				{ 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

				-- Additional lua configuration, makes nvim stuff amazing!
				'folke/neodev.nvim',
			},
		},

		{
			-- Autocompletion
			'hrsh7th/nvim-cmp',
			dependencies = {
				-- Snippet Engine & its associated nvim-cmp source
				'L3MON4D3/LuaSnip',
				'saadparwaiz1/cmp_luasnip',

				-- Adds LSP completion capabilities
				'hrsh7th/cmp-nvim-lsp',

				-- Adds a number of user-friendly snippets
				'rafamadriz/friendly-snippets',
			},
		},

		-- Fuzzy Finder (files, lsp, etc)
		{ 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

		-- Fuzzy Finder Algorithm which requires local dependencies to be built.
		-- Only load if `make` is available. Make sure you have the system
		-- requirements installed.
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			-- NOTE: If you are having trouble with this installation,
			--       refer to the README for telescope-fzf-native for more instructions.
			build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
		},

		-- Useful plugin to show you pending keybinds.
		{ 'folke/which-key.nvim', opts = {} },

		{
			-- Adds git releated signs to the gutter, as well as utilities for managing changes
			'lewis6991/gitsigns.nvim',
			opts = {
				-- See `:help gitsigns.txt`
				signs = {
					add = { text = '+' },
					change = { text = '~' },
					delete = { text = '_' },
					topdelete = { text = '‾' },
				changedelete = { text = '~' },
				},
				on_attach = function(bufnr)
					vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
					vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
					vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
				end,
			},
		},

		{
			-- Theme inspired by Atom
			'navarasu/onedark.nvim',
			priority = 1000,
			config = function()
				vim.cmd.colorscheme 'onedark'
			end,
		},

		{
			-- Set lualine as statusline
			'nvim-lualine/lualine.nvim',
			-- See `:help luarine.txt`
			opts = {
				options = {
					icons_enabled = false,
					theme = 'onedark',
					component_separators = '|',
					section_separators = '',
				},
			},
		},

		-- "gc" to comment visual regions/lines
		{ 'numToStr/Comment.nvim', opts = {} },

		{
			-- Highlight, edit, and navigate code
			'nvim-treesitter/nvim-treesitter',
			dependencies = {
				'nvim-treesitter/nvim-treesitter-textobjects',
			},
			build = ':TSUpdate',
		},

	},{}
)

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

	-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
	auto_install = false,

	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = '<c-space>',
			node_incremental = '<c-space>',
			scope_incremental = '<c-s>',
			node_decremental = '<M-space>',
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['aa'] = '@parameter.outer',
				['ia'] = '@parameter.inner',
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']m'] = '@function.outer',
				[']]'] = '@class.outer',
			},
			goto_next_end = {
				[']M'] = '@function.outer',
				[']['] = '@class.outer',
			},
			goto_previous_start = {
				['[m'] = '@function.outer',
				['[['] = '@class.outer',
			},
			goto_previous_end = {
				['[M'] = '@function.outer',
				['[]'] = '@class.outer',
			},
		},
		swap = {
			enable = true,
			swap_next = {
				['<leader>a'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>A'] = '@parameter.inner',
			},
		},
	},
}
