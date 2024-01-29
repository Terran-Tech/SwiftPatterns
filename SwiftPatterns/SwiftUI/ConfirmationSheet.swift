import SwiftUI

struct ConfirmationSheetExampleView: View {
    @State private var isShowingSheet = false
    var body: some View {
        VStack {
            Button("Credits") {
                isShowingSheet = true
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            ConfirmationSheet(isPresented: $isShowingSheet)
        }
        .padding()
    }
}

struct ConfirmationSheet: View {
    @Binding var isPresented: Bool

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Form {
                    LabeledContent("Options") {
                        VStack(alignment: .leading) {
                            Button("Do something") {}
                            Button("Do another thing") {}
                        }
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "Done")) {
                    isPresented = false
                }
            }
        }
        .padding()
        .frame(minHeight: 100, alignment: .topLeading)
    }
}

#Preview {
    ConfirmationSheetExampleView()
}
