DEFINE_BASECLASS("gamemode_sandbox") --BaseClass.Initialize(self)
include("shared.lua")

--resources
resource.AddSingleFile("resource/localization/en/stacker_gamemode.properties")

--net globals
SetGlobalBool("GMActive", false)
SetGlobalBool("GMBuilding", false)

--hooks
hook.Remove("InitPostEntity", "PersistenceInit")
hook.Remove("PersistenceLoad", "PersistenceLoad")
hook.Remove("PersistenceSave", "PersistenceSave")
hook.Remove("ShutDown", "SavePersistenceOnShutdown")

--finish off with the rest of the scripts
include("loader.lua")