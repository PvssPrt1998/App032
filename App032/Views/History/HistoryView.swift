import SwiftUI
import AVKit

struct HistoryView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var source: Source
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.c393939, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            Color.black
                .frame(height: safeAreaInsets.top)
                .frame(maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderView(text: "History", hasProSubscription: true) {
                    
                }
                .background(Color.black)
                
                ScrollView(.vertical) {
                    ForEach(source.videoIDs, id: \.self) { video in
                        HistoryCard(url: video.url)
                    }
                    .padding(.vertical, 16)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(Source())
}
