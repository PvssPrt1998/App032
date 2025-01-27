import SwiftUI

struct Splash: View {
    
    @EnvironmentObject var source: Source
    @Binding var screen: Screen
    
    var body: some View {
        
        Image("SplashImage")
            .resizable()
            .ignoresSafeArea()
            .onAppear {
                source.load { loaded in
                    if loaded {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                            if !source.hasActiveSubscription() || firstLaunch {
//                                firstLaunch = false
//                                screen = .onboarding
//                            } else {
//                                screen = .main
//                            }
                            screen = .onboarding
                        }
                    }
                    
                }
            }
    }
}

struct Splash_Preview: PreviewProvider {
    
    @State static var screen: Screen = .splash
    
    static var previews: some View {
        Splash(screen: $screen)
            .environmentObject(Source())
    }
    
}
