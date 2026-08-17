return { -- Autocompletion
	"saghen/blink.cmp",
	event = "InsertEnter",
	version = "1.*",
	dependencies = {
		-- `friendly-snippets` contains a variety of premade snippets.
		--    See the README about individual language/framework/plugin snippets:
		--    https://github.com/rafamadriz/friendly-snippets
		"rafamadriz/friendly-snippets",
		-- Surface lazydev's Neovim API completions through blink.cmp
		"folke/lazydev.nvim",
	},
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		keymap = {
			-- 'default' keeps the familiar <C-y> to accept, <C-n>/<C-p> to
			-- select, <C-space> to trigger and <C-e> to cancel, matching the
			-- previous nvim-cmp keymap set as closely as blink.cmp allows.
			preset = "default",
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			-- Auto-insert `()` after accepting a function/method completion,
			-- so accepted function and method completions are ready to call.
			accept = { auto_brackets = { enabled = true } },
			documentation = { auto_show = true },
			menu = {},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer", "lazydev" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- Give lazydev completions a higher score so they show up first
					score_offset = 100,
				},
			},
		},

		snippets = { preset = "default" },

		-- Use the Rust fuzzy matcher for better performance, falling back to the
		-- Lua implementation if the prebuilt binary isn't available for this platform.
		fuzzy = { implementation = "prefer_rust_with_warning" },

		-- Show a signature help window while typing arguments
		signature = { enabled = true },
	},
	opts_extend = { "sources.default" },
}
