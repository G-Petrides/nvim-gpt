
### Neovim ChatGPT plugin

Super simple GPT plugin for making ChatGPT requests.

### Installation

Using [Packer](https://github.com/wbthomason/packer.nvim):

```lua
use {
  "G-Petrides/nvim-gpt",
  requires = {"nvim-lua/plenary.nvim"}
}
```

Using [Lazy](https://github.com/folke/lazy.nvim):

```lua
{
  "G-Petrides/nvim-gpt",
  dependencies={"nvim-lua/plenary.nvim"},
  config = function()
    require('nvim-gpt').setup("API Key Goes Here")
  end
}
```
  
### Setup

1) Register OpenAI account and get API key here: [API Key](https://platform.openai.com/account/api-keys)
2) Setup in init.lua
```lua
  require("G-Petrides/nvim-gpt").setup("API Key Goes Here")
```

### Use

Simply use the :Gpt command followed by the prompt for chatgpt:

```
:Gpt build me a simple chatgpt plugin for neovim
```
The command will open an new vspilt window and buffer and output the prompt and result when returned

