import SwiftUI

struct Onboarding2View: View {
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
                .overlay(Text("插图区域").foregroundColor(.gray))
                .padding(.horizontal, 24)

            Spacer()

            Button(action: {
                // 跳转逻辑
            }) {
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

struct Onboarding2View_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding2View()
    }
}
