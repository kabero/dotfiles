local telescope = require("telescope")
-- local lga_actions = require("telescope-live-grep-args.actions")
local actions = require("telescope.actions")
telescope.setup {
    defaults = {
        mappings = {
            i = {
                -- scroll results
                ["<C-u>"] = actions.results_scrolling_up,
                ["<C-d>"] = actions.results_scrolling_down,

                -- open in split window
                ["<C-t>"] = actions.select_tab,
                ["<C-l>"] = actions.select_vertical,
                ["<C-j>"] = actions.select_horizontal,

                -- emacs-like mappings
                ["<C-b>"] = { "<left>", type = "command" },
                ["<C-f>"] = { "<right>", type = "command" },
                ["<C-a>"] = { "<c-o>0", type = "command" },
                ["<C-e>"] = { "<c-o>$", type = "command" },
                ["<C-k>"] = { "<c-o>D", type = "command" },
                ["<C-h>"] = { "<BS>", type = "command" },
                ["<M-BS>"] = { "<c-o>db<BS>", type = "command" },

                -- use telescope only in insert mode
                ['<C-]>'] = actions.close,
                ['<ESC>'] = actions.close,
                ['<C-c>'] = actions.close,
            },
            n = {
                ["q"] = require("telescope.actions").close
            },
        },
        prompt_prefix = "> ",
        selection_caret = "  ",
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        layout_strategy = "bottom_pane",
        layout_config = {
            bottom_pane = {
                height = 0.4,
                preview_cutoff = 120,
                prompt_position = "top",
            },
        },
        sorting_strategy = "ascending",
        winblend = 0,
        border = {},
        set_env = { ["COLORTERM"] = "truecolor" },
        file_ignore_patterns = {
            "node_modules/",
            "vendor/",
            ".git/",
            "target/",
            "dist/",
            "*.min.js",
            "*.min.css",
            "out/",
            "bin/",
            "obj/",
            ".next/",
            ".nuxt/",
            "_site/",
            "public/build/",
            -- logs
            "*.log",
            "logs/",
            "log/",
            -- temporary files
            "__pycache__/",
            "*.pyc",
            "*.pyo",
            ".pytest_cache/",
            ".coverage",
            "coverage/",
            "htmlcov/",
            -- compiled files
            "*.class",
            "*.jar",
            "*.war",
            "*.o",
            "*.so",
            "*.dll",
            "*.exe",
            -- images
            "*.jpg",
            "*.jpeg",
            "*.png",
            "*.gif",
            "*.svg",
            "*.ico",
            "*.mp4",
            "*.mp3",
            "*.wav",
            -- docs
            "*.pdf",
            "*.doc",
            "*.docx",
            "*.xls",
            "*.xlsx",
            "*.ppt",
            "*.pptx",
            "*.lock",
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
        },
    },
    pickers = {
        commands = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
        colorscheme = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
        oldfiles = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
        find_files = {
            theme = "ivy",
            hidden = false,
            no_ignore = true,
            layout_config = {
                height = 35
            }
        },
        live_grep = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
        grep_string = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
        jumplist = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
        diagnostics = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
        buffers = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
        git_commits = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
        git_bcommits = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
        git_status = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
        git_files = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
        builtin = {
            theme = "ivy",
            layout_config = {
                height = 35
            }
        },
    },
    -- TODO: fix to apply configs related to telescope.live_grep_args
    extensions = {
        live_grep_args = {
            auto_quoting = true,
            -- mappings = {
            --     i = {
            -- ["<C-k>"] = lga_actions.quote_prompt(),
            -- ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            --     },
            -- },
            theme = "ivy",
            layout_config = {
                height = 40,
            },
        },
        egrepify = {
            theme = "ivy",
            layout_config = {
                height = 35,
            },
            mappings = {
                i = {
                    ["<C-a>"] = { "<c-o>0", type = "command" },
                }
            },
            permutations = false,
            lnum_hl = "Normal",
            col_hl = "Normal",
            prefixes = {
                ["!"] = {
                    flag = "invert-match",
                },
                ["^"] = false
            },
        }
    }
}

function SearchChangesFilesInBranch()
    require('telescope.builtin').git_files({
        git_command = { "git", "diff", "--name-only", "master..." },
        prompt_title = "Changed Files in Current Branch",
        use_git_root = true,
    })
end

local opts = { noremap = true, silent = true }
-- Finder
vim.keymap.set('n', '<leader>fh', ":lua require('telescope.builtin').oldfiles({cwd_only = true})<CR>", opts)
vim.keymap.set('n', '<leader>fH', ':Telescope oldfiles<CR>', opts)
vim.keymap.set('n', '<leader>fj', ':Telescope find_files<CR>', opts)
-- vim.keymap.set('n', '<leader>fk', ':Telescope live_grep<CR>', opts)
-- vim.keymap.set("n", "<leader>fk", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set('n', '<leader>fk', ':Telescope egrepify<CR>', opts)
vim.keymap.set('n', '<leader>fl', ':Telescope grep_string<CR>', opts)
-- vim.keymap.set('n', '<leader>fi', ':Telescope jumplist show_line=false<CR>', opts)
-- vim.keymap.set('n', '<leader>fo', ':Telescope diagnostics<CR>', opts)
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', opts)

-- Git
-- vim.keymap.set('n', '<leader>gc', ':Telescope git_commits<CR>', opts)
vim.keymap.set('n', '<leader>gb', ':Telescope git_bcommits<CR>', opts)
vim.keymap.set('n', '<leader>gf', ':Telescope git_files<CR>', opts)
vim.keymap.set('n', '<leader>gd', ':lua SearchChangesFilesInBranch()<CR>', opts)
vim.keymap.set('n', '<leader>gs', ':Telescope git_status<CR>', opts)

-- Resume
vim.keymap.set('n', '<leader>jk', ':Telescope resume<CR>', opts)
vim.keymap.set('n', '<leader>jl', ':Telescope builtin<CR>', opts)
