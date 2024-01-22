import SwiftUI

struct AlertsView: View {
    @State var isShowingBasicAlert = false
    @State var isShowingAlertWithCustomIcon = false
    @State var isShowingAlertWithCustomButtons = false

    var body: some View {
        VStack {
            Button("Basic alert") {
                isShowingBasicAlert.toggle()
            }.alert("Alert title", isPresented: $isShowingBasicAlert) {
                Text("Hello basic alert!")
            }

            Button("Alert with custom icon") {
                isShowingAlertWithCustomIcon.toggle()
            }.alert("Alert with custom icon", isPresented: $isShowingAlertWithCustomIcon) {
                Text("Hello custom icon")
            }
            .dialogIcon(Image(systemName: "heart.fill"))

            Button("Alert with custom buttons") {
                isShowingAlertWithCustomButtons.toggle()
            }.alert("Alert with custom buttons", isPresented: $isShowingAlertWithCustomButtons) {
                Button("Button 1") {}
                Button("Done") {}
            } message: {
                Text("Alert text goes here.")
            }

        }
    }
}
