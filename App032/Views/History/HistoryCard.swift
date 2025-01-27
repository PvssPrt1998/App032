import SwiftUI
import AVKit

struct HistoryCard: View {
    
    @State var url: String?
    @State var showPlayButton = true
    
    var body: some View {
        if let urlStr = url, let url1 = URL(string: urlStr)  {
            VideoPlayer(player: AVPlayer(url: url1))
                .frame(height: 172, alignment: .center)
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    Image(systemName: "play.fill")
                        .font(.system(size: 34, weight: .regular))
                        .foregroundColor(.white)
                        .frame(width: 76, height: 76)
                        .background(Color.c393939.opacity(0.55))
                        .clipShape(.circle)
                        .onTapGesture {
                            showPlayButton = false
                        }
                        .opacity(0)
                )
                .background(Color.black)
                .clipShape(.rect(cornerRadius: 20))
                .padding(.horizontal, 16)
        } else {
            ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            .frame(maxWidth: .infinity)
            .frame(height: 172)
            .overlay(
                Text("Generation usually takes about a minute")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .italic()
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                ,alignment: .bottom
            )
            .background(Color.white.opacity(0.2))
            .clipShape(.rect(cornerRadius: 20))
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    HistoryCard(url: "https://google.com")
        .environmentObject(Source())
}
