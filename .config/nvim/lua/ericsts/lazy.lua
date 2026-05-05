-- nvim/lua/ericsts/lazy.lua
-- Instala o Lazy.nvim automaticamente se não estiver instalado

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Usa a versão estável
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configura o Lazy para buscar plugins na pasta ericsts/plugins
require("lazy").setup(
  {
    {
      import = "ericsts.plugins" -- Importa todos os arquivos .lua de plugins/
    },
  },
  {
    rocks = {
      hererocks = false, -- Desabilita hererocks (não necessário)
      enabled = false,   -- Desabilita suporte a luarocks
    },
    checker = {
      enabled = true,  -- Verifica atualizações automaticamente
      notify = false,  -- Não mostra notificações de atualização
    },
    change_detection = {
      notify = false,  -- Não notifica sobre mudanças nos arquivos de config
    },
  }
)
