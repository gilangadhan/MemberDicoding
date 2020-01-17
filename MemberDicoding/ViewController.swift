//
//  ViewController.swift
//  MemberDicoding
//
//  Created by Gilang Ramadhan on 16/01/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var listMember: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let searchController = UISearchController(searchResultsController: nil)
    
    var memberDicoding: [Member] = []
    var filterMember: [Member] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let memberFect = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
            memberDicoding = try context.fetch(memberFect) as! [Member]
        } catch {
            print(error.localizedDescription)
        }
        
        self.listMember.reloadData()
    }
    
    func setupView(){
        listMember.delegate = self
        listMember.dataSource = self
        
        searchController.searchBar.placeholder = "Cari Member..."
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater =  self
        
        listMember.tableHeaderView = searchController.searchBar
        
        self.navigationItem.title = "Member Dicoding"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.14, green: 0.86, blue: 0.73, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && !((searchController.searchBar.text?.isEmpty)!){
            return filterMember.count
        }
        return memberDicoding.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var member = memberDicoding[indexPath.row]
        let item = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as! MemberTableViewCell
        
        if searchController.isActive && !((searchController.searchBar.text?.isEmpty)!){
            member = filterMember[indexPath.row]
        } else {
            member = memberDicoding[indexPath.row]
        }
        
        item.nameItem.text = member.firstName! + " " + member.lastName!
        item.emailItem.text = member.email
        
        if let imageData = member.image{
            item.imageItem.image = UIImage(data: imageData as Data)
            item.imageItem.layer.cornerRadius = item.imageItem.frame.height / 2
            item.imageItem.clipsToBounds = true
        }
        
        return item
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "detailController") as! DetailController
        controller.memberId = Int(memberDicoding[indexPath.row].id)
        self.navigationController?.pushViewController(controller, animated: true)    }
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let keyword = searchController.searchBar.text!
        if keyword.count > 0 {
            print("Kata kunci \(keyword)")
            
            let result = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
            
            let predicate = NSPredicate(format: "firstName CONTAINS[c] %@", keyword)
            let anotherPredicate = NSPredicate(format: "lastName CONTAINS[c] %@", keyword)
            
            let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates: [predicate, anotherPredicate])
            
            result.predicate = predicateCompound
            
            do {
                let memberFilter = try context.fetch(result) as! [NSManagedObject]
                filterMember =  memberFilter as! [Member]
            } catch {
                print(error)
            }
            
            self.listMember.reloadData()
        }
    }
}
