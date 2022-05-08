//
//  ViewController.swift
//  pokemon-swift
//
//  Created by zack on 5/4/22.
//



import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    private let itemsPerRow: CGFloat = 3
    
    private let sectionInsets = UIEdgeInsets(
        top: 0.0,
        left: 0,
        bottom: 0.0,
        right: 0.0)
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PokeManager.shared.getCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // print(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath) as! PokeCell
        let image = PokeManager.shared.downloadImage(indexPath: indexPath)
        if let image = image {
            cell.imageView.image = image
        }
     
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = PokeManager.shared.downloadImage(indexPath: indexPath)
        self.detailImageView.image = image
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var detailImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let mgr:PokeManager = PokeManager.shared
        mgr.listPokemon(compeletion: {
            self.collectionView.reloadData()
        })
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(imageDownloadEvent(_ :)), name: Notification.Name("DownloadImage"), object: nil)
        
    }
    
    @objc func imageDownloadEvent(_ noti: Notification) {
        if let data = noti.userInfo as? [String: IndexPath] {
            for (_, indexpath) in data {
                print(indexpath)
                self.collectionView.reloadItems(at: [indexpath])
            }
        }
    }
    
}



extension ViewController: UICollectionViewDelegateFlowLayout {
    // 1
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let itemWidth = collectionView.bounds.size.width / 3
        return CGSize(width: itemWidth, height: itemWidth)
        

    }
    
    // 3
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}
