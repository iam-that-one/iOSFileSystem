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
  
    lazy var foldeCreationBtn : UIButton = {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = UIColor.blue
      $0.setTitle("Create Folder", for: .normal)
      $0.setTitleColor(.white, for: .normal)
      $0.layer.cornerRadius = 10
      $0.addTarget(self, action: #selector(createFolderBtnClick), for: .touchDown)
      return $0
      }(UIButton(type: .system))
    
    lazy var fileCreationBtn : UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.blue
        $0.setTitle("Create file", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(createFileBtnClick), for: .touchDown)
        return $0
      }(UIButton(type: .system))
    
    lazy var fileContentTf : UITextField = {
        $0.borderStyle = .roundedRect
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
      }(UITextField())
    
    lazy var folderFileNameTf : UITextField = {
        $0.borderStyle = .roundedRect
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
      }(UITextField())
    
    lazy var tableView : UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .darkGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
      }(UITableView())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        fetchData()
        uiPreferences()
    }

    func uiPreferences(){
        [folderFileNameTf,foldeCreationBtn,fileCreationBtn,tableView,fileContentTf].forEach{view.addSubview($0)}
     
        NSLayoutConstraint.activate([
            folderFileNameTf.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            folderFileNameTf.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            folderFileNameTf.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            
            foldeCreationBtn.topAnchor.constraint(equalTo: folderFileNameTf.bottomAnchor, constant: 10),
            foldeCreationBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            foldeCreationBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            
            fileCreationBtn.topAnchor.constraint(equalTo: foldeCreationBtn.bottomAnchor, constant: 10),
            fileCreationBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            
            fileCreationBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),

            fileContentTf.topAnchor.constraint(equalTo: fileCreationBtn.bottomAnchor,constant: 10),
            fileContentTf.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fileContentTf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: fileContentTf.bottomAnchor,constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -60)
        ])
   
    }
    func createFile(){
        let fileManager = FileManager.default
        let directiryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = directiryUrl?.appendingPathComponent(selectedFolder).appendingPathComponent(folderFileNameTf.text! + ".swift")
        let data = fileContentTf.text?.data(using: .utf8)
        fileManager.createFile(atPath: fileName!.path, contents: data, attributes: nil)
    }
    func createFolder(){
        if folderFileNameTf.text != ""{
        let fileManager = FileManager.default
        let dirUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let dir = dirUrl?.appendingPathComponent(folderFileNameTf.text!)
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
        let directoryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        do{
            let folders = try fileManager.contentsOfDirectory(atPath: directoryUrl!.path)
            for folder in folders{
                let selectedFolders = directoryUrl?.appendingPathComponent(folder)
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
        cell.backgroundColor = .darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFolder = folders[indexPath.row]
        print(selectedFolder)
    }
}

