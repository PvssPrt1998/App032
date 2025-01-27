import SwiftUI

struct PromtView: View {
    @EnvironmentObject var source: Source
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State var text = ""
    @State var style: Style = .none
    @State var negativePromtOn = false
    @State var negativePromtText = ""
    
    enum Style {
        case art
        case realism
        case cartoon
        case none
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.c393939, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
            Color.black
                .frame(height: safeAreaInsets.top)
                .frame(maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
            
            VStack(spacing: 0) {
                HeaderView(text: "Create a video", hasProSubscription: true) {
                    
                }
                .background(Color.black)
                
                content
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    private var content: some View {
        VStack(spacing: 24) {
            textFieldSection
            styleSection
            negativeWordsSection
            NavigationLink {
                resultView
            } label: {
                Text("Create")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white.opacity(text == "" ? 0.6 : 1))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.c242424)
                    .clipShape(.rect(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.orange, lineWidth: 2)
                    )
            }
            .disabled(text == "")
        }
        .padding(EdgeInsets(top: 30, leading: 16, bottom: 0, trailing: 16))
    }
    
    private var resultView: some View {
        source.onAppearRequested = false
        source.promt = styleText + text + "."
        if negativePromtText != "" {
            source.promt += " Video should not contain " + negativePromtText
        }
        source.isEffect = false
        return ResultView()
    }
    
    private var styleText: String {
        switch style {
        case .art:
            return "Art style video. "
        case .realism:
            return "Realism style video. "
        case .cartoon:
            return "Cartoon style video. "
        case .none:
            return ""
        }
    }
    
    private var textFieldSection: some View {
        VStack(spacing: 6) {
            Text("Enter Prompt")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            textEditorCustom(text: $text, placeholder: "What do you want to generate?")
                .overlay(
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.white.opacity(0.4))
                            .frame(width: 32, height: 32)
                    }
                    .padding(4)
                    ,alignment: .bottomTrailing
                )
        }
    }
    
    private var negativeWordsSection: some View {
        VStack(spacing: 24) {
            HStack(spacing: 12) {
                Text("Negative Words")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                Text("Optional")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.bgTertiary.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 0) {
                    Text(negativePromtOn ? "Close" : "Open")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.bgTertiary.opacity(0.8))
                    Image(systemName: negativePromtOn ? "chevron.up" : "chevron.down")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.mainColorYellow)
                        .frame(width: 32, height: 32)
                }
                .onTapGesture {
                    withAnimation {
                        negativePromtOn.toggle()
                        if !negativePromtOn {
                            negativePromtText = ""
                        }
                    }
                }
            }
            .frame(height: 32)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
            
            if negativePromtOn {
                textEditorCustom(text: $negativePromtText, placeholder: "Enter negative words")
                    .overlay(
                        Button {
                            negativePromtText = ""
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white.opacity(0.4))
                                .frame(width: 32, height: 32)
                        }
                        .padding(4)
                        ,alignment: .bottomTrailing
                    )
            }
        }
    }
    
    private var styleSection: some View {
        VStack(spacing: 6) {
            Text("Style")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 0) {
                Text("Art")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(width: 72, height: 30)
                    .background(style == .art ? Color.bgTertiary.opacity(0.12) : .clear)
                    .clipShape(.rect(cornerRadius: 6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(style == .art ? Color.mainColorYellow : Color.separatorPrimary.opacity(0.24), lineWidth: 1)
                    )
                    .onTapGesture {
                        style = .art
                    }
                Spacer()
                Text("Realism")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(width: 86, height: 30)
                    .background(style == .realism ? Color.bgTertiary.opacity(0.12) : .clear)
                    .clipShape(.rect(cornerRadius: 6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(style == .realism ? Color.mainColorYellow : Color.separatorPrimary.opacity(0.24), lineWidth: 1)
                    )
                    .onTapGesture {
                        style = .realism
                    }
                Spacer()
                Text("Cartoon")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(width: 89, height: 30)
                    .background(style == .cartoon ? Color.bgTertiary.opacity(0.12) : .clear)
                    .clipShape(.rect(cornerRadius: 6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(style == .cartoon ? Color.mainColorYellow : Color.separatorPrimary.opacity(0.24), lineWidth: 1)
                    )
                    .onTapGesture {
                        style = .cartoon
                    }
                Spacer()
                Text("None")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(width: 72, height: 30)
                    .background(style == .none ? Color.bgTertiary.opacity(0.12) : .clear)
                    .clipShape(.rect(cornerRadius: 6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(style == .none ? Color.mainColorYellow : Color.separatorPrimary.opacity(0.24), lineWidth: 1)
                    )
                    .onTapGesture {
                        style = .none
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder private func textEditorCustom(text: Binding<String>, placeholder: String) -> some View {
        if #available(iOS 16.0, *) {
            TextEditor(text: text)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
                .scrollContentBackground(.hidden)
                .padding(EdgeInsets(top: 15, leading: 12, bottom: 40, trailing: 12))
                .background(
                    placeholderView(isShow: text.wrappedValue == "", text: placeholder)
                )
                .padding(0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.separatorPrimary.opacity(0.24), lineWidth: 0.33)
                )
                .background(Color.bgTertiary.opacity(0.06))
                .clipShape(.rect(cornerRadius: 10))
                .frame(height: 144)
        } else {
            TextEditor(text: $text)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 15, leading: 12, bottom: 40, trailing: 12))
                .background(
                    placeholderView(isShow: text.wrappedValue == "", text: placeholder)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.separatorPrimary.opacity(0.24), lineWidth: 0.33)
                )
                .background(Color.bgTertiary.opacity(0.06))
                .clipShape(.rect(cornerRadius: 10))
                .frame(height: 144)
        }
    }
    
    func placeholderView(isShow: Bool, text: String) -> some View {
        Text(isShow ? text : "")
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(.separatorPrimary.opacity(0.4))
            .padding(EdgeInsets(top: 23, leading: 16, bottom: 15, trailing: 16))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    PromtView()
        .environmentObject(Source())
}
