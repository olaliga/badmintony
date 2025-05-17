import SwiftUI

struct UploadRecordView: View {
    @Environment(\.dismiss) private var dismiss
    let selectedShotType: String
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showFilePicker = false
    @State private var selectedVideoURL: URL? = nil
    @State private var showPreview = false
    @State private var showAnalysis = false
    @State private var isAnalyzing = false
    @State private var analysisResult: AnalysisResult?
    @State private var showError = false
    @State private var errorMessage = ""
    @Binding var navigationPath: NavigationPath
    
    var guideText: String {
        switch selectedShotType {
        case "發球":
            return "• 建議正面拍攝\n• 確保發球動作全入鏡\n• 保持手機穩定"
        case "高遠球":
            return "• 建議側面拍攝\n• 確保全身入鏡\n• 保持手機穩定"
        case "殺球":
            return "• 建議側後方拍攝\n• 捕捉擊球瞬間\n• 保持手機穩定"
        case "平球":
            return "• 建議側面或正面拍攝\n• 確保擊球路徑清楚\n• 保持手機穩定"
        default:
            return "• 選擇光線充足的場地\n• 確保全身入鏡\n• 保持手機穩定\n• 建議使用側面視角拍攝"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 導覽列
            HStack {
                Spacer()
                Text("上傳/錄製")
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
            }
            .padding(.top, 8)
            .padding(.horizontal)

            Text("選擇影片來源")
                .font(.system(size: 32, weight: .bold))
                .padding(.horizontal)

            Text("選擇錄製新影片或從相簿中上傳")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .padding(.horizontal)

            // 選項按鈕
            VStack(spacing: 16) {
                Button(action: {
                    showCamera = true
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("錄製新影片")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        Text("使用相機錄製您的擊球動作")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 82)
                    .background(Color.blue)
                    .cornerRadius(12)
                }

                Button(action: {
                    showImagePicker = true
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("從相簿選擇")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        Text("從相簿中選擇已有的影片")
                            .font(.system(size: 15))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 82)
                    .background(Color(white: 0.95))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)

            // 拍攝指南
            VStack(alignment: .leading, spacing: 8) {
                Text("拍攝指南")
                    .font(.system(size: 17, weight: .semibold))
                Text(guideText)
                    .font(.system(size: 15))
                    .foregroundColor(.black.opacity(0.8))
            }
            .padding()
            .background(Color(white: 0.98))
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(false)
        .fullScreenCover(isPresented: $showCamera) {
            CameraScreenView(
                navigationPath: $navigationPath,
                selectedShotType: selectedShotType
            )
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedVideoURL: $selectedVideoURL, sourceType: .photoLibrary)
        }
        .onChange(of: selectedVideoURL) { oldValue, newValue in
            if newValue != nil {
                showPreview = true
            }
        }
        .navigationDestination(isPresented: $showPreview) {
            if let url = selectedVideoURL {
                PreviewScreenView(
                    videoURL: url,
                    selectedShotType: selectedShotType,
                    isFromCamera: false,
                    navigationPath: $navigationPath
                )
            }
        }
        .sheet(isPresented: $showFilePicker) {
            DocumentPicker(selectedVideoURL: $selectedVideoURL)
        }
        .navigationDestination(isPresented: $showAnalysis) {
            if let result = analysisResult {
                AnalysisResultView(
                    overallScore: result.score,
                    analysisText: result.analysisText,
                    navigationPath: $navigationPath,
                    isFromCamera: false,
                    onDismiss: {}
                )
            }
        }
        .alert("錯誤", isPresented: $showError) {
            Button("確定", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    UploadRecordView(selectedShotType: "發球", navigationPath: .constant(NavigationPath()))
}
