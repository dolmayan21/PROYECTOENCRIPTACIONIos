//
//  ViewController.swift
//  KeyGen
//
//  Created by Alejandro Leon Del Villar on 09/02/20.
//  Copyright © 2020 Alejandro Leon Del Villar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var contentSymmetricKeyTextField: UITextField!
    @IBOutlet weak var contentAlphabetTextField: UITextView!
    @IBOutlet weak var collectionView: UICollectionView?
    
    private var data: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentAlphabetTextField.text = PerfectPaperPasswordsAlgorithm.singleton.alphabet
        loadCurrentDataFromSave()
    }
    
    @IBAction func generateNewSymmetricKeyButton() {
        bindData()
    }
    
    private func bindData() {
        PerfectPaperPasswordsAlgorithm.singleton.generateNewSymmetricKey()
        contentSymmetricKeyTextField.text = PerfectPaperPasswordsAlgorithm.singleton.getLegibleSymmetricKey()
        let passwords = PerfectPaperPasswordsAlgorithm.singleton.runAlgorithm()
        data = PerfectPaperPasswordsAlgorithm.getCipheredArrays(from: passwords)
        saveCurrentData()
        collectionView?.reloadData()
    }
    
    private func setCollectionViewUp() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    private func saveCurrentData() {
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: "currentData")
        defaults.set(contentSymmetricKeyTextField.text ?? "", forKey: "symetricKey")
        defaults.synchronize()
    }
    
    private func loadCurrentDataFromSave() {
        let defaults = UserDefaults.standard
        let data = defaults.array(forKey: "currentData") as?  [[String]]
        let symetricKey =  defaults.string(forKey: "symetricKey")
        contentSymmetricKeyTextField.text = symetricKey
        self.data = data ?? []
        collectionView?.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keyCell", for: indexPath)
        if let keyCell = cell as? KeyCell {
            let value = data[indexPath.section][indexPath.row]
            keyCell.update(withValue: value)
        }
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 6
        return CGSize(width: width, height: 50)
    }
}

