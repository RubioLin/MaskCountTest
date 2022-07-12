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
    var countyTownInfo = [CountyTown(county: "不拘", town: ["不拘"]), CountyTown(county: "未分類", town: ["未分類"])]
    
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
    func fetchMaskCount(_ compeltion: @escaping ([ClinicInfo], [CountyTown]) -> Void ) {
        
        URLSession.shared.dataTask(with: URL(string: maskCountUrl)!) { data, response, error in
            guard error == nil else { return }
            self.clinicInfo.removeAll()
            DispatchQueue.global(qos: .default).async {
                do {
                    var datas = try JSONDecoder().decode(MaskCount.self, from: data ?? Data()).features
                    datas = datas?.sorted(by: { ($0.properties?.county)! > ($1.properties?.county)! })
                    
                    datas?.forEach { data in
                        // Data For TableView
                        self.clinicInfo.append(ClinicInfo(name: data.properties?.name, phone: data.properties?.phone, mask_adult: data.properties?.mask_adult, mask_child: data.properties?.mask_child, address: data.properties?.address, updated: data.properties?.updated, county: data.properties?.county, town: data.properties?.town))
                        //                    self.clinicInfo = self.clinicInfo.sorted(by: { $0.county! > $1.county! })
                        
                        // Data For PickerView
                        let isContainCounty = self.countyTownInfo.contains { CountyTown in
                            if CountyTown.county == data.properties?.county {
                                return true
                            } else {
                                return false
                            }
                        }
                        var towns = [String]()
                        if !isContainCounty, data.properties?.county != "" {
                            towns.append((data.properties?.town)!)
                            self.countyTownInfo.append(CountyTown(county: data.properties?.county, town: towns))
                        } else {
                            towns.append((data.properties?.town)!)
                            let index = self.countyTownInfo.endIndex
                            if !self.countyTownInfo[index-1].town.contains((data.properties?.town)!), data.properties?.town != "" {
                                self.countyTownInfo[index-1].town.append((data.properties?.town)!)
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                compeltion(self.clinicInfo, self.countyTownInfo)
            }
        }.resume()
    }
    
}
