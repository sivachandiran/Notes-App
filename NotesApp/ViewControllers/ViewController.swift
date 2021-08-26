//
//  ViewController.swift
//  NotesApp
//
//  Created by SIVA on 20/03/21.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController {
    
    var viewModel = ViewModel()
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var viewCircle: UIView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    @IBAction func createNote(_ sender : UIButton) {
        let AddNotesVC : AddNotesViewController = AddNotesViewController()
        AddNotesVC.delegate = self
        self.navigationController?.pushViewController(AddNotesVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewCircle.layer.cornerRadius = 25.0
        
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
        collectionView.dataSource = self
        if let layout = collectionView?.collectionViewLayout as? NotesLayout {
          layout.delegate = self
        }
        viewModel.fetchNotesList { (status) in
            DispatchQueue.main.async { [self] in
                collectionView.reloadData()
            }
        }
    }
        
    @objc func selectNotes(_ sender : UIButton){
        let noteDetails : NotesList_Base = self.viewModel.arrayOfNotesList[sender.tag]
        let NoteDetailVC : NoteDetailViewController = NoteDetailViewController()
        NoteDetailVC.index = sender.tag
        NoteDetailVC.noteViewModel.notesDetails = noteDetails
        NoteDetailVC.noteViewModel.arrayOfNotesList = self.viewModel.arrayOfNotesList
        self.navigationController?.pushViewController(NoteDetailVC, animated: true)
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrayOfNotesList.count
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MyCell
        cell.layer.cornerRadius = 6.0
        cell.layer.masksToBounds = true
        cell.backgroundColor = self.viewModel.arrayOfColor[self.viewModel.index]
        cell.configure(viewModeldetail: self.viewModel, indexPath: indexPath)
        self.viewModel.index = self.viewModel.index + 1
      return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
      return CGSize(width: itemSize, height: itemSize)
    }
}
extension ViewController: NotesLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MyCell
        cell.configure(viewModeldetail: viewModel, indexPath: indexPath)
        let height = self.viewModel.getHeight(label: cell.label) + self.viewModel.getHeight(label: cell.labeldate)
        return height + 25
    }
}
extension UIImageView {
    var cachedImage:UIImage? {
        return ImageCache.sharedCache.object(forKey: self.imageURL as AnyObject) as? UIImage
    }
    func load(withURL url: String, _ placeholder: UIImage?, placeholderFor imageViewType:String, completionHandler completion:((_ image:UIImage) -> Void)?) {
        if let url = URL(string: url) {
            self.image = placeholder
            loadImage(withURL: url.absoluteString, placeholderFor: imageViewType, completionHandler: completion)
            
        } else {
            self.image = placeholder
        }
    }
    /**
     Loads the image from the given server URL
     - parameter url: image url to load
     */
    func loadImage(withURL url:String, placeholderFor imageViewType:String, completionHandler completion:((_ image:UIImage) -> Void)?) {
        if let URL = URL(string: url) {
            self.imageURL = url
            // If the cached image is found for the requested url, then just load the image from cache and exit
            if cachedImage != nil {
                //self.contentMode = .scaleAspectFit
                if completion != nil {
                    completion!(cachedImage!)
                } else {
                    self.setImage(image: cachedImage!, canAnimate: true)
                }
                self.imageURL = nil
                return
            }
            let request = URLRequest(url: URL)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error == nil {
                    if let imageData = data {
                        if let myImage:UIImage = UIImage(data: imageData) {
                            if self.imageURL == url {
                                // cache the image
                                ImageCache.sharedCache.setObject(myImage, forKey: self.imageURL as AnyObject, cost: imageData.count)
                                // update the ui with the downloaded image
                                DispatchQueue.main.async {
                                    // notify the completion handler if user wish to handle the downloaded image. Otherwise just load the image with alpha animation
                                    if completion != nil {
                                        completion!(myImage)
                                    } else {
                                        self.setImage(image: myImage, canAnimate: true)
                                    }
                                }
                            }
                        } else {
                            if self.imageURL == url {
                                DispatchQueue.main.async {
                                    //self.contentMode = .scaleAspectFit
                                    if(imageViewType != "") {
                                        //                                        let defaultImage = UIImage(named: imageViewType)!
                                        //                                        self.setImage(image: defaultImage, canAnimate: true)
                                    }
                                }
                            }
                        }
                        self.imageURL = nil
                        
                    } else {
                        if self.imageURL == url {
                            DispatchQueue.main.async {
                                //self.contentMode = .scaleAspectFit
                                if(imageViewType != ""){
                                    //                                    let defaultImage = UIImage(named: imageViewType)!
                                    //                                    self.setImage(image: defaultImage, canAnimate: true)
                                }
                            }
                        }
                    }
                } else {
                    if self.imageURL == url {
                        DispatchQueue.main.async {
                            //self.contentMode = .scaleAspectFit
                            if(imageViewType != ""){
                                let defaultImage = UIImage(named: imageViewType)!
                                self.setImage(image: defaultImage, canAnimate: true)
                            }
                        }
                    }
                }
            })
            task.resume()
        } else {
            print("Invalid image url given. The image url should be a server URL.")
        }
    }
    func setImage(image: UIImage, canAnimate animate: Bool) {
        self.alpha = 0
        //self.contentMode = .scaleAspectFit
        self.image = image
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
    }
    /**
     Resizes the given image to a best matching size to fit in the UIImageView
     - parameter image: iamge to resize
     - returns: resized image view
     */
    func resizeImage(image:inout UIImage) -> UIImage {
        var newImageSize: CGSize = self.frame.size
        if image.size.height > newImageSize.height || image.size.width > newImageSize.width {
            newImageSize = self.getSizeToFitInImageView(imageSize: image.size, imageViewSize: newImageSize)
            UIGraphicsBeginImageContextWithOptions(newImageSize, false, 0.0)
            image.draw(in: CGRect(x: 0, y: 0, width: newImageSize.width, height: newImageSize.height))
            image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        return image
    }
    func getSizeToFitInImageView(imageSize: CGSize, imageViewSize: CGSize) -> CGSize {
        
        var requiredSize: CGSize = CGSize.zero
        
        let requiredHeight: CGFloat = (imageSize.height * imageViewSize.width) / imageSize.width
        
        requiredSize = CGSize(width: imageViewSize.width, height: requiredHeight)
        
        return requiredSize
        
    }
    private struct AssociatedKeys {
        static var DescriptiveName = "nsh_DescriptiveName"
    }
    var imageURL: String! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as? String
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.DescriptiveName,
                    newValue as NSString?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    class ImageCache {
        static let sharedCache = { () -> NSCache<AnyObject, AnyObject> in
            let cache = NSCache<AnyObject, AnyObject>()
            cache.name = "MyImageCache"
            cache.countLimit = 200 // Max 20 images in memory.
            cache.totalCostLimit = 50*1024*1024 // Max 10MB used.
            return cache
        }()
    }
}
