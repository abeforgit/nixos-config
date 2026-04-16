return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#0d1518',
				base01 = '#0d1518',
				base02 = '#97938a',
				base03 = '#97938a',
				base04 = '#f4efe3',
				base05 = '#fffcf7',
				base06 = '#fffcf7',
				base07 = '#fffcf7',
				base08 = '#ff988f',
				base09 = '#ff988f',
				base0A = '#ffda80',
				base0B = '#a6ff96',
				base0C = '#ffebbc',
				base0D = '#ffda80',
				base0E = '#ffe196',
				base0F = '#ffe196',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#97938a',
				fg = '#fffcf7',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#ffda80',
				fg = '#0d1518',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#97938a' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffebbc', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#ffe196',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#ffda80',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#ffda80',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#ffebbc',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a6ff96',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#f4efe3' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#f4efe3' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#97938a',
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
