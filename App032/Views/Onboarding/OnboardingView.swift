import SwiftUI
import StoreKit

struct OnboardingView: View {
    
    @EnvironmentObject var source: Source
    @Binding var screen: Screen
    @State var selection = 0
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        TabView(selection: $selection) {
            onboardingView1("onboarding1").tag(0).gesture(DragGesture())
            onboardingView1("onboarding2").tag(1).gesture(DragGesture())
            onboardingView1("onboarding3").tag(2).gesture(DragGesture())
            onboardingView1("onboarding4").tag(3).gesture(DragGesture())
            onboardingView1("onboarding5")
                .overlay(
                    Image("NotificationExample")
                        .resizable()
                        .scaledToFit()
                        .padding(EdgeInsets(top: 0, leading: 12, bottom: 200, trailing: 12))
                )
                .tag(4).gesture(DragGesture())
        }
        .tabViewStyle(.page)
        .ignoresSafeArea()
    }
    
    private func onboardingView1(_ image: String) -> some View {
        Image(image)
            .resizable()
            .overlay(
                Text(textBySelection)
                    .font(.system(size: 34, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: safeAreaInsets.top + 40, leading: 16, bottom: 16, trailing: 16))
                ,alignment: .top
            )
            .overlay(
                Image("onboardingGradient")
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        MainTypeButton(text: "Continue", disabled: false) {
                            if selection < 4 {
                                if selection == 2 {
                                    rate()
                                }
                                withAnimation {
                                    selection += 1
                                }
                            } else {
                                screen = .main
                            }
                        }
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
                    )
                ,alignment: .bottom
            )
            .ignoresSafeArea()
    }
    
    private var textBySelection: String {
        switch selection {
        case 0:
            return "Video effects for all tastes"
        case 1:
            return "Just insert a photo and enjoy the result!"
        case 2:
            return "Turn words into art with AI app"
        case 3:
            return "Share your feedback about this app"
        case 4:
            return ""
        default:
            return "Error"
        }
    }
    
    private func rate() {
        if #available(iOS 18, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                DispatchQueue.main.async {
                    AppStore.requestReview(in: scene)
                }
            }
        } else {
            SKStoreReviewController.requestReviewInCurrentScene()
        }
    }
}

struct OnboardingView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .splash
    
    static var previews: some View {
        OnboardingView(screen: $screen)
            .environmentObject(Source())
    }
    
}

