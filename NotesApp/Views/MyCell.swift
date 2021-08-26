//
//  MyCellCollectionViewCell.swift
//  NotesApp
//
//  Created by SIVA on 20/03/21.
//

import UIKit

class MyCell: UICollectionViewCell {
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        //setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    fileprivate func setupViews(viewModeldetail : ViewModel, indexPath : IndexPath) {
        
        contentView.addSubview(imageView)

        if(viewModeldetail.arrayOfNotesList[indexPath.row].image != ""){
        }

        contentView.addSubview(label)
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        label.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true

        contentView.addSubview(labeldate)
        labeldate.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        labeldate.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        labeldate.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true

        contentView.addSubview(button)
        button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: labeldate.bottomAnchor, constant: 10).isActive = true
        

        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 10).isActive = true
        }
        let height : CGFloat = self.frame.size.height
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
    }
    
    func configure(viewModeldetail : ViewModel, indexPath : IndexPath) {
        viewModeldetail.index = (viewModeldetail.index > viewModeldetail.arrayOfColor.count) ? 0 : viewModeldetail.index

        let milisecond = Double(viewModeldetail.arrayOfNotesList[indexPath.row].time!)
        let date = Date(timeIntervalSince1970: (milisecond! / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        //imageView.isHidden = true

        if(viewModeldetail.arrayOfNotesList[indexPath.row].image != ""){
            //imageView.isHidden = false
            if(viewModeldetail.arrayOfNotesList[indexPath.row].isLocal) {
                let fileUrl = URL(fileURLWithPath: viewModeldetail.arrayOfNotesList[indexPath.row].image)
                let data = NSData(contentsOf: fileUrl)
                imageView.image = UIImage(data: data! as Data)
            }
            else {
                imageView.loadImage(withURL: viewModeldetail.arrayOfNotesList[indexPath.row].image, placeholderFor: "02") { [self] (image) in
                    imageView.image = image
                }
            }
        }
        label.text = viewModeldetail.arrayOfNotesList[indexPath.row].title
        labeldate.text = dateFormatter.string(from: date)
        button.tag = indexPath.row
        setupViews(viewModeldetail: viewModeldetail, indexPath : indexPath)
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.alpha = 1.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(ViewController.selectNotes(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let labeldate: UILabel = {
        let labeldate = UILabel()
        labeldate.backgroundColor = .clear
        labeldate.numberOfLines = 0
        labeldate.textColor = .gray
        labeldate.textAlignment = .left
        labeldate.font = UIFont(name: "HelveticaNeue", size: 18)
        labeldate.translatesAutoresizingMaskIntoConstraints = false
        return labeldate
    }()
        
}
