import SwiftUI
import StoreKit
import UserNotifications

struct SettingsView: View {
    
    @EnvironmentObject var source: Source
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.openURL) var openURL
    @State var notificationsOn = false
    
    @Binding var isSubscription: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.c393939, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            Color.black
                .frame(height: safeAreaInsets.top)
                .frame(maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                    .background(Color.black)
                
                content
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    @ViewBuilder private var content: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                purchasesGroup
                actionsGroup
                supportGroup
                infoGroup
            }
            .padding(16)
        }
    }
    
    private var infoGroup: some View {
        VStack(spacing: 4) {
            Text("Info & legal")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.bottom, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
            
//            Button {
//                
//            } label: {
//                HStack(spacing: 4) {
//                    Image(systemName: "envelope")
//                        .font(.system(size: 17, weight: .regular))
//                        .foregroundColor(.mainColorYellow)
//                        .padding(.trailing, 8)
//                        .frame(width: 44)
//                    Text("Contact us")
//                        .font(.system(size: 17, weight: .regular))
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    Image(systemName: "chevron.right")
//                        .font(.system(size: 17, weight: .semibold))
//                        .foregroundColor(.white.opacity(0.4))
//                }
//                .frame(height: 44)
//                .padding(.horizontal, 16)
//                .background(Color.white.opacity(0.08))
//                .clipShape(.rect(cornerRadius: 10))
//            }
            
            Button {
                if let url = URL(string: "https://docs.google.com/document/d/1Tn2R-6tw-KRX0vzx5ZKYyBR6zsWJfC61PkU6fRtw62k/edit?usp=sharing") {
                    openURL(url)
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "shield")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.mainColorYellow)
                        .padding(.trailing, 8)
                        .frame(width: 44)
                    Text("Privacy Policy")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
                .frame(height: 44)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.08))
                .clipShape(.rect(cornerRadius: 10))
            }
            
            Button {
                if let url = URL(string: "https://docs.google.com/document/d/11NhRAwC8wAUr3xt8vyd6Jq_j2Fh-WqHKmH_AFvbgbTo/edit?usp=sharing") {
                    openURL(url)
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.mainColorYellow)
                        .padding(.trailing, 8)
                        .frame(width: 44)
                    Text("Usage Policy")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
                .frame(height: 44)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.08))
                .clipShape(.rect(cornerRadius: 10))
            }
        }
    }
    
    private var supportGroup: some View {
        VStack(spacing: 4) {
            Text("Support us")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.bottom, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                SKStoreReviewController.requestReviewInCurrentScene()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "star")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.mainColorYellow)
                        .padding(.trailing, 8)
                        .frame(width: 44)
                    Text("Rate app")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
                .frame(height: 44)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.08))
                .clipShape(.rect(cornerRadius: 10))
            }
            
            Button {
                actionSheet()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.mainColorYellow)
                        .padding(.trailing, 8)
                        .frame(width: 44)
                    Text("Share with friends")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
                .frame(height: 44)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.08))
                .clipShape(.rect(cornerRadius: 10))
            }
        }
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: "https://apps.apple.com/us/app/pika-pixverse-video-generator/id6740915377")  else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        if #available(iOS 15.0, *) {
            UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController?
            .present(activityVC, animated: true, completion: nil)
        } else {
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
    
    private var actionsGroup: some View {
        VStack(spacing: 4) {
            Text("Actions")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.bottom, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 4) {
                Image(systemName: "bell.badge")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.mainColorYellow)
                    .padding(.trailing, 8)
                    .frame(width: 44)
                Text("Notifications")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Toggle("", isOn: $notificationsOn)
                    .labelsHidden()
                    .onChange(of: notificationsOn) { newValue in
                        if newValue {
                            registerForNotification()
                        }
                    }
            }
            .frame(height: 44)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.08))
            .clipShape(.rect(cornerRadius: 10))
            
            Button {
                source.videoIDs.forEach { video in
                    source.removeVideo(video.id)
                }
                source.videoIDs = []
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "trash")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.mainColorYellow)
                        .padding(.trailing, 8)
                        .frame(width: 44)
                    Text("Clear cache")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
                .frame(height: 44)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.08))
                .clipShape(.rect(cornerRadius: 10))
            }
        }
    }
    
    @ViewBuilder private var purchasesGroup: some View {
        VStack(spacing: 4) {
            Text("Purchases")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.bottom, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                withAnimation {
                    isSubscription = true
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "crown")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.mainColorYellow)
                        .padding(.trailing, 8)
                        .frame(width: 44)
                    Text("Upgrade plan")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
                .frame(height: 44)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.08))
                .clipShape(.rect(cornerRadius: 10))
            }
            
            Button {
                source.restorePurchase { bool in
                    if bool {
                        source.proSubscription = false
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.mainColorYellow)
                        .padding(.trailing, 8)
                        .frame(width: 44)
                    Text("Restore purchases")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
                .frame(height: 44)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.08))
                .clipShape(.rect(cornerRadius: 10))
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: 7) {
            HStack {
                HStack(spacing: 16) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.mainColorYellow)
                        Text("Back")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.white.opacity(0.35))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image("proButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 32)
                    .opacity(source.proSubscription ? 1 : 0)
            }
            .overlay(
                Text("Settings")
                    .font(.system(size: 17, weight: .semibold))
                    .italic()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            )
            .padding(EdgeInsets(top: 3, leading: 16, bottom: 3, trailing: 16))
            
            Rectangle()
                .fill(Color.mainColorYellow)
                .frame(height: 1)
        }
        .padding(.top, 15)
    }
    
    func registerForNotification() {
            //For device token and push notifications.
            UIApplication.shared.registerForRemoteNotifications()
            
            let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
            //        center.delegate = self
            
            center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
                if ((error != nil)) { UIApplication.shared.registerForRemoteNotifications() }
                else {
                    
                }
            })
        }
}
//
//#Preview {
//    SettingsView()
//        .environmentObject(Source())
//}
