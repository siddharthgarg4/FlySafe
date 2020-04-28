//
//  DocumentsCollectionViewCell.swift
//  SecureTravel
//
//  Created by Siddharth on 15/09/19.
//  Copyright © 2019 Siddharth. All rights reserved.
//

import UIKit
import Onboard
import WSTagsField

class DocumentsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    let tagsField = WSTagsField()
    
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagsField.spaceBetweenLines = 5.0
        tagsField.spaceBetweenTags = 10.0
        tagsField.font = .systemFont(ofSize: 12.0)
        tagsField.backgroundColor = .white
        tagsField.tintColor = .green
        tagsField.textColor = .black
        tagsField.fieldTextColor = .blue
        tagsField.selectedColor = .black
        tagsField.selectedTextColor = .red
        tagsField.delimiter = ","
        tagsField.isDelimiterVisible = true
        tagsField.placeholderColor = .green
        tagsField.placeholderAlwaysVisible = true
        tagsField.keyboardAppearance = .dark
        tagsField.returnKeyType = .next
        tagsField.acceptTagOption = .space
        
        tagsField.onDidAddTag = { field, tag in
            print("DidAddTag", tag.text)
        }

        tagsField.onDidRemoveTag = { field, tag in
            print("DidRemoveTag", tag.text)
        }

        tagsField.onDidChangeText = { _, text in
            print("DidChangeText")
        }

        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo", height)
        }

        tagsField.onValidateTag = { tag, tags in
            // custom validations, called before tag is added to tags list
            return tag.text != "#" && !tags.contains(where: { $0.text.uppercased() == tag.text.uppercased() })
        }

        print("List of Tags Strings:", tagsField.tags.map({$0.text}))
    }
}
