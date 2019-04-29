//
//  ImageViewController.swift
//  Cassini
//
//  Created by Michael Chapman on 4/28/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController
{
    var imageURL: URL? {
        didSet {
            imageView.image = nil
            
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    private func fetchImage() {
        if let url = imageURL {
            let urlContents = try? Data(contentsOf: url)
            
            if let imageData = urlContents {
                imageView.image = UIImage(data: imageData)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imageURL == nil {
            imageURL = DemoURLs.stanford
        }
    }
}
