local englishApps = {
	  "Emacs",
	  "emacs",
	  "Terminal",
	  "iTerm2",
	  "kitty"
}

local appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        -- リスト内をループしてチェック
        for _, name in ipairs(englishApps) do
            if (appName == name) then
                -- 一致したら英字レイアウトに切り替え
                hs.keycodes.setLayout("ABC")
                break -- 一致したのでループを抜ける
            end
        end
    end
end)

appWatcher:start()
