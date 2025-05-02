import SwiftUI

struct Onboarding3View: View {
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("全方位训练分析")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                Text("多维度数据分析，配合时间与球种筛选，\n帮助您清晰掌握每次训练的进步")
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
                .overlay(Text("插图区域").foregroundColor(.gray))
                .padding(.horizontal, 24)

            Spacer()

            Button(action: {
                // 跳转逻辑
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
    }
}

struct Onboarding3View_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding3View()
    }
}
