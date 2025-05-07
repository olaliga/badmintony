import SwiftUI

struct AnalysisDashboardView: View {
    // @Environment(\.dismiss) private var dismiss // 不再需要
    // 篩選條件
    @State private var selectedTime: String = "本周"
    @State private var selectedShotType: String = "全部"
    
    // 範例資料
    let timeOptions = ["本周", "本月", "本季", "自定義時間"]
    let shotTypeOptions = ["全部", "發球", "高遠球", "扣球", "平球"]
    struct Record: Identifiable {
        let id = UUID()
        let date: String
        let duration: String
        let shots: String
        let shotType: String
        let score: String
    }
    let records: [Record] = [
        .init(date: "2024年5月1日 14:30", duration: "15分鐘", shots: "32次", shotType: "高遠球", score: "92"),
        // ...更多資料
    ]
    
    var filteredRecords: [Record] {
        records.filter { record in
            (selectedShotType == "全部" || record.shotType == selectedShotType)
            // 時間篩選可根據實際需求進一步實作
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 導覽列
                HStack {
                    Spacer()
                    Text("訓練分析")
                        .font(.system(size: 17, weight: .semibold))
                    Spacer()
                }
                .padding()
                .background(Color.white)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // 時間篩選
                        HStack(spacing: 12) {
                            ForEach(timeOptions, id: \.self) { option in
                                Button(action: { selectedTime = option }) {
                                    Text(option)
                                        .font(.system(size: 14))
                                        .foregroundColor(selectedTime == option ? .white : .gray)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 12)
                                        .background(selectedTime == option ? Color.blue : Color(white: 0.95))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // 球種篩選
                        HStack(spacing: 12) {
                            ForEach(shotTypeOptions, id: \.self) { option in
                                Button(action: { selectedShotType = option }) {
                                    Text(option)
                                        .font(.system(size: 14))
                                        .foregroundColor(selectedShotType == option ? .white : .gray)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 12)
                                        .background(selectedShotType == option ? Color.blue : Color(white: 0.95))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // 進步趨勢區塊
                        VStack(alignment: .leading, spacing: 8) {
                            Text("進步趨勢")
                                .font(.system(size: 16, weight: .semibold))
                            Rectangle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(height: 120)
                                .overlay(Text("趨勢圖表區（可用 Swift Charts）").foregroundColor(.blue))
                                .cornerRadius(12)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        // 分析紀錄列表
                        VStack(alignment: .leading, spacing: 8) {
                            Text("分析紀錄")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.horizontal)
                            
                            ForEach(filteredRecords) { record in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(record.date)
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        HStack {
                                            Text("訓練時長")
                                                .font(.system(size: 14))
                                            Text(record.duration)
                                                .font(.system(size: 14))
                                            Text("擊球次數")
                                                .font(.system(size: 14))
                                            Text(record.shots)
                                                .font(.system(size: 14))
                                        }
                                        HStack {
                                            Text("球種")
                                                .font(.system(size: 14))
                                            Text(record.shotType)
                                                .font(.system(size: 14))
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    Spacer()
                                    VStack {
                                        Text(record.score)
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.blue)
                                        Text("分")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color(white: 0.98))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .background(Color(white: 0.98))
            }
            .background(Color(white: 0.98))
        }
    }
}

func getAnalysisScore(videoPath: String, shotType: String, completion: @escaping (Int?) -> Void) {
    DispatchQueue.global().async {
        let process = Process()
        let pipe = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/python3")
        process.arguments = ["badmintony/python_utils/analysis_score.py", videoPath, shotType]
        process.standardOutput = pipe

        do {
            try process.run()
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                // 解析分數
                if let scoreLine = output.split(separator: "\n").last,
                   let score = Int(scoreLine.replacingOccurrences(of: "分析分數: ", with: "")) {
                    DispatchQueue.main.async {
                        completion(score)
                    }
                    return
                }
            }
        } catch {
            print("執行 python 失敗: \(error)")
        }
        DispatchQueue.main.async {
            completion(nil)
        }
    }
}
