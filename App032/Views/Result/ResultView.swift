import SwiftUI
import UIKit

import Photos
import AVKit

struct ResultView: View {
    @EnvironmentObject var source: Source
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var player = AVPlayer()
    @State var isLoading: Bool = true
    
    @State var showPlayButton = true
    
    @State var showAlert = false
    @State var showSavedToGalleryAlert = false
    @State var notSavedToGalleryAlert = false
    
    @State var showMenu = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.c393939, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showMenu = false
                    }
                }
            Color.black
                .frame(height: safeAreaInsets.top)
                .frame(maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showMenu = false
                    }
                }
            
            VStack(spacing: 0) {
                header
                    .background(Color.black)
                
                if isLoading {
                    loading
                } else {
                    content
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            if showMenu {
                MenuView {
                    shareVideo()
                    withAnimation {
                        showMenu = false
                    }
                } saveToFiles: {
                    
                } delete: {
                    source.removeVideo(source.currentVideoId)
                    withAnimation {
                        showMenu = false
                    }
                }
                .padding(EdgeInsets(top: 50, leading: 16, bottom: 0, trailing: 16))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            }
            
            if showAlert {
                GenerationAlertView(title: "Video generation error", description: "Something went wrong or the server is\nnot responding. Try again or do it later.") {
                    withAnimation {
                        showAlert = false
                    }
                    self.presentationMode.wrappedValue.dismiss()
                } action: {
                    if source.isEffect {
                        generateByImage()
                    } else {
                        generate()
                    }
                    withAnimation {
                        showAlert = false
                    }
                }
            }
            if showSavedToGalleryAlert {
                SavedToAlert(title: "Video saved to gallery") {
                    withAnimation {
                        showSavedToGalleryAlert = false
                    }
                }
            }
            if notSavedToGalleryAlert {
                GenerationAlertView(title: "Error, video not saved to gallery", description: "Something went wrong or the server is not responding. Try again or do it later.") {
                    withAnimation {
                        notSavedToGalleryAlert = false
                    }
                } action: {
                    saveToGallery()
                    withAnimation {
                        notSavedToGalleryAlert = false
                    }
                }

            }
        }
        .onAppear {
            if !source.onAppearRequested {
                source.onAppearRequested = true
                if source.isEffect {
                    generateByImage()
                } else {
                    generate()
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    func closeAlerts() {
        showAlert = false
        showSavedToGalleryAlert = false
        notSavedToGalleryAlert = false
    }
    
    func shareVideo() {
        guard let urlShare = source.localUrl  else { return }
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
    
    func generateByImage() {
        source.generateEffect(userId: UIDevice.current.identifierForVendor?.uuidString ?? "User \(UUID().uuidString)", appId: "com.davpi.kaeffrap") { id in
            isImageGenerationFinished(id: id)
        } errorHandler: {
            withAnimation {
                showAlert = true
            }
        }
        //source.getEffectURLById(id: "df272baf-c75c-4584-a60b-8d87b15bfeaf")
    }
    
    func generate() {
        source.textToVideo(text: source.promt) {
            showAlert = true
        } completion: { id in
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                isGenerationFinished(id: id)
            }
        }
    }
    
    private func isImageGenerationFinished(id: String) {
        source.getEffectURLById(id: id) { url, isDone in
            if isDone && url != nil {
                source.saveUrl(id: id, url: url!.absoluteString)
                source.currentVideoId = id
                isLoading = false
                player = AVPlayer(url: url!)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + (source.proSubscription ? 30 : 45)) {
                    isImageGenerationFinished(id: id)
                }
            }
        } errorHandler: {
            showAlert = true
        }
    }
    
    private func isGenerationFinished(id: String) {
        source.isGenerationFinished(id: id) { isFinished in
            if isFinished {
                source.videoById(id: id) { url in
                    source.saveUrl(id: id, url: url.absoluteString)
                    source.currentVideoId = id
                    isLoading = false
                    player = AVPlayer(url: url)
                } errorHandler: {
                    showAlert = true
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + (source.proSubscription ? 30 : 45)) {
                    isGenerationFinished(id: id)
                }
            }
        } errorHandler: {
            showAlert = true
        }
    }
    
    private var loading: some View {
        VStack(spacing: 6) {
            Text("Video Generation...")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text("Generation usually takes about a minute. You\ncan go back, the generation will go in\n“History” ")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxHeight: .infinity)
    }
    
    @ViewBuilder private var content: some View {
        VStack(spacing: 12) {
            VideoPlayer(player: player)
                .frame(height: (UIScreen.main.bounds.width - CGFloat(64)) / 16 * 9 , alignment: .center)
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
                            player.play()
                        }
                        .opacity(showPlayButton ? 1 : 0)
                )
                .padding(.top, 100)
                .padding(.horizontal, 32)
            
            MainTypeButton(text: "Save", disabled: false) {
                saveToGallery()
            }
            .padding(.horizontal, 32)
        }
    }
    
    private func saveToGallery() {
        if let url = source.localUrl {
            source.saveVideoToAlbum(videoURL: url, albumName: "Generated videos") {
                withAnimation {
                    notSavedToGalleryAlert = true
                }
            } completion: {
                withAnimation {
                    showSavedToGalleryAlert = true
                }
            }

        } else {
            withAnimation {
                notSavedToGalleryAlert = true
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
                
                HStack(spacing: 16) {
                    Image("proButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 32)
                        .opacity(source.proSubscription ? 1 : 0)
//                    Button {
//                        if !showMenu {
//                            withAnimation {
//                                showMenu = true
//                            }
//                        } else {
//                            withAnimation {
//                                showMenu = false
//                            }
//                        }
//                        
//                    } label: {
//                        Image(systemName: "ellipsis")
//                            .font(.system(size: 17, weight: .regular))
//                            .foregroundColor(.white)
//                            .frame(width: 32, height: 32)
//                    }
                }
            }
            .overlay(
                Text("Result")
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
}

#Preview {
    ResultView()
        .environmentObject(Source())
}
