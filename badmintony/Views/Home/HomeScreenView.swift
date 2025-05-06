import SwiftUI

struct HomeScreenView: View {
    @State private var showAnalysisDashboard = false
    @State private var navigateToSelectShotType = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("歡迎回來，選手")
                        .font(.system(size: 32, weight: .bold))
                    Text("準備好提升您的羽球技術了嗎？")
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                }
                .padding(.top, 48)
                .padding(.horizontal, 24)

                Spacer()

                VStack(spacing: 16) {
                    Button(action: {
                        navigateToSelectShotType = true
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("開始分析")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            Text("上傳或錄製視頻進行姿勢分析")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 82)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }

                    Button(action: {
                        showAnalysisDashboard = true
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("進步軌跡")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                            Text("查看過往分析記錄和進步軌跡")
                                .font(.system(size: 15))
                                .foregroundColor(.black.opacity(0.6))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 82)
                        .background(Color(white: 0.95))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationDestination(isPresented: $navigateToSelectShotType) {
                SelectShotTypeView()
            }
            .navigationDestination(isPresented: $showAnalysisDashboard) {
                AnalysisDashboardView()
            }
        }
    }
}
