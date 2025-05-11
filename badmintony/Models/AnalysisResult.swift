import Foundation

struct AnalysisResult: Identifiable {
    let id = UUID()
    let score: Int
    let analysisText: String
    let timestamp: Date
    
    init(score: Int, analysisText: String, timestamp: Date = Date()) {
        self.score = score
        self.analysisText = analysisText
        self.timestamp = timestamp
    }
} 