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
  
    let textField = UITextField()
    let tableView = UITableView()
    let textView = UITextField()
    let button1 = UIButton()
    let button2 = UIButton()


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setup()
    }

    func setup(){
        // Add subViews to the main view
        [textField,button1,button2,tableView,textView].forEach{view.addSubview($0)}
        
        // Set textField configrations
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Set textField constraints
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true

       // Set button1 configration
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.backgroundColor = UIColor.blue
        button1.setTitle("Create Folder", for: .normal)
        button1.setTitleColor(.white, for: .normal)
        button1.addTarget(self, action: #selector(createFolderBtnClick), for: .touchDown)
        
        // Set button1 constraints
        button1.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10).isActive = true
        button1.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        button1.layer.cornerRadius = 10
        button1.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true

        // Set button2 configration
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.backgroundColor = UIColor.blue
        button2.setTitle("Create file", for: .normal)
        button2.setTitleColor(.white, for: .normal)
        button2.addTarget(self, action: #selector(createFileBtnClick), for: .touchDown)
        
        // Set button1 constraints
        button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 10).isActive = true
        button2.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        button2.layer.cornerRadius = 10
        button2.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true

        // Set textView configration
        textView.borderStyle = .roundedRect
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set textView constraints
        textView.topAnchor.constraint(equalTo: button2.bottomAnchor,constant: 10).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        // Set tableView constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // Set tableView configrations
        tableView.delegate = self
        tableView.dataSource = self
    }
    func createFile(){
        let fileManager = FileManager.default
        let dirUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = dirUrl?.appendingPathComponent(selectedFolder).appendingPathComponent(textField.text! + ".swift")
        let data = textView.text?.data(using: .utf8)
        fileManager.createFile(atPath: fileName!.path, contents: data, attributes: nil)
    }
    func createFolder(){
        if textField.text != ""{
        let fileManager = FileManager.default
        let dirUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let dir = dirUrl?.appendingPathComponent(textField.text!)
        do{
            let folders = try fileManager.contentsOfDirectory(atPath: dirUrl!.path)
            try fileManager.createDirectory(at: dir!, withIntermediateDirectories: true, attributes: nil)

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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFolder = folders[indexPath.row]
        print(selectedFolder)
    }
}
