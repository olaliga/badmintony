import SwiftUI

struct SelectShotTypeView: View {
    @Binding var navigationPath: NavigationPath
    @State private var selectedShotType: String? = nil
    
    let shotTypes = [
        ("發球", "Serve", "發球是比賽的開始，也是得分的重要手段。正確的發球姿勢可以幫助你控制比賽節奏。"),
        ("高遠球", "Clear", "高遠球是防守反擊的重要技術，可以為自己爭取時間和空間。"),
        ("殺球", "Smash", "殺球是進攻的主要手段，需要良好的時機判斷和力量控制。"),
        ("平球", "Drive", "平抽是快速對攻的技術，需要良好的反應和控球能力。")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 標題
            Text("選擇球種")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 24)
                .padding(.horizontal)
            
            Text("請選擇本次要分析的球種")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .padding(.horizontal)

            // 球種選擇
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(shotTypes, id: \.0) { type in
                        NavigationLink(destination: UploadRecordView(selectedShotType: type.0, navigationPath: $navigationPath)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(type.0)
                                        .font(.system(size: 17, weight: .medium))
                                        .foregroundColor(.black)
                                    Text(type.2)
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        SelectShotTypeView(navigationPath: .constant(NavigationPath()))
    }
}
