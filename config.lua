Config = {}

-- Main loop interval (ms) for re-applying critical hit / helmet resistance flags
Config.CheckInterval = 500

-- Keep headshots lethal
Config.ForceCriticalHits = true

-- Remove helmet damage reduction behavior
Config.DisableHelmetDamageReduction = true
Config.HelmetConfigFlag = 438

-- NEW: Hard-block automatic helmets (bike, scripts, mask interactions, etc.)
-- This runs on a faster interval to strip any helmet prop quickly.
Config.DisableAutoHelmet = true
Config.AutoHelmetBlockInterval = 150

-- Optional: legacy behavior toggle (kept for compatibility)
-- If true, it also forces no helmet in the main loop.
Config.ForceNoHelmet = true

-- Optional debug prints in F8
Config.Debug = false
