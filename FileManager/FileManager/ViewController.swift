//
//  ViewController.swift
//  FileManager
//
//  Created by Abdullah Alnutayfi on 23/11/2021.
//

import UIKit

class ViewController: UIViewController {

    var folders : [String] = []
    var selectedFolder = ""
    var color : UIColor = .darkGray
    var textColor : UIColor = .white
    let folderFileName = UITextField()
    let tableView = UITableView(frame: .null, style: .insetGrouped)
    let fileContent = UITextField()
    let foldeCreation = UIButton()
    let fileCreation = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        fetchData()
        setup()
    }

    func setup(){
        // Add subViews to the main view
        [folderFileName,foldeCreation,fileCreation,tableView,fileContent].forEach{view.addSubview($0)}
        
        // Set textField configrations
        folderFileName.borderStyle = .roundedRect
        folderFileName.translatesAutoresizingMaskIntoConstraints = false
        
        // Set textField constraints
        folderFileName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        folderFileName.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        folderFileName.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true

       // Set button1 configration
        foldeCreation.translatesAutoresizingMaskIntoConstraints = false
        foldeCreation.backgroundColor = UIColor.blue
        foldeCreation.setTitle("Create Folder", for: .normal)
        foldeCreation.setTitleColor(.white, for: .normal)
        foldeCreation.addTarget(self, action: #selector(createFolderBtnClick), for: .touchDown)
        
        // Set button1 constraints
        foldeCreation.topAnchor.constraint(equalTo: folderFileName.bottomAnchor, constant: 10).isActive = true
        foldeCreation.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        foldeCreation.layer.cornerRadius = 10
        foldeCreation.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true

        // Set button2 configration
        fileCreation.translatesAutoresizingMaskIntoConstraints = false
        fileCreation.backgroundColor = UIColor.blue
        fileCreation.setTitle("Create file", for: .normal)
        fileCreation.setTitleColor(.white, for: .normal)
        fileCreation.addTarget(self, action: #selector(createFileBtnClick), for: .touchDown)
        
        // Set button1 constraints
        fileCreation.topAnchor.constraint(equalTo: foldeCreation.bottomAnchor, constant: 10).isActive = true
        fileCreation.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        fileCreation.layer.cornerRadius = 10
        fileCreation.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true

        // Set textView configration
        fileContent.borderStyle = .roundedRect
        fileContent.translatesAutoresizingMaskIntoConstraints = false
        
        // Set textView constraints
        fileContent.topAnchor.constraint(equalTo: fileCreation.bottomAnchor,constant: 10).isActive = true
        fileContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        fileContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        // Set tableView constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: fileContent.bottomAnchor,constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -60).isActive = true
        
        // Set tableView configrations
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 5
        tableView.backgroundColor = .darkGray
    }
    func createFile(){
        let fileManager = FileManager.default
        let dirUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = dirUrl?.appendingPathComponent(selectedFolder).appendingPathComponent(folderFileName.text! + ".swift")
        let data = fileContent.text?.data(using: .utf8)
        fileManager.createFile(atPath: fileName!.path, contents: data, attributes: nil)
    }
    func createFolder(){
        if folderFileName.text != ""{
        let fileManager = FileManager.default
        let dirUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let dir = dirUrl?.appendingPathComponent(folderFileName.text!)
        do{
            let folders = try fileManager.contentsOfDirectory(atPath: dirUrl!.path)
            try fileManager.createDirectory(at: dir!, withIntermediateDirectories: true, attributes: nil)
            print(dirUrl!.path)
            for folder in folders{
                let selectedFolders = dirUrl?.appendingPathComponent(folder)
                if selectedFolders?.hasDirectoryPath == true{
                    self.folders.append(folder)
                }
            }
        }catch{
            print("Something went wrong")
        }
            
        folders = []
        fetchData()
        tableView.reloadData()
        }
    }
    func fetchData(){
        let fileManager = FileManager.default
        let dirUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        do{
            let folders = try fileManager.contentsOfDirectory(atPath: dirUrl!.path)
            for folder in folders{
                let selectedFolders = dirUrl?.appendingPathComponent(folder)
                if selectedFolders?.hasDirectoryPath == true{
                    self.folders.append(folder)
                }
            }
        }catch{
            print("Something went wrong")
        }
        tableView.reloadData()
    }
    @objc func createFolderBtnClick(){
        createFolder()
    }
    
    @objc func createFileBtnClick(){
        createFile()
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = folders[indexPath.row]
        cell.backgroundColor = color
        cell.textLabel?.textColor = textColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFolder = folders[indexPath.row]
        color = .black
        print(selectedFolder)
    }
}

