import SwiftUI

struct HeaderView: View {
    
    @EnvironmentObject var source: Source
    let text: String
    let hasProSubscription: Bool
    @Binding var isSubscription: Bool
    let settingsAction: () -> Void
   
    
    var body: some View {
        VStack(spacing: 7) {
            HStack {
                Text(text)
                    .font(.system(size: 28, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 16) {
                    Image("proButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 32)
                        .opacity(source.proSubscription ? 1 : 0)
                    
                    NavigationLink {
                        SettingsView(isSubscription: $isSubscription)
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 17,weight: .regular))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .padding(EdgeInsets(top: 3, leading: 16, bottom: 3, trailing: 16))
            
            Rectangle()
                .fill(Color.mainColorYellow)
                .frame(height: 1)
        }
        .padding(.top, 15)
    }
}

//#Preview {
//    HeaderView(text: "Create video", hasProSubscription: true, settingsAction: {})
//        .padding()
//        .background(Color.black)
//        .environmentObject(Source())
//}
