//
//  NetworkManager.swift
//  MaskCountTest
//
//  Created by 林俊緯 on 2022/7/8.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    // Url
    private let dailyPhraseUrl = "https://tw.feature.appledaily.com/collection/dailyquote"
    private let maskCountUrl = "https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json"
    
    //
    var dailyPhraseInChinese = ""
    var dailyPhraseInEnglish = ""
    var clinicInfo = [ClinicInfo]()
    
    // 獲取每日一句
    func fetchDailyPhrase() {
        // 計算隨機日期
        let randomMonth = Int.random(in: 2...5)
        var randomDay = 0
        var day = ""
        switch randomMonth {
        case 2:
            randomDay = Int.random(in: 7...28)
        case 3:
            randomDay = Int.random(in: 1...31)
        case 4:
            randomDay = Int.random(in: 1...30)
        case 5:
            randomDay = Int.random(in: 1...17)
        default:
            return
        }
        if randomDay < 10 {
            day = "0\(randomDay)"
        } else {
            day = String(randomDay)
        }
        
        // 檢查 url
        guard let url = URL(string: dailyPhraseUrl + "/20210\(randomMonth)\(day)") else { return }
//        guard let url = URL(string: dailyPhraseUrl + "/20210502") else { return }
        
        // 取得英文和中文每日一句
        do {
            let html = try String(contentsOf: url )
            var htmlComponent = html.components(separatedBy: "<p>")
            htmlComponent = htmlComponent[2].components(separatedBy: "</p>")
            htmlComponent = htmlComponent[0].components(separatedBy: "。")
            dailyPhraseInChinese = htmlComponent[0] + "。"
            dailyPhraseInEnglish = htmlComponent[1]
            if dailyPhraseInEnglish.contains("<br />") {
                if let i = dailyPhraseInEnglish.firstIndex(of: "<"), let j = dailyPhraseInEnglish.lastIndex(of: ">") {
                    dailyPhraseInEnglish.removeSubrange(i...j)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 獲取診所資訊和口罩數量
    func fetchMaskCount(_ compeltion: @escaping ([ClinicInfo]) -> Void ) {
        URLSession.shared.dataTask(with: URL(string: maskCountUrl)!) { data, response, error in
            guard error == nil else { return }
            do {
                let data = try JSONDecoder().decode(MaskCount.self, from: data ?? Data())
                data.features?.forEach { self.clinicInfo.append(ClinicInfo(name: $0.properties?.name, phone: $0.properties?.phone, mask_adult: $0.properties?.mask_adult, mask_child: $0.properties?.mask_child, address: $0.properties?.address, updated: $0.properties?.updated, county: $0.properties?.county, town: $0.properties?.town)) }
                compeltion(self.clinicInfo)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}
