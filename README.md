# dotfiles

Configurações pessoais do terminal gerenciadas com [GNU Stow](https://www.gnu.org/software/stow/).

## Estrutura

```
dotfiles/
├── .zshrc                        # Entrada principal do ZSH
├── .config/
│   ├── bin/
│   │   └── laravel.sh            # Script helper para Laravel no Docker
│   ├── kitty/
│   │   ├── kitty.conf            # Configuração principal do Kitty
│   │   ├── current-theme.conf    # Tema ativo (carregado pelo kitty.conf)
│   │   ├── themes/               # Temas disponíveis para trocar com `kt`
│   │   └── kitty-themes/         # Coleção de temas extras (kitten themes)
│   ├── nvim/                     # Configuração completa do Neovim
│   │   ├── init.lua
│   │   └── lua/ericsts/
│   │       ├── lazy.lua          # Gerenciador de plugins
│   │       ├── vim-options.lua   # Opções gerais do Neovim
│   │       └── plugins/          # Um arquivo por plugin
│   ├── starship.toml             # Prompt do terminal
│   └── zsh/                      # Módulos ZSH separados por tema
│       ├── alias.zsh
│       ├── completion.zsh
│       ├── docker.zsh
│       ├── env.zsh
│       ├── fzf.zsh
│       ├── git.zsh
│       ├── path.zsh
│       ├── php.zsh
│       └── plugins.zsh
```

---

## GNU Stow

O Stow cria **symlinks** da pasta `dotfiles/` para o diretório home (`~`), mantendo os arquivos versionados em um único lugar.

### Como funciona

O Stow espelha a estrutura de pastas do repositório a partir do `$HOME`. Por exemplo:

```
dotfiles/.config/kitty/kitty.conf
        ↓ stow cria symlink
~/.config/kitty/kitty.conf → ~/dotfiles/.config/kitty/kitty.conf
```

### Instalação

```bash
# Fedora / RHEL
sudo dnf install stow

# Ubuntu / Debian
sudo apt install stow

# macOS
brew install stow
```

### Uso

```bash
# Clonar o repositório
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# Criar todos os symlinks (executar a partir de ~/dotfiles)
stow .

# Remover os symlinks
stow -D .

# Simular sem criar (dry run)
stow -n .
```

> **Atenção:** se já existirem arquivos de config no `$HOME`, o Stow vai falhar. Delete ou mova os arquivos originais antes de rodar `stow .`.

### Salvar alterações

Após editar qualquer config, basta fazer commit normalmente — os arquivos reais estão em `~/dotfiles`:

```bash
cd ~/dotfiles
git add .
git commit -m "descrição da mudança"
git push
```

---

## ZSH

O `.zshrc` carrega automaticamente todos os arquivos `*.zsh` dentro de `~/.config/zsh/`, além de inicializar as ferramentas externas.

**Ferramentas inicializadas no `.zshrc`:**

| Ferramenta | Função |
|---|---|
| [Oh My Zsh](https://ohmyz.sh/) | Framework de configuração do ZSH |
| [Starship](https://starship.rs/) | Prompt customizado |
| [Atuin](https://atuin.sh/) | Histórico de comandos inteligente (busca com `Ctrl+R`) |
| [Zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` inteligente com histórico (`z <pasta>`) |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder no terminal |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | Info do sistema ao abrir o terminal |
| fortune + cowsay | Frase aleatória ao abrir o terminal |

**Plugins Oh My Zsh (`plugins.zsh`):**

| Plugin | Função |
|---|---|
| `eza` | Substitui `ls` com ícones, cores e git status |
| `asdf` | Gerenciador de versões (Node, Ruby, etc.) |
| `aliases` | Lista aliases com `als` |
| `composer` | Completions para Composer |
| `zsh-autosuggestions` | Sugestões de comandos baseadas no histórico |
| `zsh-syntax-highlighting` | Destaca comandos válidos/inválidos em tempo real |

### Configuração do eza

O `ls` é substituído pelo `eza` com:
- Pastas primeiro
- Git status inline
- Cabeçalho de colunas
- Ícones Nerd Font
- Escala de cores por tamanho de arquivo
- Tamanhos em formato binário (KiB, MiB)
- Hyperlinks nos arquivos

---

### Módulos ZSH

#### `alias.zsh` — Atalhos gerais

| Alias | Comando |
|---|---|
| `n` | `nvim` |
| `y` | `yazi` |
| `reload-zsh` | Recarrega o `.zshrc` |
| `edit-zsh` | Abre o `.zshrc` no nvim |
| `lv` | `laravel` |
| `lva` | `laravel artisan` |
| `lvs` | `laravel shell` |
| `lvc` | `laravel clear` |
| `lvo` | `laravel optimize` |
| `lvm` | `laravel migrate` |
| `lvt` | `laravel tinker` |
| `lvst` | `laravel status` |
| `lvl` | `laravel logs` |

#### `git.zsh` — Atalhos Git

| Alias / Função | Comando |
|---|---|
| `gst` | `git status` |
| `gl` | `git pull` |
| `gp` | `git push` |
| `gpf` | `git push --force-with-lease` |
| `gcm` | `git commit -m` |
| `gc` | `git commit` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gd` | `git diff` |
| `gaa` | `git add --all` |
| `gfe` | Abre arquivos modificados com preview do diff via fzf |

#### `docker.zsh` — Atalhos Docker

| Alias / Função | Ação |
|---|---|
| `d` | `docker` |
| `dc` | `docker compose` |
| `dip` | Remove imagens não utilizadas |
| `dsp` | Remove tudo não utilizado (imagens, containers, redes) |
| `dl` | `docker logs -f` |
| `dex <container> [cmd]` | `docker exec -it` no container |
| `dcl <serviço>` | `docker compose logs -f` do serviço |

#### `php.zsh` — PHP e Laravel

| Alias / Função | Ação |
|---|---|
| `pa` | `php artisan` |
| `sail` | `bash vendor/bin/sail` |
| `pint` | `./vendor/bin/pint` |
| `pest` | `./vendor/bin/pest` |
| `pint-staged` | Formata apenas os arquivos PHP staged no git |

#### `path.zsh` — Variáveis de ambiente e PATH

- `~/bin` e `~/.local/bin` no PATH
- [asdf](https://asdf-vm.com/) shims no PATH
- Rust (via asdf)
- Neovim instalado em `/opt/nvim-linux-x86_64`
- Java 21 (OpenJDK)
- Android SDK

#### `fzf.zsh` — Configuração do FZF

FZF configurado com tema de cores escuro, preview automático (diretórios mostram árvore via `eza`, arquivos mostram conteúdo via `bat`), layout reverso e janela de preview lateral ocupando 70% da tela.

#### `completion.zsh` — Autocompletar ZSH

Completions nativos do ZSH habilitados com:
- Menu de seleção interativo
- Case-insensitive
- Completions customizados em `~/.config/zsh/completions/` (inclui `_laravel`)

---

## Kitty

Terminal emulador GPU-accelerated.

**Arquivo:** `.config/kitty/kitty.conf`

| Configuração | Valor |
|---|---|
| Tema ativo | `current-theme.conf` |
| Fonte | Hack Nerd Font, 12pt |
| Opacidade de fundo | 50% (ajustável dinamicamente) |
| Seleção de texto | Fundo azul, texto preto |

### Temas disponíveis

Os temas ficam em `.config/kitty/themes/` e o tema ativo é sempre o `current-theme.conf`.

| Tema | Estilo |
|---|---|
| `adwaita-darker` | Escuro GNOME, preto com acentos azuis |
| `catppuccin-mocha` | Escuro suave, paleta pastéis |
| `dracula` | Escuro roxo, alto contraste |
| `tokyo-night` | Escuro azulado, inspirado em Tokyo |
| `gruvbox-dark` | Escuro quente, tons de marrom e amarelo |
| `nord` | Escuro frio, paleta ártica azul-cinza |

### Como trocar de tema

**Opção 1 — Script com fzf (recomendado):**

```bash
kt        # alias para kitty-theme
# ou
kitty-theme
```

Abre um seletor interativo com preview do tema. Ao confirmar, o tema é aplicado imediatamente e o Kitty é recarregado.

**Opção 2 — Kitty nativo (`kitten themes`):**

```bash
# Abre o gerenciador de temas oficial do Kitty
kitten themes
```

O Kitty baixa temas da internet e permite preview em tempo real. O tema escolhido substitui o bloco `BEGIN_KITTY_THEME` no `kitty.conf`.

**Opção 3 — Manual:**

```bash
# Copiar o tema desejado para current-theme.conf
cp ~/.config/kitty/themes/dracula.conf ~/.config/kitty/current-theme.conf

# Recarregar o Kitty
kill -SIGUSR1 $(pgrep -x kitty)
```

**Atalhos úteis do Kitty:**

| Atalho | Ação |
|---|---|
| `Ctrl+Shift+F5` | Recarrega configuração |
| `Ctrl+Shift+Enter` | Nova janela |
| `Ctrl+Shift+T` | Nova aba |
| `Ctrl+Shift+C/V` | Copiar / Colar |
| `Ctrl+Shift++/-` | Aumenta / diminui fonte |

---

## Starship

Prompt minimalista e rápido configurado em `.config/starship.toml`.

O prompt exibe (da esquerda para direita):
1. **Diretório atual** (truncado em 3 níveis)
2. **Branch Git** + status (modificações, ahead/behind)
3. **Versão da linguagem ativa** no projeto: Node.js, Rust, Go ou PHP
4. **Hora atual**

---

## Neovim

Configuração modular em Lua, usando [Lazy.nvim](https://github.com/folke/lazy.nvim) como gerenciador de plugins.

**Leader key: `<Space>`**

### Tema de cores

O tema atual é o **Catppuccin**, configurado em `.config/nvim/lua/ericsts/plugins/catppuccin.lua`.

**Trocar a variante do Catppuccin:**

O Catppuccin tem 4 variantes. Edite o arquivo `catppuccin.lua` e altere `flavour`:

```lua
require("catppuccin").setup({
  flavour = "mocha",   -- mocha (escuro) | macchiato | frappe | latte (claro)
})
```

| Variante | Estilo |
|---|---|
| `mocha` | Escuro intenso — padrão atual |
| `macchiato` | Escuro médio |
| `frappe` | Escuro suave |
| `latte` | Claro |

Você também pode deixar `flavour = "auto"` para seguir o tema do sistema operacional.

**Trocar para outro tema:**

Substitua o conteúdo de `catppuccin.lua` por um dos exemplos abaixo.

<details>
<summary>Tokyo Night</summary>

```lua
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "storm",  -- storm | night | moon | day
      transparent = true,
    })
    vim.cmd.colorscheme "tokyonight"
  end
}
```

</details>

<details>
<summary>Dracula</summary>

```lua
return {
  "Mofiqul/dracula.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme "dracula"
  end
}
```

</details>

<details>
<summary>Gruvbox</summary>

```lua
return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("gruvbox").setup({ contrast = "hard" })
    vim.cmd.colorscheme "gruvbox"
  end
}
```

</details>

<details>
<summary>Kanagawa</summary>

```lua
return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      theme = "dragon",  -- wave | dragon | lotus
    })
    vim.cmd.colorscheme "kanagawa"
  end
}
```

</details>

> Após substituir o plugin, rode `:Lazy sync` no Neovim para instalar o novo tema e remover o antigo.

### Gerenciadores

| Comando | Ação |
|---|---|
| `:Lazy` | Abre o gerenciador de plugins |
| `:Mason` | Abre o gerenciador de LSPs, formatters e debug adapters |

No Lazy: `I` instala, `U` atualiza, `S` sincroniza, `X` remove não usados.  
No Mason: `i` instala, `X` desinstala, `/` filtra por nome.

---

### Plugins instalados

| Plugin | Função |
|---|---|
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Dashboard/tela inicial |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Fecha `()`, `[]`, `""` automaticamente |
| [catppuccin](https://github.com/catppuccin/nvim) | Tema de cores |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + LuaSnip | Autocompletar + snippets |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) + dap-ui | Debug com interface visual (PHP/Xdebug + Go/Delve) |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Indicadores de git na gutter |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | Gerenciador de LSPs e ferramentas |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Configuração de Language Servers |
| [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim) | Formatters via LSP (stylua, pint, goimports) |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Barra de status inferior |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | Explorador de arquivos lateral |
| [laravel.nvim](https://github.com/adalessa/laravel.nvim) | Integração com framework Laravel |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Busca fuzzy de arquivos e texto |
| [neotest](https://github.com/nvim-neotest/neotest) + phpunit | Rodar testes PHPUnit/Pest |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting avançado |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Mostra atalhos ao pressionar `<Space>` |
| [harpoon2](https://github.com/ThePrimeagen/harpoon) | Marcar e navegar entre arquivos frequentes |
| [flash.nvim](https://github.com/folke/flash.nvim) | Navegação turbo para qualquer texto visível |
| [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) | Interface LazyGit integrada ao Neovim |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git avançado: commits, diff, blame, merge |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Painel organizado de diagnósticos e quickfix |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Destaca e busca TODO/FIXME/HACK/NOTE no código |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Renderiza markdown com formatação visual no buffer |

**LSPs instalados via Mason:**

| LSP | Linguagem |
|---|---|
| `lua_ls` | Lua |
| `intelephense` | PHP |
| `tailwindcss` | Tailwind CSS |
| `gopls` | Go |

**Formatters instalados via Mason:**

| Formatter | Linguagem |
|---|---|
| `stylua` | Lua |
| `pint` | PHP (Laravel) |
| `goimports` | Go |

**Debug adapters instalados via Mason:**

| Adapter | Linguagem |
|---|---|
| `php` (Xdebug) | PHP — porta 9003 |
| `delve` | Go |

---

### Atalhos do Neovim

#### Neo-tree (explorador de arquivos)

| Atalho | Ação |
|---|---|
| `Ctrl+N` | Abre / fecha Neo-tree |
| `<Space>e` | Revela arquivo atual no Neo-tree |
| `l` / `Enter` | Abre arquivo ou pasta |
| `h` | Vai para pasta pai |
| `<Space>` | Expande / colapsa pasta |
| `Backspace` | Fecha pasta |

#### Telescope (busca)

| Atalho | Ação |
|---|---|
| `Ctrl+P` | Busca arquivos |
| `<Space>fg` | Busca texto em todos os arquivos (live grep) |

#### LSP

| Atalho | Ação |
|---|---|
| `K` | Documentação do símbolo sob cursor |
| `gd` | Ir para definição |
| `gD` | Ir para declaração |
| `gR` | Ver referências |
| `gi` | Ver implementações |
| `gt` | Ver type definitions |
| `<Space>ca` | Code actions |
| `<Space>rn` | Renomear símbolo |
| `<Space>d` | Diagnóstico da linha |
| `<Space>D` | Todos os diagnósticos do buffer |
| `[d` / `]d` | Diagnóstico anterior / próximo |
| `<Space>rs` | Reiniciar LSP |

#### Git (Gitsigns)

| Atalho | Ação |
|---|---|
| `<Space>gp` | Preview do hunk |
| `<Space>gr` | Desfaz hunk |
| `<Space>gb` | Blame da linha |
| `<Space>gd` | Diff do arquivo |
| `<Space>gf` | Formatar arquivo |
| `[c` / `]c` | Navegar entre hunks |

#### Debug (DAP)

| Atalho | Ação |
|---|---|
| `<Space>dt` | Toggle breakpoint |
| `<Space>dc` | Iniciar / continuar debug |
| `<Space>dn` | Step over |
| `<Space>di` | Step into |
| `<Space>do` | Step out |
| `<Space>dr` | Abrir REPL |
| `<Space>du` | Toggle UI de debug |

#### Testes (Neotest / Pest)

| Atalho | Ação |
|---|---|
| `<Space>tr` | Rodar teste mais próximo do cursor |
| `<Space>tf` | Rodar todos os testes do arquivo |
| `<Space>ts` | Toggle painel de resumo |

#### Autocompletar (nvim-cmp)

| Atalho | Ação |
|---|---|
| `Ctrl+Space` | Abre menu manualmente |
| `Enter` | Confirma sugestão |
| `Ctrl+e` | Fecha menu |
| `Ctrl+b` / `Ctrl+f` | Scroll na documentação |

#### PHP / Laravel

| Atalho | Ação |
|---|---|
| `<Space>pf` | Formatar arquivo com Pint |
| `<Space>ps` | Formatar arquivos staged com Pint |
| `<Space>pa` | Rodar comando artisan |

#### Splits e navegação

| Atalho | Ação |
|---|---|
| `Ctrl+H/J/K/L` | Navegar entre splits |
| `<Space>ya` | Copiar arquivo inteiro pro clipboard |
| `<C-w>v` | Split vertical |
| `<C-w>s` | Split horizontal |
| `<C-w>q` | Fecha janela |
| `<C-w>=` | Equaliza tamanhos |

#### Harpoon (navegação rápida entre arquivos)

| Atalho | Ação |
|---|---|
| `<Space>ha` | Adicionar arquivo atual ao Harpoon |
| `<Space>hh` | Abrir menu do Harpoon |
| `<Space>1` / `2` / `3` / `4` | Pular direto para o arquivo marcado |
| `<Space>hn` / `<Space>hp` | Próximo / anterior no Harpoon |

#### Flash (jump turbo)

| Atalho | Modo | Ação |
|---|---|---|
| `s` + 2 letras | Normal / Visual / Operator | Pular para qualquer texto visível |
| `S` | Normal / Visual / Operator | Pular por nó do Treesitter |
| `r` | Operator | Remote flash (aplicar operador em posição distante) |
| `R` | Operator / Visual | Busca por nó do Treesitter |

> **Nota:** `s` substitui o comando nativo `s` (substitute char). Use `cl` no lugar.

#### LazyGit

| Atalho | Ação |
|---|---|
| `<Space>gg` | Abrir LazyGit |
| `<Space>gL` | Histórico do arquivo atual no LazyGit |

#### Fugitive (git avançado)

| Atalho / Comando | Ação |
|---|---|
| `<Space>gG` | Abrir status do Fugitive |
| `<Space>gB` | Blame de todo o arquivo |
| `<Space>gM` | Merge tool |
| `:Gdiff` | Diff do arquivo atual |
| `:Git commit` | Criar commit |
| `:Git push` | Push |

#### Trouble (diagnósticos)

| Atalho | Ação |
|---|---|
| `<Space>xx` | Toggle diagnósticos do projeto |
| `<Space>xb` | Toggle diagnósticos do buffer atual |
| `<Space>xs` | Símbolos do arquivo |
| `<Space>xl` | Definições e referências LSP |
| `<Space>xq` | Quickfix list |
| `]x` / `[x` | Próximo / anterior item no Trouble |

#### Todo Comments

| Atalho | Ação |
|---|---|
| `<Space>ft` | Buscar todos os TODOs com Telescope |
| `]t` / `[t` | Próximo / anterior TODO no arquivo |

Keywords destacadas automaticamente: `TODO`, `FIXME`, `HACK`, `WARN`, `NOTE`, `PERF`, `TEST`

#### Render Markdown

Ativa automaticamente em arquivos `.md`. Renderiza no buffer:
- Headers com tamanho visual diferenciado
- **Negrito**, *itálico*, `código inline`
- Blocos de código com sintaxe
- Listas com bullets reais
- Tabelas alinhadas

#### Vim nativos úteis

| Atalho | Ação |
|---|---|
| `<C-a>` / `<C-x>` | Incrementa / decrementa número sob cursor |

---

## Script Laravel Docker (`bin/laravel.sh`)

Helper para executar comandos Laravel dentro de containers Docker. Detecta automaticamente o container da aplicação.

Adicionado ao PATH via `path.zsh` e acessível pelo alias `lv` / `laravel`.

| Comando | Ação |
|---|---|
| `laravel artisan [cmd]` | Executa comando artisan |
| `laravel tinker` | Abre o Tinker |
| `laravel migrate` | Executa migrations |
| `laravel fresh` | migrate:fresh (apaga tudo — pede confirmação) |
| `laravel seed [class]` | Executa seeders |
| `laravel test` | Executa testes |
| `laravel composer [cmd]` | Executa composer no container |
| `laravel npm [cmd]` | Executa npm no container |
| `laravel shell` | Entra no shell como usuário laravel |
| `laravel root` | Entra no shell como root |
| `laravel clear` | Limpa config, cache, views e rotas |
| `laravel optimize` | Gera cache de config, rotas e views |
| `laravel logs [serviço]` | Tail dos logs do serviço |
| `laravel status` | Status detalhado (containers, volumes, redes) |
| `laravel backup-db` | Backup do banco (MySQL ou PostgreSQL) |
| `laravel info` | Versões do Laravel, PHP e Composer |

---

## Restaurar em uma nova máquina

```bash
# 1. Instalar dependências essenciais
sudo dnf install stow git zsh neovim kitty

# 2. Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 3. Clonar dotfiles
git clone <repo-url> ~/dotfiles

# 4. Remover configs padrão que possam conflitar
rm -f ~/.zshrc

# 5. Aplicar symlinks
cd ~/dotfiles
stow .

# 6. Instalar plugins extras do ZSH
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 7. Instalar ferramentas externas
# Starship: https://starship.rs
# Atuin:    https://atuin.sh
# Zoxide:   https://github.com/ajeetdsouza/zoxide
# fzf:      https://github.com/junegunn/fzf
# eza:      https://github.com/eza-community/eza
# bat:      https://github.com/sharkdp/bat
# yazi:     https://github.com/sxyazi/yazi

# 8. Abrir Neovim — plugins instalam automaticamente via Lazy
nvim
```
