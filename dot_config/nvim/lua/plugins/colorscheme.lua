return {
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require('kanagawa').setup({
                commentStyle = { italic = false },
                keywordStyle = { italic = false },
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none",
                            },
                        },
                    },
                },
                dimInactive = false,
                transparent = false,
                terminalColors = true,
                theme = "dragon",
                background = {
                    dark = "dragon",
                    light = "lotus",
                },
            })
        end
    },
}
