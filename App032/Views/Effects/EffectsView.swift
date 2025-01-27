import SwiftUI

struct EffectsView: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var source: Source
    @State var showAlert = false
    @State var showCameraPicker = false
    @State private var showingImagePicker = false
    @State var pushActive = false
    
    @State var inputImage: UIImage?
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.c393939, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .onDisappear {
                    showAlert = false
                }
            Color.black
                .frame(height: safeAreaInsets.top)
                .frame(maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderView(text: "Create a video", hasProSubscription: true) {
                    
                }
                .background(Color.black)
                
                content
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            if showAlert {
                EffectChoiceAlert {
                    showingImagePicker = true
                } action: {
                    showCameraPicker = true
                } cancel: {
                    withAnimation {
                        showAlert = false
                    }
                }
            }
            
            NavigationLink(destination:
               ResultView(),
               isActive: self.$pushActive) {
                 EmptyView()
            }.hidden()
        }
        .fullScreenCover(isPresented: $showCameraPicker) {
            CameraPickerView() { image in
                source.effectImage = image
                if source.effectImage != nil {
                    print("image picked")
                }
            }
        }
        .onTapGesture {
            showingImagePicker = true
        }
        .onChange(of: inputImage) { _ in
            source.effectImage = inputImage
            if source.effectImage != nil {
                source.isEffect = true
                pushActive = true
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
                .ignoresSafeArea()
        }
    }
    
    private var content: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {
                effectCard(text: "Eye-pop it", imageStr: "popEye")
                    .onTapGesture {
                        source.selectedEffect = "Eye-pop it"
                        withAnimation {
                            showAlert = true
                        }
                    }
                effectCard(text: "Explode it", imageStr: "explodeIt")
                    .onTapGesture {
                        source.selectedEffect = "Explode it"
                        withAnimation {
                            showAlert = true
                        }
                    }
                effectCard(text: "Levitate it", imageStr: "levitateIt")
                    .onTapGesture {
                        source.selectedEffect = "Levitate it"
                        withAnimation {
                            showAlert = true
                        }
                    }
            }
            .padding(16)
        }
    }
    
    private func effectCard(text: String, imageStr: String) -> some View {
        VStack(spacing: 16) {
            Text(text)
                .font(.system(size: 28, weight: .bold))
                .italic()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(imageStr)
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    EffectsView()
        .environmentObject(Source())
}
