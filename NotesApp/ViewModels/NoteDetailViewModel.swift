//
//  NoteDetailViewModel.swift
//  NotesApp
//
//  Created by SIVA on 20/03/21.
//

import UIKit

class NoteDetailViewModel: NSObject {

    var notesDetails : NotesList_Base!
    var arrayOfNotesList : [NotesList_Base] = []

    func loadImage(imageView : UIImageView){
        if(notesDetails.isLocal) {
            if(notesDetails.image != ""){
                let fileUrl = URL(fileURLWithPath: notesDetails.image)
                let data = NSData(contentsOf: fileUrl)
                imageView.image = UIImage(data: data! as Data)
            }
        }
        else {
            imageView.loadImage(withURL: notesDetails.image, placeholderFor: "02") { (image) in
                imageView.image = image
            }
        }
    }
    
    func loadImageWithDetail(imageView : UIImageView, notes : NotesList_Base){
        if(notes.isLocal) {
            let fileUrl = URL(fileURLWithPath: notes.image)
            let data = NSData(contentsOf: fileUrl)
            imageView.image = UIImage(data: data! as Data)
        }
        else {
            imageView.loadImage(withURL: notes.image, placeholderFor: "02") { (image) in
                imageView.image = image
            }
        }
    }

    func loadBannerImages(scrollView : UIScrollView, image : UIImage) {
        var floatWidth : CGFloat = 0
        var index : Int = 0
        var page : Int = 0
        for notes in arrayOfNotesList {
            if(self.notesDetails.image == notes.image) {
                page = index
            }
            if(notes.image != ""){
                let imageview = UIImageView()
                imageview.backgroundColor = .clear
                imageview.contentMode = .scaleAspectFit
                imageview.layer.masksToBounds = true
                imageview.frame = scrollView.bounds
                imageview.frame.origin.x = floatWidth
                if(index == 0){
                    imageview.image = image
                }
                self.loadImageWithDetail(imageView: imageview, notes: notes)
                scrollView.addSubview(imageview)
                floatWidth = floatWidth + UIScreen.main.bounds.width
                index = index + 1
            }
        }
        scrollView.setContentOffset(CGPoint(x: (CGFloat(page) * UIScreen.main.bounds.width), y: 0), animated: false)
        scrollView.contentSize =  CGSize(width: floatWidth, height: UIScreen.main.bounds.height)
    }
    
    func removeStar(stringText : String)-> String {
        var stringValue : String = stringText.replacingOccurrences(of: "**", with: "")
        stringValue = stringValue.replacingOccurrences(of: "[", with: "")
        stringValue = stringValue.replacingOccurrences(of: "]", with: "")
        stringValue = stringValue.replacingOccurrences(of: "(", with: "")
        stringValue = stringValue.replacingOccurrences(of: ")", with: "")
        stringValue = stringValue.replacingOccurrences(of: self.findURL(stringText: stringText), with: "")
        return stringValue
    }

    func updateLableText(stringText : String)-> String {
        let stringValue = stringText.startingSplit().endingSplit()
        return stringValue
    }
    
    func updateLinkText(stringText : String)-> String {
        let stringValue = stringText.startingLinkSplit().endingLnkSplit()
        return stringValue
    }
    
    func findURL(stringText : String)-> String {
        let input = stringText
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let url = input[range]
            print(url)
            return String(url)
        }
        return ""
    }
    
    func attributedLabelText(text: String, highlight h1: String, underLine stringUnderLine: String, hyperUrl hyperLink: String, size : CGFloat, FontName : String, color : UIColor) -> NSMutableAttributedString {
        let string = text as NSString
        let stringAttr: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        let range: NSRange = string.range(of: h1)
        stringAttr.addAttribute(NSAttributedString.Key.font, value: UIFont(name: FontName, size: size)!, range: NSMakeRange(range.location, range.length))
        stringAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(range.location, range.length))
        
        let rangeLink = string.range(of: stringUnderLine)
        stringAttr.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: rangeLink)
        return stringAttr
    }

}
extension String
{
    func startingSplit() -> String {
        let range = self.range(of: "**")
        if(range != nil){
            let indexTag: Int = self.distance(from: self.endIndex, to: range!.lowerBound)
            let index = self.index(self.endIndex, offsetBy: indexTag)
            var mySubstring : String = String(self[index...])
            mySubstring = String(mySubstring.dropFirst(2))
            return mySubstring
        }
        return ""
    }
    func endingSplit() -> String {
        let range = self.range(of: "**")
        if(range != nil){
            let indexTag: Int = self.distance(from: self.startIndex, to: range!.lowerBound)
            let index = self.index(self.startIndex, offsetBy: indexTag)
            let mySubstring : String = String(self[..<index])
            return mySubstring
        }
        return ""
    }

    func startingLinkSplit() -> String {
        let range = self.range(of: "[")
        if(range != nil){
            let indexTag: Int = self.distance(from: self.endIndex, to: range!.lowerBound)

            let index = self.index(self.endIndex, offsetBy: indexTag)
            var mySubstring : String = String(self[index...])
            mySubstring = String(mySubstring.dropFirst(1))
            return mySubstring
        }
        return ""
    }
    func endingLnkSplit() -> String {
        let range = self.range(of: "]")
        if(range != nil){
            let indexTag: Int = self.distance(from: self.startIndex, to: range!.lowerBound)

            let index = self.index(self.startIndex, offsetBy: indexTag)
            let mySubstring : String = String(self[..<index])
            return mySubstring
        }
        return ""
    }
}
