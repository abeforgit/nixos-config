return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#101410',
				base01 = '#101410',
				base02 = '#80897f',
				base03 = '#80897f',
				base04 = '#d2ded1',
				base05 = '#f9fff8',
				base06 = '#f9fff8',
				base07 = '#f9fff8',
				base08 = '#ffb59f',
				base09 = '#ffb59f',
				base0A = '#b7e9b4',
				base0B = '#a7fea5',
				base0C = '#e2ffe0',
				base0D = '#b7e9b4',
				base0E = '#d2ffcf',
				base0F = '#d2ffcf',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#80897f',
				fg = '#f9fff8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#b7e9b4',
				fg = '#101410',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#80897f' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e2ffe0', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#d2ffcf',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#b7e9b4',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#b7e9b4',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#e2ffe0',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a7fea5',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#d2ded1' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#d2ded1' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#80897f',
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
