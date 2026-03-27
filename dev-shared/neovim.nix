{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      nvim-tree-lua
      nvim-web-devicons
      nvim-lspconfig
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      nvim-cmp
      telescope-nvim
      plenary-nvim
      luasnip
      smart-splits-nvim
      gitsigns-nvim
      fidget-nvim
      (nvim-treesitter.withPlugins (p: with p; [
        tree-sitter-bash
        tree-sitter-c
        tree-sitter-cpp
        tree-sitter-cmake
        tree-sitter-go
        tree-sitter-lua
        tree-sitter-markdown
        tree-sitter-json
        tree-sitter-rust
        tree-sitter-typescript
        tree-sitter-tsx
        tree-sitter-html
        tree-sitter-yaml
        tree-sitter-gomod
        tree-sitter-gitignore
      ]))
      { plugin = rustaceanvim; }
      lualine-nvim
    ];
    extraLuaConfig = ''
      -- Colorscheme
      require('catppuccin').setup({
        flavour = 'mocha',
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          fidget = true,
          telescope = { enabled = true },
        },
      })
      vim.cmd.colorscheme('catppuccin')

      -- Basic options
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.clipboard = 'unnamedplus'

      -- Lualine with jj status
      local function jj_status()
        local handle = io.popen('jj log -r @ --no-graph -T "separate(\" \", bookmarks, change_id.shortest(8))" 2>/dev/null')
        if not handle then return "" end
        local result = handle:read("*a")
        handle:close()
        return result:gsub("%s+$", "")
      end

      require('lualine').setup({
        options = {
          theme = 'auto',
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { { jj_status } },
          lualine_c = { 'filename' },
          lualine_x = { 'diagnostics' },
          lualine_y = { 'filetype' },
          lualine_z = { 'location' },
        },
      })

      -- LSP capabilities
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Lua language server
      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }
            },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
          },
        },
      })
      vim.lsp.enable('lua_ls')

      -- TypeScript/JavaScript language server
      vim.lsp.config('ts_ls', {
        capabilities = capabilities
      })
      vim.lsp.enable('ts_ls')

      -- C/C++ language server
      vim.lsp.config('clangd', {
        capabilities = capabilities
      })
      vim.lsp.enable('clangd')

      -- CMake language server
      vim.lsp.config('cmake', {
        capabilities = capabilities
      })
      vim.lsp.enable('cmake')

      -- Python language server
      vim.lsp.config('pyright', {
        capabilities = capabilities
      })
      vim.lsp.enable('pyright')

      -- HTML language server
      vim.lsp.config('html', {
        capabilities = capabilities
      })
      vim.lsp.enable('html')

      -- Go language server
      vim.lsp.config('gopls', {
        capabilities = capabilities
      })
      vim.lsp.enable('gopls')

      -- Zig language server
      vim.lsp.config('zls', {
        capabilities = capabilities
      })
      vim.lsp.enable('zls')

      -- Nix language server
      vim.lsp.config('nixd', {
        capabilities = capabilities
      })
      vim.lsp.enable('nixd')

      -- Rust with rustaceanvim
      vim.g.rustaceanvim = {
        server = {
          settings = {
            ['rust-analyzer'] = {
              cargo = { allFeatures = true, targetDir = true },
              check = {
                allTargets = true,
                command = 'clippy',
              },
              diagnostics = {
                disabled = { 'inactive-code', 'unresolved-proc-macro' },
              },
              procMacro = { enable = true },
              files = {
                excludeDirs = {
                  'target',
                  'node_modules',
                  '.direnv',
                  '.git',
                },
              },
            },
          },
        },
      }

      -- Completion with nvim-cmp
      local luasnip = require('luasnip')
      local cmp = require('cmp')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'buffer' },
        }),
      })

      -- Command line completion
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })

      -- Git signs
      require('gitsigns').setup({
        signcolumn = true,
        current_line_blame = true,
        current_line_blame_opts = {
            delay = 100,
        },
      })

      -- Fidget for LSP notifications
      require('fidget').setup({})

      -- Telescope setup
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      telescope.setup({
          defaults = {
              file_ignore_patterns = {
                  '.git',
                  'node_modules',
              },
              mappings = {
                  i = {
                      ['<C-k>'] = actions.move_selection_previous,
                      ['<C-j>'] = actions.move_selection_next,
                  }
              }
          }
      })

      -- Telescope keybinds
      vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { desc = 'Recent files' })
      vim.keymap.set('n', '<leader>fs', '<cmd>Telescope live_grep<cr>', { desc = 'Search in string' })
      vim.keymap.set('n', '<leader>fc', '<cmd>Telescope grep_string<cr>', { desc = 'Find string' })
      vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', { desc = 'Find diagnostics' })
      vim.keymap.set('n', '<leader>ld', '<cmd>Telescope lsp_definitions<cr>', { desc = 'LSP definitions' })
      vim.keymap.set('n', '<leader>lr', '<cmd>Telescope lsp_references<cr>', { desc = 'LSP references' })
      vim.keymap.set('n', '<leader>ls', '<cmd>Telescope lsp_document_symbols<cr>', { desc = 'LSP document symbols' })
      vim.keymap.set('n', '<leader>lw', '<cmd>Telescope lsp_workspace_symbols<cr>', { desc = 'LSP workspace symbols' })

      -- Nvim-tree setup
      require('nvim-tree').setup({
        git = {
            enable = true
        },
        update_focused_file = {
            enable = true
        },
        filters = {
            custom = { '.git$', 'node_modules' },
        },
        renderer = {
            root_folder_label = false,
            icons = {
                show = {
                    file = false
                }
            },
        },
        view = {
            number = true,
            width = 50,
            float = {
                enable = true,
                open_win_config = {
                    width = 50,
                    relative = "win",
                },
            },
        },
      })

      vim.keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
      vim.keymap.set('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>', { desc = 'Collapse file explorer' })
      vim.keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>', { desc = 'Refresh file explorer' })

      -- Smart splits keybinds
      vim.keymap.set('n', '<C-h>', function()
          require('smart-splits').move_cursor_left()
      end)
      vim.keymap.set('n', '<C-j>', function()
          require('smart-splits').move_cursor_down()
      end)
      vim.keymap.set('n', '<C-k>', function()
          require('smart-splits').move_cursor_up()
      end)
      vim.keymap.set('n', '<C-l>', function()
          require('smart-splits').move_cursor_right()
      end)
      vim.keymap.set('n', '<A-h>', function()
          require('smart-splits').resize_left()
      end)
      vim.keymap.set('n', '<A-j>', function()
          require('smart-splits').resize_down()
      end)
      vim.keymap.set('n', '<A-k>', function()
          require('smart-splits').resize_up()
      end)
      vim.keymap.set('n', '<A-l>', function()
          require('smart-splits').resize_right()
      end)

      -- General LSP keybinds
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
      vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover' })
      vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
      vim.keymap.set({'n', 'v'}, '<leader>cs', function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { 'source.organizeImports' } }
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              vim.lsp.util.apply_workspace_edit(r.edit, cid)
            else
              vim.lsp.buf.execute_command(r.command)
            end
          end
        end
      end, { desc = 'Organize imports' })
    '';
  };
}
