import SwiftUI

struct BlurGradientBackground: View {
    var body: some View {
        VStack {
            Text("Hello gradient!")
        }
        .frame(width: 300, height: 300)
        .background {
            ZStack {
                VStack {
                    let colors = [Color.purple, Color.white, Color.orange]
                    AngularGradient(colors: colors, center: .top, angle: .degrees(90))
                        .frame(height: 300)
                        .blur(radius: 80)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    BlurGradientBackground()
}
