return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#131313',
				base01 = '#131313',
				base02 = '#a59e97',
				base03 = '#a59e97',
				base04 = '#fff6ed',
				base05 = '#fffbf7',
				base06 = '#fffbf7',
				base07 = '#fffbf7',
				base08 = '#ff958e',
				base09 = '#ff958e',
				base0A = '#ffc27f',
				base0B = '#a7ff96',
				base0C = '#ffdfbb',
				base0D = '#ffc27f',
				base0E = '#ffcd96',
				base0F = '#ffcd96',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#a59e97',
				fg = '#fffbf7',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#ffc27f',
				fg = '#131313',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#a59e97' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffdfbb', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#ffcd96',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#ffc27f',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#ffc27f',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#ffdfbb',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a7ff96',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#fff6ed' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#fff6ed' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#a59e97',
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
