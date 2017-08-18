//
//  ViewController.swift
//  beta5Xcode
//
//  Created by Akash on 17/08/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIDropInteractionDelegate,UIDragInteractionDelegate {
    
    var abc : (UITapGestureRecognizer)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addInteraction(UIDropInteraction(delegate: self))
        view.addInteraction(UIDragInteraction(delegate: self))
        
    }
    //MARK:-  drop item
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        for dragItem in session.items{
            dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (obj, err) in
                if let err = err {
                    print("Failed to load",err)
                    return
                }
                guard let draggedImage = obj as? UIImage else {
                    return
                }
                
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: draggedImage)
                    imageView.isUserInteractionEnabled = true
                    self.view.addSubview(imageView)
                    imageView.frame = CGRect(x: 0, y: 0, width: draggedImage.size.width, height: draggedImage.size.height)
                    let centerPoint = session.location(in: self.view)
                    imageView.center = centerPoint
                }
                
                
            })
        }
    }
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    //MARK:- drag item
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let touchedPoint = session.location(in: self.view)
        if let touchedImageVIew = self.view.hitTest(touchedPoint, with: nil) as? UIImageView{
            let touchedImage = touchedImageVIew.image
            let itemProvider = NSItemProvider(object: touchedImage!)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = touchedImageVIew
            return [dragItem]
        }
        return []
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        session.items.forEach({ dragItem in
            if let touchedImageView = dragItem.localObject as? UIView{
                touchedImageView.removeFromSuperview()
            }
            
        })
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating) {
        self.view.addSubview(item.localObject as! UIView)
    }
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        return UITargetedDragPreview(view: item.localObject as! UIView)
    }
}

