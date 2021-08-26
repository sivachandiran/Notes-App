//
//  NoteDetailViewController.swift
//  NotesApp
//
//  Created by SIVA on 20/03/21.
//

import UIKit

class NoteDetailViewController: UIViewController {

    var delegate : AnyObject?
    var notesDetail : NotesList_Base!
    var noteViewModel = NoteDetailViewModel()
    var index : Int = 0
    
    var flowHeightConstraint: NSLayoutConstraint?
    
    let viewMain: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()


    let viewImageFullScreen: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let scrollViewImage: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    let bannerImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        return image
    }()

    let buttonBack: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8.0
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(NoteDetailViewController.backClick(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let buttonClose: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8.0
        button.setImage(UIImage(named: "close"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(NoteDetailViewController.closeClick(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let viewImageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let buttonShowBanner: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8.0
        button.tintColor = .white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(NoteDetailViewController.showBannerImageClick(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let labelTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let labelDate: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let labelDescription: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = .white
        label.isUserInteractionEnabled = true
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc func closeClick(_ sender : Any) {
        buttonClose.isHidden = true
        bannerImage.isHidden = false
        buttonShowBanner.isHidden = false
        scrollViewImage.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.viewImageFullScreen.frame.origin.y = 110
            self.viewImageFullScreen.frame.size.height = 200
            self.bannerImage.frame = self.viewImageFullScreen.bounds
            self.scrollViewImage.frame = self.viewImageFullScreen.bounds
        } completion: { (status) in
            self.viewImageFullScreen.isHidden = true
        }
    }
    
    @objc func showBannerImageClick(_ sender : UIButton) {
        viewImageFullScreen.isHidden = false
        buttonShowBanner.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.viewImageFullScreen.frame.origin.y = 0
            self.viewImageFullScreen.frame.size.height = UIScreen.main.bounds.height
            self.bannerImage.frame = self.viewImageFullScreen.bounds
            self.scrollViewImage.frame = self.viewImageFullScreen.bounds
        } completion: { (status) in
            self.buttonClose.isHidden = false
            self.bannerImage.isHidden = true
            self.scrollViewImage.isHidden = false
            self.noteViewModel.loadBannerImages(scrollView: self.scrollViewImage, image: self.bannerImage.image!)
        }
    }
    
    @objc func backClick(_ sender : Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews(noteViewModel.notesDetails)
        noteViewModel.loadImage(imageView: imageView)
        noteViewModel.loadImage(imageView: bannerImage)

    }

    func setupViews(_ notesDetails: NotesList_Base){
        
        notesDetail = notesDetails
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

        viewMain.addSubview(scrollView)
        scrollView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        scrollView.topAnchor.constraint(equalTo: buttonBack.bottomAnchor, constant: 20).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

        var previousBottomAnchor = scrollView.topAnchor
        if(notesDetails.image! != ""){
            scrollView.addSubview(viewImageBackground)
            viewImageBackground.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            viewImageBackground.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            viewImageBackground.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            viewImageBackground.heightAnchor.constraint(equalToConstant: 200).isActive = true
            previousBottomAnchor = viewImageBackground.bottomAnchor
            
            viewImageBackground.addSubview(imageView)
            imageView.topAnchor.constraint(equalTo: viewImageBackground.topAnchor).isActive = true
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            viewImageBackground.addSubview(buttonShowBanner)
            buttonShowBanner.topAnchor.constraint(equalTo: viewImageBackground.topAnchor).isActive = true
            buttonShowBanner.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            buttonShowBanner.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            buttonShowBanner.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }

        labelTitle.text = notesDetails.title
        scrollView.addSubview(labelTitle)
        labelTitle.topAnchor.constraint(equalTo: previousBottomAnchor, constant: 20).isActive = true
        labelTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 25).isActive = true
        labelTitle.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -50).isActive = true

        let milisecond = Double(notesDetails.time!)
        let date = Date(timeIntervalSince1970: (milisecond! / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"

        labelDate.text = dateFormatter.string(from: date)
        scrollView.addSubview(labelDate)
        labelDate.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 20).isActive = true
        labelDate.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 25).isActive = true
        labelDate.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -50).isActive = true
        
        labelDescription.attributedText = noteViewModel.attributedLabelText(text: noteViewModel.removeStar(stringText: notesDetails.body!), highlight: noteViewModel.updateLableText(stringText: notesDetails.body!), underLine: noteViewModel.updateLinkText(stringText: notesDetails.body!), hyperUrl: noteViewModel.findURL(stringText: notesDetails.body!), size: 24, FontName: "HelveticaNeue-Bold", color: .white)
            
        scrollView.addSubview(labelDescription)
        labelDescription.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 20).isActive = true
        labelDescription.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 25).isActive = true
        labelDescription.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -50).isActive = true
        labelDescription.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        labelDescription.isUserInteractionEnabled = true
        labelDescription.addGestureRecognizer(tapAction)
        
        view.addSubview(viewImageFullScreen)
        viewImageFullScreen.frame = CGRect(x: 0, y: 110, width: UIScreen.main.bounds.width, height: 200)
        viewImageFullScreen.isHidden = true
        
        viewImageFullScreen.addSubview(scrollViewImage)
        scrollViewImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)

        viewImageFullScreen.addSubview(bannerImage)
        bannerImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)

        buttonClose.isHidden = true
        view.addSubview(buttonClose)
        buttonClose.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        buttonClose.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        buttonClose.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonClose.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }

    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: labelDescription, targetText: noteViewModel.updateLinkText(stringText: notesDetail.body!)) {
            guard let url = URL(string: noteViewModel.findURL(stringText: notesDetail.body!)) else { return }
            UIApplication.shared.open(url)
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
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, targetText: String) -> Bool {
        guard let attributedString = label.attributedText, let lblText = label.text else { return false }
        let targetRange = (lblText as NSString).range(of: targetText)
        //IMPORTANT label correct font for NSTextStorage needed
        let mutableAttribString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttribString.addAttributes(
            [NSAttributedString.Key.font: label.font ?? UIFont.smallSystemFontSize],
            range: NSRange(location: 0, length: attributedString.length)
        )
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableAttribString)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
