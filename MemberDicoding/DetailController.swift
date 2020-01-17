//
//  DetailController.swift
//  MemberDicoding
//
//  Created by Gilang Ramadhan on 17/01/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit
import CoreData

class DetailController: UIViewController {
    
    @IBOutlet weak var titleDetail: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var dateDetail: UILabel!
    @IBOutlet weak var emailDetail: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var memberId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupView()
    }
    
//    func setupView(){
//        let editButton = UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(editAction))
//        let deleteButton = UIBarButtonItem(image: UIImage(named: "delete"), style: .plain, target: self, action: #selector(deleteAction))
//
//        self.navigationItem.rightBarButtonItems = [editButton, deleteButton]
//    }
//
    @IBAction func editAction(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "addMemberController") as! AddMemberController
        controller.memberId = memberId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Peringatan!", message: "Apakah Anda ingin menghapus data ini?", preferredStyle: .actionSheet)
               let alertActionYes = UIAlertAction(title: "Ya", style: .default) { (action) in
                   let memberFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
                   memberFetch.fetchLimit = 1
                   memberFetch.predicate = NSPredicate(format: "id == \(self.memberId)")
                   
                   let result = try! self.context.fetch(memberFetch)
                   let memberToDelete = result.first as! NSManagedObject
                   self.context.delete(memberToDelete)
                   do {
                       try self.context.save()
                   } catch {
                       print(error.localizedDescription)
                   }
                   
                   self.navigationController?.popViewController(animated: true)
               }
               let alertActionNo = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
               alertController.addAction(alertActionYes)
               alertController.addAction(alertActionNo)
               self.present(alertController, animated: true, completion: nil)
    }
    
//    @objc func editAction(){
//
//    }
//
//    @objc func deleteAction(){
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        let memberFecth = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
        memberFecth.fetchLimit = 1
        
        memberFecth.predicate = NSPredicate(format: "id == \(memberId)")
        
        let result = try! context.fetch(memberFecth)
        let member : Member = result.first as! Member
        
        titleDetail.text = member.firstName! + " " + member.lastName!
        emailDetail.text = member.email
        dateDetail.text = member.birthDate
        imageDetail.image = UIImage(data: member.image!)
    }
    
}
