-- Just an example, supposed to be placed in /lua/custom/

local M = {}
local userPlugins = require "custom.plugins" -- path to table
-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
   theme = "gruvbox",
}

M.plugins = {
  install = userPlugins,
   status = {
      alpha = true,
   },
}

return M
