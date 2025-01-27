import SwiftUI

struct SavedToAlert: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            VStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 19, leading: 16, bottom: 15, trailing: 16))
                
                Rectangle()
                    .fill(Color.c848488.opacity(0.65))
                    .frame(height: 0.33)
                VStack(spacing: 0) {
                    Button {
                        action()
                    } label: {
                        Text("OK")
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
    SavedToAlert(title: "Title", action: {})
}
