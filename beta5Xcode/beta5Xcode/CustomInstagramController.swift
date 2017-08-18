//
//  CustomInstagramController.swift
//  beta5Xcode
//
//  Created by Akash on 18/08/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CustomInstaCell"

class CustomInstagramController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        clearsSelectionOnViewWillAppear = false
        collectionView?.isScrollEnabled = true
    }
    
    // MARK: UICollectionViewDataSource



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 6
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomInstaCell
    
        // Configure the cell
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 150

        var row = 0
        var columns = 2
        
        var i = 0
        
        while i <= indexPath.row {
            
            if row % 2 == 0 {
                columns = 2
            }else{
                columns = 1
            }
            
            i += columns
            row += 1
        }
        let width: CGFloat = ( UIScreen.main.bounds.width - CGFloat(5 * (columns - 1) ) ) / CGFloat(columns)
        print("IndexPath :: \(indexPath.row) ::: row : \(row) column :\(columns) width:\(width)")
        if columns == 1{
                return CGSize(width: 150 , height: height)
        } else{
            return CGSize(width: width , height: height)
        }
        
    }
    

}
