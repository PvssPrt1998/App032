import SwiftUI

struct ContentView: View {
    
    @State var screen: Screen = .splash
    
    var body: some View {
        switch screen {
        case .splash:
            Splash(screen: $screen)
        case .onboarding:
            OnboardingView(screen: $screen)
        case .main:
            Tab(screen: $screen)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Source())
}
