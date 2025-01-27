import SwiftUI

struct SubscriptionButtons: View {
    
    @EnvironmentObject var source: Source
    @Binding var isYear: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            subscriptionButtonsTextYearly
            subscriptionButtonsTextWeekly
        }
    }
    
    private var subscriptionButtonsTextYearly: some View {
        HStack {
            Text(source.returnName(product: source.productsApphud[0]))
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 6) {
                Text("SAVE 60%")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(4)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 4))
                    .frame(maxHeight: .infinity, alignment: .top)
                VStack(spacing: 2) {
                    Text(source.returnPriceSign(product: source.productsApphud[0]) + source.returnPrice(product: source.productsApphud[0]))
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    Text("per year")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 16))
        .frame(height: 56)
        .background(Color.white.opacity(0.08))
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isYear ? Color.mainColorYellow : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            isYear = true
        }
    }
    
    private var subscriptionButtonsTextWeekly: some View {
        HStack {
            Text(source.returnName(product: source.productsApphud[1]))
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 6) {
                VStack(spacing: 2) {
                    Text(source.returnPriceSign(product: source.productsApphud[1]) + source.returnPrice(product: source.productsApphud[1]))
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    Text("per week")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 16))
        .frame(height: 56)
        .background(Color.white.opacity(0.08))
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(!isYear ? Color.mainColorYellow : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            isYear = false
        }
    }
}
