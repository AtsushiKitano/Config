-- Chrome ブックマーク検索
-- Ctrl+Shift+B で hs.chooser を開き、全プロファイルのブックマークを fuzzy 検索する

local JQ = "/opt/homebrew/bin/jq"

-- Bookmarks JSON を jq で name\turl のリストに変換するクエリ
local JQ_QUERY = [[
  def walk:
    if type == "object" then
      if .type == "url" then
        .name + "\t" + .url
      elif .children then
        .children[] | walk
      else empty end
    elif type == "array" then
      .[] | walk
    else empty end;
  .roots | to_entries[] | .value | walk
]]

local function loadBookmarksFromFile(path)
  local results = {}
  local escaped = path:gsub("'", "'\\''")
  local cmd = string.format("%s -r '%s' '%s' 2>/dev/null", JQ, JQ_QUERY, escaped)
  local output = hs.execute(cmd)
  if not output then return results end

  for line in output:gmatch("[^\n]+") do
    local name, url = line:match("^(.-)\t(.+)$")
    if name and url then
      table.insert(results, {
        text    = name,
        subText = url,
        url     = url,
      })
    end
  end
  return results
end

local function searchChromeBookmarks()
  local base = os.getenv("HOME") .. "/Library/Application Support/Google/Chrome"
  local profiles = {"Default", "Profile 1", "Profile 2", "Profile 3"}
  local choices = {}

  for _, profile in ipairs(profiles) do
    local path = base .. "/" .. profile .. "/Bookmarks"
    if hs.fs.attributes(path) then
      local items = loadBookmarksFromFile(path)
      for _, item in ipairs(items) do
        table.insert(choices, item)
      end
    end
  end

  if #choices == 0 then
    hs.alert.show("ブックマークが見つかりません")
    return
  end

  local chooser = hs.chooser.new(function(choice)
    if choice then
      hs.urlevent.openURLWithBundle(choice.url, "com.google.Chrome")
    end
  end)

  chooser:placeholderText("ブックマークを検索...")
  chooser:choices(choices)
  chooser:show()
end

-- ブックマーク検索: cmd+]
hs.hotkey.bind({"cmd"}, "]", searchChromeBookmarks)

-- Web 検索
local function webSearch()
  local chooser = hs.chooser.new(function(choice)
    if choice and choice.url then
      hs.urlevent.openURL(choice.url)
    end
  end)
  chooser:placeholderText("Web 検索...")
  chooser:choices({})
  chooser:queryChangedCallback(function(query)
    if query and #query > 0 then
      local encoded = hs.http.encodeForQuery(query)
      chooser:choices({{
        text    = query,
        subText = "Google で検索",
        url     = "https://www.google.com/search?q=" .. encoded,
      }})
    else
      chooser:choices({})
    end
  end)
  chooser:show()
end

-- Web 検索: cmd+[
hs.hotkey.bind({"cmd"}, "[", webSearch)

hs.alert.show("Hammerspoon loaded")
