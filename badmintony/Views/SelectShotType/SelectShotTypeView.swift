import SwiftUI

struct SelectShotTypeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedShotType: String? = nil
    let shotTypes = [
        ("發球", "Serve", "發球敘述 bla bla bla"),
        ("高遠球", "Clear", "高遠球敘述 bla bla bla"),
        ("殺球", "Smash", "殺球敘述 bla bla bla"),
        ("平球", "Drive", "平球敘述 bla bla bla")
    ]
    @State private var navigateToUploadRecord = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                // 導覽列
                HStack {
                    Spacer()
                    Text("選擇分析球種")
                        .font(.system(size: 17, weight: .semibold))
                    Spacer().frame(width: 60)
                }
                .padding(.top, 8)
                .padding(.horizontal)

                Text("請選擇本次要分析的球種")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                // 球種選擇
                HStack(spacing: 12) {
                    ForEach(shotTypes, id: \.0) { type in
                        Button(action: { selectedShotType = type.0 }) {
                            Text(type.0)
                                .font(.system(size: 15))
                                .foregroundColor(selectedShotType == type.0 ? .white : .blue)
                                .frame(width: 70, height: 36)
                                .background(selectedShotType == type.0 ? Color.blue : Color(white: 0.95))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)

                // 預覽區
                if let selected = selectedShotType,
                   let type = shotTypes.first(where: { $0.0 == selected }) {
                    VStack(spacing: 12) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 220)
                            .overlay(Text("預覽圖片區").foregroundColor(.gray))
                        Text(type.2)
                            .font(.system(size: 13))
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                } else {
                    Spacer().frame(height: 220)
                }

                Spacer()

                // 確認按鈕
                Button(action: {
                    navigateToUploadRecord = true
                }) {
                    Text("確認並進入拍攝或是上傳影片")
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(selectedShotType != nil ? Color.blue : Color.gray)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
                .disabled(selectedShotType == nil)
                .navigationDestination(isPresented: $navigateToUploadRecord) {
                    UploadRecordView()
                }
            }
            .background(Color.white)
        }
    }
}
