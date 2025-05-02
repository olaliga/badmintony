import SwiftUI

struct Onboarding1View: View {
    var body: some View {
        VStack {
            // 顶部内容
            VStack(spacing: 8) {
                Text("歡迎使用 Badmintony")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                Text("通過分析影片提升您的羽毛球技術")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
            }
            .padding(.top, 48)
            .padding(.horizontal, 24)

            Spacer()

            // 插图区域（可替换为 Image("onboarding1_illustration")）
            Rectangle()
                .fill(Color(white: 0.98))
                .frame(maxWidth: .infinity, maxHeight: 300)
                .overlay(Text("插圖區域").foregroundColor(.gray))
                .padding(.horizontal, 24)

            Spacer()

            // 底部按钮
            Button(action: {
                // TODO: 跳转到下一个页面
            }) {
                Text("開始使用")
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

struct Onboarding1View_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding1View()
    }
}