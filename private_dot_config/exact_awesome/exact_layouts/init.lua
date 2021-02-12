local awful = require("awful")

-- ===================================================================
-- Tag layout and popup management
-- ===================================================================
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({awful.layout.suit.tile, awful.layout.suit.floating})
end)

