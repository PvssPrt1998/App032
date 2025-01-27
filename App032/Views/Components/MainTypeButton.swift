import SwiftUI

struct MainTypeButton: View {
    
    let text: String
    let disabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(disabled ? 0.6 : 1))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.c242424)
                .clipShape(.rect(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.orange, lineWidth: 2)
                )
        }
        .disabled(disabled)
    }
}

#Preview {
    MainTypeButton(text: "Continue", disabled: true, action: {})
}
