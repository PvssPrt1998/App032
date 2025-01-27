import SwiftUI
import AVKit

struct Paywall: View {
    @Environment(\.openURL) var openURL
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var source: Source
    
    @State var isYear = true
    
    var body: some View {
        ZStack {
            Image("SplashImage")
                .resizable()
                .ignoresSafeArea()
            
            Image("backgroundShadow")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
                .overlay(content)
        }
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                Text("Unlock all!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 2) {
                    HStack(spacing: 2) {
                        Image(systemName: "hare")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.mainColorYellow)
                        Text("Quick generations")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                    }
                    HStack(spacing: 2) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.mainColorYellow)
                        Text("Unlimited saving")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                    }
                    HStack(spacing: 2) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.mainColorYellow)
                        Text("Full Access")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.bottom, 20)
            SubscriptionButtons(isYear: $isYear)
                .padding(.horizontal, 16)
            buttons
            
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    private var buttons: some View {
        VStack(spacing: 2) {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.4))
                Text("Cancel Anytime")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            MainTypeButton(text: "Continue", disabled: false) {
                source.startPurchase(product: isYear ? source.productsApphud[0] : source.productsApphud[1]) { bool in
                    if bool {
                        print("Subscription purchased")
                        source.proSubscription = true
                    }
                }
            }
            .padding(.horizontal, 21)
            legalButtons
        }
    }
    
    private var legalButtons: some View {
        HStack {
            Button {
                if let url = URL(string: "https://docs.google.com/document/d/1Tn2R-6tw-KRX0vzx5ZKYyBR6zsWJfC61PkU6fRtw62k/edit?usp=sharing") {
                    openURL(url)
                }
            } label: {
                Text("Privacy policy")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.4))
            }
            .frame(maxWidth: .infinity)
            Button {
                source.restorePurchase { bool in
                    if bool {
                        source.proSubscription = false
                    }
                }
            } label: {
                Text("Restore Purchases")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            Button {
                if let url = URL(string: "https://docs.google.com/document/d/11NhRAwC8wAUr3xt8vyd6Jq_j2Fh-WqHKmH_AFvbgbTo/edit?usp=sharing") {
                    openURL(url)
                }
            } label: {
                Text("Terms of Use")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.4))
            }
            .frame(maxWidth: .infinity)
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 12, trailing: 16))
    }
}

#Preview {
    Paywall()
        .environmentObject(Source())
}

