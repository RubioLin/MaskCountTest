//
//  ViewController.swift
//  MaskCountTest
//
//  Created by 林俊緯 on 2022/7/8.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dailyPhraseInChinsesLabel: UILabel!
    @IBOutlet weak var dailyPhraseinEnglishLabel: UILabel!
    @IBOutlet weak var maskCountTableView: UITableView!
    @IBOutlet weak var selectedCountyTownButton: UIButton!
    
    let countyTownPickerView = UIPickerView(frame: .zero)
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: .zero, y: .zero, width: 500, height: 500))
    
    var clinicInfo = [ClinicInfo?]()
    var countyTownInfo = [CountyTown]()

    var index = 0
    var buttonTitle = ""
    var selectCounty: CountyTown {
        get { return countyTownInfo[index] }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMaskCountTableView()
        self.setupCountyTownPickerView()
        NetworkManager.shared.fetchDailyPhrase()
        NetworkManager.shared.fetchMaskCount{ clinicInfo, countyTownInfo in
            self.setActivityIndicator()
            DispatchQueue.main.async {
                self.countyTownInfo = countyTownInfo
                self.clinicInfo = clinicInfo
                self.maskCountTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
        configureUI()
    }
    // 功能待補
    private func setActivityIndicator() {
        DispatchQueue.main.async {
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.center = self.view.center
            self.activityIndicator.startAnimating()
        }
    }

    
    private func filterCountyTown(_ county: String,_ town: String) {
        NetworkManager.shared.fetchMaskCount { clinicInfo, countyTownInfo in
            if county == "不拘", town == "不拘" {
                DispatchQueue.main.async {
                    self.clinicInfo = clinicInfo
                    self.maskCountTableView.reloadData()
                }
            } else if  county == "未分類", town == "未分類" {
                DispatchQueue.main.async {
                    self.clinicInfo = clinicInfo.filter { $0.county == ""}
                    self.maskCountTableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.clinicInfo = clinicInfo.filter { $0.county == county}.filter{ $0.town == town }
                    self.maskCountTableView.reloadData()
                }
            }
        }
    }
    
    private func setupMaskCountTableView() {
        maskCountTableView.dataSource = self
        maskCountTableView.delegate = self
        maskCountTableView.register(UINib(nibName: "ClinicTableViewCell", bundle: .main), forCellReuseIdentifier: "ClinicTableViewCell")
    }
    
    private func setupCountyTownPickerView() {
        countyTownPickerView.dataSource = self
        countyTownPickerView.delegate = self
    }
    
    private func configureUI() {
        selectedCountyTownButton.layer.cornerRadius = selectedCountyTownButton.frame.height / 2
        dailyPhraseinEnglishLabel.text = NetworkManager.shared.dailyPhraseInEnglish
        dailyPhraseInChinsesLabel.text = NetworkManager.shared.dailyPhraseInChinese
    }

    private func setConstraints() {
        
        dailyPhraseInChinsesLabel.translatesAutoresizingMaskIntoConstraints = false
        dailyPhraseinEnglishLabel.translatesAutoresizingMaskIntoConstraints = false
        maskCountTableView.translatesAutoresizingMaskIntoConstraints = false
        selectedCountyTownButton.translatesAutoresizingMaskIntoConstraints = false
        
        let dailyPhraseInChinsesLabelConstraints = [
            dailyPhraseInChinsesLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12),
            dailyPhraseInChinsesLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12),
            dailyPhraseInChinsesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dailyPhraseInChinsesLabel.bottomAnchor.constraint(equalTo: dailyPhraseinEnglishLabel.topAnchor, constant: -8)
        ]

        let dailyPhraseinEnglishLabelConstraints = [
            dailyPhraseinEnglishLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12),
            dailyPhraseinEnglishLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12),
            dailyPhraseinEnglishLabel.topAnchor.constraint(equalTo: dailyPhraseInChinsesLabel.bottomAnchor, constant: 8),
            dailyPhraseinEnglishLabel.bottomAnchor.constraint(equalTo: maskCountTableView.topAnchor, constant: -8)
        ]
        
        let maskCountTableViewConstraints = [
            maskCountTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12),
            maskCountTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12),
            maskCountTableView.topAnchor.constraint(equalTo: dailyPhraseinEnglishLabel.bottomAnchor, constant: 8),
            maskCountTableView.bottomAnchor.constraint(equalTo: selectedCountyTownButton.topAnchor, constant: -8)
        ]
        
        let selectedCountyTownButtonConstraints = [
            selectedCountyTownButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12),
            selectedCountyTownButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12),
            selectedCountyTownButton.topAnchor.constraint(equalTo: maskCountTableView.bottomAnchor, constant: 8),
            selectedCountyTownButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]

        NSLayoutConstraint.activate(dailyPhraseInChinsesLabelConstraints)
        NSLayoutConstraint.activate(dailyPhraseinEnglishLabelConstraints)
        NSLayoutConstraint.activate(maskCountTableViewConstraints)
        NSLayoutConstraint.activate(selectedCountyTownButtonConstraints)
        
    }
    
    @IBAction func clickselectedCountyTownButton(_ sender: Any) {
        view.addSubview(countyTownPickerView)
        countyTownPickerView.backgroundColor = .white
        countyTownPickerView.frame = CGRect(x: .zero,
                                            y: self.view.frame.maxY - self.view.frame.height * 0.25,
                                            width: self.view.frame.width,
                                            height: self.view.frame.height * 0.25)

    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 20
        return self.clinicInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicTableViewCell", for: indexPath) as? ClinicTableViewCell
        if let clinicInfo = self.clinicInfo[indexPath.row] {
            cell?.configureCell(with: clinicInfo)
        } else {
            cell?.truncateCell()
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            
            return self.countyTownInfo.count
        case 1:
            return self.selectCounty.town.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return self.countyTownInfo[row].county
        case 1:
            return self.selectCounty.town[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            index = row
            buttonTitle = self.countyTownInfo[row].county ?? ""
            pickerView.reloadComponent(1)
        case 1:
            var title = buttonTitle
            title += " \(self.selectCounty.town[row])"
            selectedCountyTownButton.setTitle(title, for: .normal)
            self.filterCountyTown(buttonTitle, self.selectCounty.town[row])
            pickerView.removeFromSuperview()
        default:
            break
        }
    }
    
    
    
}
