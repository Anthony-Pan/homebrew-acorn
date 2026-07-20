cask "acorn" do
  version "1.0.0"
  sha256 "cebe7dce18d23a45e5157c7cc35f11f67bedc905931e4ffbbf116d1250f2521a"

  url "https://github.com/Anthony-Pan/acorn/releases/download/v#{version}/Acorn_#{version}_universal.dmg",
      verified: "github.com/Anthony-Pan/acorn/"
  name "Acorn"
  desc "Warm AI desktop companion that turns a messy day into focused task cards"
  homepage "https://github.com/Anthony-Pan/acorn"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates false
  depends_on macos: ">= :big_sur"

  app "Acorn.app"

  postflight do
    set_permissions "#{appdir}/Acorn.app", "0755"
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Acorn.app"],
                   sudo: false
  end

  uninstall quit: "app.acorn.desktop"

  zap trash: [
    "~/Library/Application Support/app.acorn.desktop",
    "~/Library/Caches/app.acorn.desktop",
    "~/Library/HTTPStorages/app.acorn.desktop",
    "~/Library/Logs/Acorn",
    "~/Library/Preferences/app.acorn.desktop.plist",
    "~/Library/Saved Application State/app.acorn.desktop.savedState",
    "~/Library/WebKit/app.acorn.desktop",
  ]

  caveats <<~EOS
    Acorn #{version} is distributed without Apple code signing or
    notarisation (codesign + notarise is on the v1.1 roadmap). This
    cask therefore strips the quarantine flag from the installed
    bundle so Gatekeeper does not block the first launch.

    API keys are stored in the macOS Keychain under the service
    name "app.acorn.desktop". The SQLite database lives at
    ~/Library/Application Support/app.acorn.desktop/acorn.db.

    Run `brew uninstall --cask --zap acorn` to remove the app and
    all of its local data. The Keychain entries must be cleared by
    hand from Keychain Access (search for "app.acorn.desktop").
  EOS
end
