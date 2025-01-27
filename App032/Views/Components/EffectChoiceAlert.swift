import SwiftUI

struct EffectChoiceAlert: View {
    
    let galleryAction: () -> Void
    let action: () -> Void
    let cancel: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("Select the following action")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text("To create a video, you need to add an image")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(EdgeInsets(top: 19, leading: 16, bottom: 15, trailing: 16))
                
                Rectangle()
                    .fill(Color.c848488.opacity(0.65))
                    .frame(height: 0.33)
                VStack(spacing: 0) {
                    Button {
                        galleryAction()
                    } label: {
                        Text("Select from gallery")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: 44)
                    Rectangle()
                        .fill(Color.c848488.opacity(0.65))
                        .frame(height: 0.33)
                    Button {
                        action()
                    } label: {
                        Text("Take a photo")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: 44)
                    Rectangle()
                        .fill(Color.c848488.opacity(0.65))
                        .frame(height: 0.33)
                    Button {
                        cancel()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: 44)
                }
            }
            .frame(width: 270)
            .background(Color.c393939)
            .clipShape(.rect(cornerRadius: 14))
        }
    }
}

#Preview {
    EffectChoiceAlert(galleryAction: {}, action: {}, cancel: {})
}
