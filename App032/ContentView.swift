import SwiftUI

struct ContentView: View {
    
    @State var screen: Screen = .splash
    @State var isSubscription: Bool = false
    
    var body: some View {
        ZStack {
            switch screen {
            case .splash:
                Splash(screen: $screen)
            case .onboarding:
                OnboardingView(screen: $screen)
            case .main:
                Tab(screen: $screen, isSubscription: $isSubscription)
            }
            
            if isSubscription {
                Paywall(isSubscription: $isSubscription)
            }
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(Source())
}
