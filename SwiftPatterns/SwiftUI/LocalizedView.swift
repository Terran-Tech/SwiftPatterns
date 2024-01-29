import SwiftUI

/// Once localization is enabled for the app, the following would work automatically:
/// 1. Use LocalizedStringKey on variables that hold strings that should be localized
/// 2. Text(text) and other default UI views typically intake LocalizedStringKey already, so simply write strings directly.
/// 3. Use comment to provide an instruction for the translator.
struct LocalizedView: View {
    var message: LocalizedStringKey = "Beaches you visited in the past 6 months"

    private struct Beach: Identifiable {
        let name: String
        var id: String { name }
    }

    private let beaches = [
        Beach(name: "Source d’Argent, Seychelles"),
        Beach(name: "Dune du Pyla, France"),
        Beach(name: "Shoal Bay, Antigua"),
        Beach(name: "Cala Saona, Formentera"),
        Beach(name: "Glass Beach, California")
    ]

    var body: some View {
        VStack {
            // Automatically localized
            Text("Visited beaches")
                .font(.title)

            // Automatically localized (using correct type)
            Text(message)

            List {
                ForEach(beaches) { beach in
                    // Non-localized
                    Text(beach.name)
                }
            }

            // Automatically localized + comment for translator
            Text("Whenever you visit a new place, make sure to save it from drafts for it to appear here.",
                 comment: "Educational footnote to teach users how to permanently save a beach as visited.")
                .font(.caption)

            // Localized manually by key
            Text(String(localized: "afterFooterMessage"))
        }
        .padding()
    }
}

#Preview {
    LocalizedView()
}
