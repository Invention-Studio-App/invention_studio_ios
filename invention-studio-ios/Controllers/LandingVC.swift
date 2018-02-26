//
//  LandingVC.swift
//  invention-studio-ios
//
//  Created by Noah Sutter on 1/21/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class LandingVC: ISViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: "LoggedIn") {
            self.navigationItem.rightBarButtonItem = nil
        }

        /**
         ** Set Up  View
         **/

        //Set Up Image
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 16.0 * 9.0)
        //TODO: Use dynamic photo
        imageView.image = UIImage(named: "PlaceholderStudioImage")
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)

        //Set Up TextView
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.bounces = false
        textView.bouncesZoom = false
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 16)
        //TODO: Use dynamic text
        textView.text = "Is this the real life? Is this just fantasy? Caught in a landslide, no escape from reality. Open your eyes, look up to the skies and see... I'm just a poor boy, I need no sympathy. Because I'm easy come, easy go. Little high, little low. Everywhere the wind blows doesn't really matter to me. To me..."
        let textViewSize = textView.sizeThatFits(CGSize(width: view.frame.width - 16, height: CGFloat.greatestFiniteMagnitude))
        textView.frame = CGRect(x: 8, y: imageView.frame.maxY + 8, width: view.frame.width - 16, height: textViewSize.height)
        scrollView.addSubview(textView)

        //Set ScrollView content size
        scrollView.contentSize = CGSize(width: view.frame.width, height: textView.frame.maxY + 8)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

