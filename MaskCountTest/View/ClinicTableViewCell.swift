//
//  ClinicTableViewCell.swift
//  MaskCountTest
//
//  Created by 林俊緯 on 2022/7/10.
//

import UIKit

class ClinicTableViewCell: UITableViewCell {

    @IBOutlet weak var clinicNameLabel: UILabel!
    @IBOutlet weak var clinicPhoneLabel: UILabel!
    @IBOutlet weak var clinicAddressLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var adultMaskCountLabel: UILabel!
    @IBOutlet weak var childMaskCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setConstraints() {

        clinicNameLabel.translatesAutoresizingMaskIntoConstraints = false
        clinicPhoneLabel.translatesAutoresizingMaskIntoConstraints = false
        clinicAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        updateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        adultMaskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        childMaskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let clinicNameLabelConstraints = [
            clinicNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            clinicNameLabel.bottomAnchor.constraint(equalTo: clinicAddressLabel.topAnchor, constant: -8),
            clinicNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            clinicNameLabel.rightAnchor.constraint(equalTo: clinicPhoneLabel.leftAnchor, constant: -10)
        ]

        let clinicPhoneLabelConstraints = [
            clinicPhoneLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            clinicPhoneLabel.bottomAnchor.constraint(equalTo: clinicAddressLabel.topAnchor, constant: -8),
            clinicPhoneLabel.leftAnchor.constraint(equalTo: clinicNameLabel.rightAnchor, constant: 10),
            clinicPhoneLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12)
        ]
        
        let clinicAddressLabelConstraints = [
            clinicAddressLabel.topAnchor.constraint(equalTo: clinicNameLabel.bottomAnchor, constant: 8),
            clinicAddressLabel.bottomAnchor.constraint(equalTo: updateTimeLabel.topAnchor, constant: -8),
            clinicAddressLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            clinicAddressLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ]

        let updateTimeLabelConstraints = [
            updateTimeLabel.topAnchor.constraint(equalTo: clinicAddressLabel.bottomAnchor, constant: 8),
            updateTimeLabel.bottomAnchor.constraint(equalTo: adultMaskCountLabel.topAnchor, constant: -8),
            updateTimeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            updateTimeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ]

        let adultMaskCountLabelConstraints = [
            adultMaskCountLabel.topAnchor.constraint(equalTo: updateTimeLabel.bottomAnchor, constant: 8),
            adultMaskCountLabel.bottomAnchor.constraint(equalTo: childMaskCountLabel.topAnchor, constant: -8),
            adultMaskCountLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            adultMaskCountLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ]

        let childMaskCountLabelConstraints = [
            childMaskCountLabel.topAnchor.constraint(equalTo: adultMaskCountLabel.bottomAnchor, constant: 8),
            childMaskCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            childMaskCountLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            childMaskCountLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(clinicNameLabelConstraints)
        NSLayoutConstraint.activate(clinicPhoneLabelConstraints)
        NSLayoutConstraint.activate(clinicAddressLabelConstraints)
        NSLayoutConstraint.activate(updateTimeLabelConstraints)
        NSLayoutConstraint.activate(adultMaskCountLabelConstraints)
        NSLayoutConstraint.activate(childMaskCountLabelConstraints)
        
    }
    
    func configureCell(with clinicInfo: ClinicInfo) {
        self.clinicNameLabel.text = clinicInfo.name ?? "clinic name"
        self.clinicPhoneLabel.text = clinicInfo.phone ?? "clinic phone"
        self.clinicAddressLabel.text = clinicInfo.address ?? "clinic address"
        self.updateTimeLabel.text = clinicInfo.updated ?? "update time"
        self.adultMaskCountLabel.text = "大人口罩數量：\(clinicInfo.mask_adult ?? 0)"
        self.childMaskCountLabel.text = "兒童口罩數量：\(clinicInfo.mask_child ?? 0)"
    }
    
    func truncateCell() {
        self.clinicNameLabel.text = "Loading..."
        self.clinicPhoneLabel.text = "Loading..."
        self.clinicAddressLabel.text = "Loading..."
        self.updateTimeLabel.text = "Loading..."
        self.adultMaskCountLabel.text = "Loading..."
        self.childMaskCountLabel.text = "Loading..."
    }
}
