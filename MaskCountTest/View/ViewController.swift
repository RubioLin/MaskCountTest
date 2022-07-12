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
    
    var clinicInfo = [ClinicInfo?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMaskCountTableView()
        NetworkManager.shared.fetchDailyPhrase()
        NetworkManager.shared.fetchMaskCount{ clinicInfo in
            DispatchQueue.main.async {
                self.clinicInfo = clinicInfo
                self.maskCountTableView.reloadData()
            }
        }
                
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
        configureUI()
    }
    
    private func setupMaskCountTableView() {
        maskCountTableView.dataSource = self
        maskCountTableView.delegate = self
        maskCountTableView.register(UINib(nibName: "ClinicTableViewCell", bundle: .main), forCellReuseIdentifier: "ClinicTableViewCell")
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
