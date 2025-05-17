import SwiftUI

struct Onboarding3View: View {
    @State private var navigateToHome = false
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("全方位訓練分析")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                Text("多维度數據分析，配合時間羽球種篩選，\n幫助您清晰掌握每次訓練的進步")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 48)
            .padding(.horizontal, 24)

            Spacer()

            Rectangle()
                .fill(Color(white: 0.98))
                .frame(maxWidth: .infinity, maxHeight: 300)
                .overlay(Text("插圖區域").foregroundColor(.gray))
                .padding(.horizontal, 24)

            Spacer()

            Button(action: {
                hasOnboarded = true
                navigateToHome = true
            }) {
                Text("開始分析")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .navigationDestination(isPresented: $navigateToHome) {
            HomeScreenView(navigationPath: $navigationPath)
        }
    }
}

#Preview {
    NavigationStack {
        Onboarding3View(navigationPath: .constant(NavigationPath()))
    }
}
