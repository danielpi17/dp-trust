------------------------------------------------
---  Configuration for dp-trust by DanielPi  ---
------------------------------------------------

Config = {}

-- Permissions
Config.adminPermission = "dptrust.admin"

-- Command
Config.command = "trust"

-- Keybind
Config.keybind = "F3"

-- Threshold Time
Config.serverThreshold = 30 -- Every x minutes the server will clear its cache and reset it in case of a bug
Config.clientThreshold = 15 -- Every x minutes the client will clear its cache and reset it in case of a bug (client should be sooner due to easier cache manipulation)
-- THIS SETTING MAY AFFECT PERFORMANCE. KEEP IN MIND WHEN CHOOSING HOW OFTEN