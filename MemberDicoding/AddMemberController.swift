//
//  AddMemberController.swift
//  MemberDicoding
//
//  Created by Gilang Ramadhan on 16/01/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit
import CoreData

class AddMemberController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var memberId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        if memberId != 0 {
            let memberFecth = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
            memberFecth.fetchLimit = 1
            
            memberFecth.predicate = NSPredicate(format: "id == \(memberId)")
            
            let result = try! context.fetch(memberFecth)
            let member : Member = result.first as! Member
            
            firstNameTextField.text = member.firstName
            lastNameTextField.text = member.lastName
            emailTextField.text = member.email
            profileImageView.image = UIImage(data: member.image!)
            
            datePicker.date = dateFormat().date(from: member.birthDate!)!
        }
    }
    
    @IBAction func save(_ sender: Any) {
        guard let firstName = firstNameTextField.text, firstName != "" else {
            let allertController = UIAlertController(title: "Peringatan!", message: "First Name wajib diisi!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ya", style: .default, handler: nil)
            allertController.addAction(alertAction)
            self.present(allertController, animated: true, completion: nil)
            return
        }
        
        guard let lastName = lastNameTextField.text, lastName != "" else {
            let allertController = UIAlertController(title: "Peringatan!", message: "Last Name wajib diisi!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ya", style: .default, handler: nil)
            allertController.addAction(alertAction)
            self.present(allertController, animated: true, completion: nil)
            return
        }
        
        guard let email = emailTextField.text, email != "" else {
            let allertController = UIAlertController(title: "Peringatan!", message: "Email wajib diisi!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ya", style: .default, handler: nil)
            allertController.addAction(alertAction)
            self.present(allertController, animated: true, completion: nil)
            return
        }
        
        let birtDate = dateFormat().string(from: datePicker.date)
        
        if memberId > 0 {
            // edit
            let memberFecth = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
            memberFecth.fetchLimit = 1
            
            memberFecth.predicate = NSPredicate(format: "id == \(memberId)")
            
            let result = try! context.fetch(memberFecth)
            let member : Member = result.first as! Member
            
            member.firstName = firstName
            member.lastName = lastName
            member.email = email
            member.birthDate = birtDate
            
            if let image = profileImageView.image{
                let data = image.pngData() as NSData?
                member.image = data as Data?
            }
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            // add
            let member = Member(context: context)
            
            let request: NSFetchRequest = Member.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
            request.sortDescriptors = [sortDescriptor]
            request.fetchLimit = 1
            
            var maxId = 0
            do {
                let lastMember = try context.fetch(request)
                maxId = Int(lastMember.first?.id ?? 0)
            } catch {
                print(error.localizedDescription)
            }
            
            member.id = Int32(maxId) + 1
            member.firstName = firstName
            member.lastName = lastName
            member.email = email
            member.birthDate = birtDate
            
            if let image = profileImageView.image{
                let data = image.pngData() as NSData?
                member.image = data as Data?
            }
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getImage(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func dateFormat() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        return dateFormatter
    }
}

extension AddMemberController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.profileImageView.contentMode = .scaleToFill
            self.profileImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
