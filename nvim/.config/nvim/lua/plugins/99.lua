return {
	{
		"folke/which-key.nvim",
		optional = true,
		opts = {
			spec = {
				{ "<leader>9", group = "99 Agent", icon = "🤖" },
			},
		},
	},
	{
		"ThePrimeagen/99",
		event = "VeryLazy",
		config = function()
			local _99 = require("99")

			local models = {
				"github-copilot/gpt-5-mini",
				"github-copilot/claude-opus-4.5",
				"github-copilot/claude-sonnet-4.5",
				"synthetic/hf:MiniMaxAI/MiniMax-M2.1",
			}
			local current_model_idx = 4

			local cwd = vim.uv.cwd()
			local basename = vim.fs.basename(cwd)

			_99.setup({
				-- Use the list so setup is always in sync with the cycler
				model = models[current_model_idx],

				-- logger = {
				-- 	level = _99.DEBUG,
				-- 	path = "/tmp/" .. basename .. ".99.debug",
				-- 	print_on_error = true,
				-- },

				completion = {
					source = "cmp",
					cursor_rules = ".cursor/rules",
					custom_rules = {
						"scratch/custom_rules/",
					},
				},

				md_files = {
					"AGENT.md",
				},

				display_errors = true,
			})

			-- ============================================================
			-- Keymaps
			-- ============================================================

			vim.keymap.set("n", "<leader>9f", function()
				_99.fill_in_function()
			end, { desc = "99: Fill Function (Auto)" })

			vim.keymap.set("v", "<leader>9v", function()
				_99.visual()
			end, { desc = "99: Visual Replace (Auto)" })

			vim.keymap.set("n", "<leader>9F", function()
				_99.fill_in_function_prompt()
			end, { desc = "99: Fill Function with Prompt" })

			vim.keymap.set("v", "<leader>9V", function()
				_99.visual_prompt()
			end, { desc = "99: Visual Replace with Prompt" })

			vim.keymap.set({ "n", "v" }, "<leader>9s", function()
				_99.stop_all_requests()
				print("99: Requests stopped")
			end, { desc = "99: Stop Requests" })

			vim.keymap.set("n", "<leader>9i", function()
				_99.info()
			end, { desc = "99: Info/Status" })

			vim.keymap.set("n", "<leader>9l", function()
				_99.view_logs()
			end, { desc = "99: View Logs" })

			vim.keymap.set("n", "<leader>9n", function()
				_99.next_request_logs()
			end, { desc = "99: Next Log" })
			vim.keymap.set("n", "<leader>9p", function()
				_99.prev_request_logs()
			end, { desc = "99: Prev Log" })

			vim.keymap.set("n", "<leader>9d", function()
				_99.fill_in_function({
					additional_rules = {
						{ name = "debug", path = vim.fn.expand("~/.rules/debug.md") },
					},
				})
			end, { desc = "99: Fill with Debug Rule" })

			-- ============================================================
			-- Cycle Models Window
			-- ============================================================
			vim.keymap.set("n", "<leader>9m", function()
				-- Cycle the index
				current_model_idx = (current_model_idx % #models) + 1
				local new_model = models[current_model_idx]

				-- Update the plugin state
				_99.set_model(new_model)

				-- UI: Show notification using standard vim.notify
				vim.notify("Switched to: " .. new_model, vim.log.levels.INFO, { title = "99 Agent" })
			end, { desc = "99: Cycle AI Model" })

			-- Select Model from Menu (<leader>9M)
			-- If you forget the order, this pops up a selection list
			vim.keymap.set("n", "<leader>9M", function()
				vim.ui.select(models, {
					prompt = "Select 99 Model:",
					format_item = function(item)
						-- Add a marker for the currently active model
						return (item == models[current_model_idx] and "* " or "  ") .. item
					end,
				}, function(choice, idx)
					if choice then
						current_model_idx = idx
						_99.set_model(choice)
						vim.notify("Switched to: " .. choice, vim.log.levels.INFO, { title = "99 Agent" })
					end
				end)
			end, { desc = "99: Select AI Model" })
		end,
	},
}
