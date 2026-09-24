return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        arduino_language_server = {
          cmd = {
            "arduino-language-server",
            "-cli",
            "arduino-cli",
            "-clangd",
            "clangd",
            "-fqbn",
            "rp2040:rp2040:challenger_2040_nfc",
          },
        },
      },
    },
  },
}
