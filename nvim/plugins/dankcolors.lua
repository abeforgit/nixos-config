return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#181825',
				base01 = '#181825',
				base02 = '#899388',
				base03 = '#899388',
				base04 = '#e1eee0',
				base05 = '#f9fff8',
				base06 = '#f9fff8',
				base07 = '#f9fff8',
				base08 = '#ffb59f',
				base09 = '#ffb59f',
				base0A = '#c0f9bb',
				base0B = '#a8ffa5',
				base0C = '#e0ffdd',
				base0D = '#c0f9bb',
				base0E = '#cfffcb',
				base0F = '#cfffcb',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#899388',
				fg = '#f9fff8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#c0f9bb',
				fg = '#181825',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#899388' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e0ffdd', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#cfffcb',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#c0f9bb',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#c0f9bb',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#e0ffdd',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a8ffa5',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#e1eee0' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#e1eee0' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#899388',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
