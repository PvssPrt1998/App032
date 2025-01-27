import SwiftUI

struct MenuView: View {
    
    let share: () -> Void
    let saveToFiles: () -> Void
    let delete: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                share()
            } label: {
                HStack {
                    Text("Share")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.2))
            }
            .frame(height: 44)
            .padding(.bottom, 8)
            Rectangle()
                .fill(Color.c848488.opacity(0.65))
                .frame(height: 0.33)
//            Button {
//                saveToFiles()
//            } label: {
//                HStack {
//                    Text("Save to files")
//                        .font(.system(size: 17, weight: .regular))
//                        .foregroundColor(.white)
//                    Image(systemName: "folder.badge.plus")
//                        .font(.system(size: 17, weight: .regular))
//                        .foregroundColor(.white)
//                }
//                .padding(.horizontal, 16)
//                .background(Color.white.opacity(0.2))
//            }
//            .padding(.bottom, 8)
//            
            Button {
                delete()
            } label: {
                HStack {
                    Text("Delete")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.c2556958)
                    Image(systemName: "trash")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.c2556958)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.2))
            }
            .frame(height: 44)
        }
        .frame(width: 250)
        .background(Color.black)
        .clipShape(.rect(cornerRadius: 12))
    }
}

#Preview {
    MenuView(share: {}, saveToFiles: {}, delete: {})
}
