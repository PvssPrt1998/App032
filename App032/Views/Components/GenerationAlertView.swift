import SwiftUI

struct GenerationAlertView: View {
    
    let title: String
    let description: String
    let cancel: () -> Void
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text(description)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(EdgeInsets(top: 19, leading: 16, bottom: 15, trailing: 16))
                
                Rectangle()
                    .fill(Color.c848488.opacity(0.65))
                    .frame(height: 0.33)
                HStack(spacing: 0) {
                    Button {
                        cancel()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    
                    Rectangle()
                        .fill(Color.c848488.opacity(0.65))
                        .frame(width: 0.33)
                    
                    Button {
                        action()
                    } label: {
                        Text("Try again")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(height: 44)
            }
            .frame(width: 270)
            .background(Color.c393939)
            .clipShape(.rect(cornerRadius: 14))
        }
    }
}

#Preview {
    GenerationAlertView(title: "Video generation error", description: "Something went wrong or the server is\nnot responding. Try again or do it later.", cancel: {}, action: {})
}
