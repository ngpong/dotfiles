return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_install = { "cpp", "c" }
    }
  },
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "clang-format" } } -- "clangd"
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    dependencies = {
      "p00f/clangd_extensions.nvim",
    },
    autocmds = {
      {
        "FileType",
        function(args)
          vim.__key.rg("n", "q", function()
            vim.__win.close(0)
            vim.__buf.wipeout(args.buf)
          end, { buffer = args.buf, silent = true })
        end,
        pattern = { "ClangdTypeHierarchy", "ClangdAST" }
      }
    },
    opts = {
      servers = {
        clangd = {
          keys = {
            { "ft", "<CMD>ClangdTypeHierarchy<CR>", silent = true },
            { "gs", "<CMD>ClangdSwitchSourceHeader<CR>", silent = true },
          },
          cmd = {
            "clangd",
            "-j=16",
            "--clang-tidy",
            "--background-index",
            "--background-index-priority=normal",
            "--ranking-model=decision_forest",
            "--completion-style=bundled", -- detailed, bundled
            "--header-insertion=never", -- iwyu
            "--header-insertion-decorators=false",
            "--function-arg-placeholders=false",
            "--pch-storage=memory",
            "--limit-references=0",
            "--rename-file-limit=0",
            -- "--query-driver=/usr/bin/gcc-4.8,/usr/bin/g++-4.8",
            -- "--limit-results=30",
            -- "--compile-commands-dir=/home/ngpong/code/cpp/CPP-Study-02/TEST/TEST_93/",
            -- "--log=verbose",
          },
          single_file_support = true,
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "tcc" },
          capabilities = {
            offsetEncoding = { "utf-16" },
            textDocument = {
              completion = {
                completionItem = {
                  -- 该配置能够在接受完成函数类型的项目后，自动添加 ()，但是这么做的话会使 . 出现
                  -- 一些奇怪的行为，这也导致在多光标模式下无法很好适配
                  snippetSupport = false
                }
              }
            },
          },
          on_attach = function(cli, bufnr)
            -- cli.server_capabilities.signatureHelpProvider.triggerCharacters = { "(", ")", "<", ">", "," }

            -- require("clangd_extensions.inlay_hints").setup_autocmd()
            -- require("clangd_extensions.inlay_hints").set_inlay_hints()
          end,
        },
        ccls = {
          enabled = false,
          init_options = {
            cache = {
              directory = ".ccls-cache";
            };
          },
          single_file_support = true,
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "tcc" },
          capabilities = {
            offsetEncoding = { "utf-16" },
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true
                }
              }
            },
          },
        },
      },
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    opts = {
      inlay_hints = {
        inline = vim.fn.has("nvim-0.10") == 1,
        only_current_line = false,
        only_current_line_autocmd = { "CursorHold" },
        show_parameter_hints = true,
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
        priority = 100,
      },
      ast = {
        role_icons = {
          type = vim.__icons.lsp_kinds.Type.val,
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
        highlights = {
          detail = "Comment",
        },
      },
      memory_usage = {
        border = "rounded",
      },
      symbol_info = {
        border = "rounded",
      },
    },
  },
}
