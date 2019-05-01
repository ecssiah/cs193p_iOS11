//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Michael Chapman on 4/29/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIScrollViewDelegate, UIDropInteractionDelegate
{
    var imageFetcher: ImageFetcher!
    
    var emojiArtView = EmojiArtView()
    
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return emojiArtView
    }
    
    var emojiArtBackgroundImage: UIImage? {
        get {
            return emojiArtView.backgroundImage
        }
        set {
            scrollView?.zoomScale = 1.0
            emojiArtView.backgroundImage = newValue
            
            let size = newValue?.size ?? CGSize.zero
            emojiArtView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            
            scrollViewHeight?.constant = size.height
            scrollViewWidth?.constant = size.width

            if let dropZone = self.dropZone, size.width > 0, size.height > 0 {
                scrollView?.zoomScale = max(
                    dropZone.bounds.size.width / size.width,
                    dropZone.bounds.size.height / size.height
                )
            }
        }
    }
    
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    func dropInteraction(
        _ interaction: UIDropInteraction,
        canHandle session: UIDropSession
    ) -> Bool {
        return (
            session.canLoadObjects(ofClass: NSURL.self) &&
            session.canLoadObjects(ofClass: UIImage.self)
        )
    }
    
    func dropInteraction(
        _ interaction: UIDropInteraction,
        sessionDidUpdate session: UIDropSession
    ) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(
        _ interaction: UIDropInteraction,
        performDrop session: UIDropSession
    ) {
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtBackgroundImage = image
            }
        }
        
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            if let url = nsurls.first as? URL {
                self.imageFetcher.fetch(url)
            }
        }
        
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage {
                self.imageFetcher.backup = image
            }
        }
    }
}
