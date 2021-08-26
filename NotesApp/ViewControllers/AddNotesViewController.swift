//
//  AddNotesViewController.swift
//  NotesApp
//
//  Created by SIVA on 20/03/21.
//

import UIKit
import AVFoundation
import CoreData
import MobileCoreServices

class AddNotesViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    var delegate : AnyObject?
    var addNoteModel = AddNoteModel()
        
    let viewMain: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let buttonBack: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8.0
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(AddNotesViewController.backClick(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonAttach: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8.0
        button.setImage(UIImage(named: "attach"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(AddNotesViewController.updatePicture(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let buttonSave: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8.0
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(AddNotesViewController.saveNoteDetail(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let textFieldTitle: UITextField = {
        let textFieldTitle = UITextField()
        textFieldTitle.textColor = .white
        textFieldTitle.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        textFieldTitle.backgroundColor = .clear
        textFieldTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        textFieldTitle.translatesAutoresizingMaskIntoConstraints = false
        return textFieldTitle
    }()
    
    let textFieldDescription: UITextField = {
        let textFieldDescription = UITextField()
        textFieldDescription.textColor = .white
        textFieldDescription.attributedPlaceholder = NSAttributedString(string: "Type something ...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        textFieldDescription.backgroundColor = .clear
        textFieldDescription.font = UIFont(name: "HelveticaNeue", size: 20)
        textFieldDescription.translatesAutoresizingMaskIntoConstraints = false
        return textFieldDescription
    }()
    
    @objc func backClick(_ sener : Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addNoteModel.getListFromDB()
        setupViews()

    }

    func setupViews() {
        view.addSubview(viewMain)
        viewMain.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewMain.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewMain.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        viewMain.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        viewMain.addSubview(buttonBack)
        buttonBack.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        buttonBack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        buttonBack.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonBack.heightAnchor.constraint(equalToConstant: 50).isActive = true

        viewMain.addSubview(buttonSave)
        buttonSave.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        buttonSave.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        buttonSave.widthAnchor.constraint(equalToConstant: 100).isActive = true
        buttonSave.heightAnchor.constraint(equalToConstant: 50).isActive = true

        viewMain.addSubview(buttonAttach)
        buttonAttach.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        buttonAttach.rightAnchor.constraint(equalTo: buttonSave.leftAnchor, constant: -20).isActive = true
        buttonAttach.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonAttach.heightAnchor.constraint(equalToConstant: 50).isActive = true

        viewMain.addSubview(textFieldTitle)
        textFieldTitle.topAnchor.constraint(equalTo: buttonBack.bottomAnchor, constant: 40).isActive = true
        textFieldTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        textFieldTitle.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        textFieldTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true

        viewMain.addSubview(textFieldDescription)
        textFieldDescription.topAnchor.constraint(equalTo: textFieldTitle.bottomAnchor, constant: 10).isActive = true
        textFieldDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        textFieldDescription.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        textFieldDescription.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    func updateNotesList() {
        if(self.delegate is ViewController) {
            let viewC : ViewController = (self.delegate as! ViewController)
            viewC.viewModel.getListFromDB { (statu) in
                viewC.collectionView.reloadData()
                self.backClick("")
            }
        }
    }

    @objc func saveNoteDetail(_ sender : Any) {
        self.view.endEditing(true)
        addNoteModel.saveNote(self.textFieldTitle.text!, body: self.textFieldDescription.text!) { (status) in
            if(status){
                if(self.delegate is ViewController) {
                    let viewC : ViewController = (self.delegate as! ViewController)
                    viewC.viewModel.getListFromDB { (statu) in
                        viewC.collectionView.reloadData()
                        self.backClick("")
                    }
                }
            }
        }
    }

    @objc func updatePicture(_ sender : Any) {
        self.view.endEditing(true)
        let optionMenuController = UIAlertController(title: nil, message: "Upload Photo", preferredStyle: .actionSheet)
        // Create UIAlertAction for UIAlertController
        let takePhoto = UIAlertAction(title: kTakePhoto, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = [(kUTTypeImage as String)]
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: {() -> Void in
            })
        })
        let chooseFromLibrary = UIAlertAction(title: kChooseFromLibrary, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.mediaTypes = [(kUTTypeImage as String)]//kUTTypeMovie
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: {() -> Void in
            })
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        // Add UIAlertAction in UIAlertController
        optionMenuController.addAction(takePhoto)
        optionMenuController.addAction(chooseFromLibrary)
        optionMenuController.addAction(cancelAction)
        self.present(optionMenuController, animated: true, completion: nil)
    }
    // MARK: UIImagePickerControllerDelegate methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {
        })
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        picker.dismiss(animated: true, completion: {
        })
        let imageCropped: UIImage? = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        if imageCropped != nil {
            addNoteModel.saveImage(croppedImage: imageCropped!)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
