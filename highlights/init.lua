local Color = require("neogit.lib.color").Color
local green = Color.from_hex "#C3E88D"
local red = Color.from_hex "#E06C75"

return { -- this table overrides highlights in all themes
  -- Normal = { bg = "#000000" },
  -- NeogitHunkHeader
  -- NeogitDiffContext
  --
  -- NeogitDiffAdd = { bg = "#000000" },
  NeogitDiffAddHighlight = { bg = green:shade(-0.72):set_saturation(0.2):to_css() },
  NeogitDiffDeleteHighlight = { bg = red:shade(-0.6):set_saturation(0.4):to_css() },
  -- NeogitHunkHeaderHighlight
  -- NeogitDiffContextHighlight
  -- NeogitDiffDeleteHighlight
  -- NeogitDiffHeaderHighlight
  -- NeogitDiffDelete
  -- NeogitDiffHeader
}
