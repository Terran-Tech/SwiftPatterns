import SwiftUI

/**
 Overrides the "About app" command in the menu bar and allows overriding keys on that panel.  Probably only interesting
 overriding credits, since copyright can be adjusted directly on the app Info.plist (key "Copyright (human-readable)").

 To use this use something like:

     WindowGroup {
         ContentView()
     }
     .commands {
         AboutCommand()
     }

 Source: https://nilcoalescing.com/blog/CustomiseAboutPanelOnMacOSInSwiftUI/
 */

struct AboutCommand: Commands {
    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button("About My App") {
                NSApplication.shared.orderFrontStandardAboutPanel(
                    options: [
                        NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                            string: "Credit where it's due!",
                            attributes: [
                                NSAttributedString.Key.font: NSFont.boldSystemFont(
                                    ofSize: NSFont.smallSystemFontSize)
                            ]
                        ),
                        NSApplication.AboutPanelOptionKey(
                            rawValue: "Copyright"
                        ): "© 2024 Foo Bar"
                    ]
                )
            }
        }
    }
}
