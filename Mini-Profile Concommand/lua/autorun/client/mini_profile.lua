-- mini_profile.lua by Bonyoze

local frame

local function openMiniProfile(id)
  if frame then frame:Remove() end

  local function steamIDTo3(steamid)
    local args = string.Split(steamid, ":")
    local y = tonumber(args[2])
    local z = tonumber(args[3])

    return z * 2 + y
  end

  local function setupFrame(data)
    -- create dframe
    frame = vgui.Create("DFrame")
    frame:SetVisible(false)
    frame:SetScreenLock(true)
    frame:DockPadding(0, 0, 0, 0)
    frame:MakePopup()

    frame.btnMaxim:SetVisible(false)
    frame.btnMinim:SetVisible(false)

    frame.Paint = function(self, w, h)
      draw.RoundedBox(0, 0, 0, w, h, color_black)
    end

    frame.OnClose = function(self)
      self:Remove()
    end
      
    -- create dhtml
    local html = vgui.Create("DHTML", frame)
    html:SetPos(0, 25)

    html:AddFunction("miniprofile", "init", function(name, w, h) -- setup frame after html loaded
      frame:SetPos(ScrW() / 2 - w / 2, ScrH() / 2 - h / 2)
      frame:SetSize(w, h + 25)
      frame:SetTitle(name .. "'s Mini Profile")
      html:SetSize(w, h)
      frame:SetVisible(true)
    end)

    html:AddFunction("miniprofile", "cancel", function(name, w, h) -- html has invalid data (probably from using a non-existing steam acc)
      frame:Remove()
      MsgN("Failed to open mini profile (invalid steam account)")
    end)

    -- setup mini profile html
    html:SetHTML([[
      <head>
        <link href="https://community.cloudflare.steamstatic.com/public/shared/css/shared_global.css" rel="stylesheet" type="text/css">
        <script src="asset://garrysmod/html/js/thirdparty/jquery.js" type="text/javascript"></script>

        <style>
          * {
            -webkit-user-select: none;
            user-select: none;
          }

          body {
            margin: 0;
          }
        </style>
      </head>
      <body>
        <script type="text/javascript">
          $("body").append($.parseHTML("]] .. string.JavascriptSafe(data) .. [["));

          var persona = $("body > .miniprofile_container > .miniprofile_playersection > .player_content > .persona").text();
          if (persona) {
            miniprofile.init(
              persona,
              $("body > .miniprofile_container").width(),
              $("body > .miniprofile_container").height()
            );
          } else {
            miniprofile.cancel();
          }
        </script>
      </body>
    ]])
  end

  -- get mini profile data
  http.Fetch(
    string.format("https://steamcommunity.com/miniprofile/%u.html", steamIDTo3(id)),
    function(body, len, headers, code)
      if code == 200 then
        setupFrame(body)
      else
        MsgN("Failed to open mini profile (" .. code .. ")")
      end
    end,
    function(err)
      MsgN("Failed to open mini profile (" .. err .. ")")
    end
  )
end

concommand.Add("show_mini_profile", function(ply, cmd, args, argStr)
  if ply:IsValid() then openMiniProfile(argStr != "" and argStr or ply:SteamID()) end
end)
