import SwiftUI

struct Onboarding2View: View {
    @State private var showOnboarding3 = false
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("智能動作捕捉")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                Text("錄製或上傳您的羽球影片，AI自動識別動作")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
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

            NavigationLink(destination: Onboarding3View(navigationPath: $navigationPath)) {
                Text("下一步")
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
    }
}

#Preview {
    NavigationStack {
        Onboarding2View(navigationPath: .constant(NavigationPath()))
    }
}
