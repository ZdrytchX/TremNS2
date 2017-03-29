--mod panel information
if AddModPanel then
  local tremns2_info = PrecacheAsset("materials/TremNS2/tremns2_info.material", "http://steamcommunity.com/sharedfiles/filedetails/?id=808128703")
  local tremns2_info = PrecacheAsset("materials/TremNS2/tremns2_fade.material", "https://sites.google.com/site/zdrytchx/home/ns2-motd")
  local tremns2_info = PrecacheAsset("materials/TremNS2/tremns2_speedo.material")

  AddModPanel(tremns2_info, "http://steamcommunity.com/sharedfiles/filedetails/?id=808128703")
  AddModPanel(tremns2_fade, "https://sites.google.com/site/zdrytchx/home/ns2-motd")
  AddModPanel(tremns2_speedo)
end
