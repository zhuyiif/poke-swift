//
//  PokeAPI.swift
//  pokemon-swift
//
//  Created by zack on 5/4/22.
//

import UIKit
import PokeAPI
class PokeManager {
    
    static let shared = PokeManager()
    var dataSource:[Pokemon] = []
    var imageCache:[String:UIImage] = [:]
    let queue = DispatchQueue(label: "my-queue", qos: .userInteractive)
    let total:Int = 200
    let pageSize:Int = 20
    private init() {
        
    }
    
    func getCount()->Int {
        return queue.sync {
            return self.dataSource.count
        }
    }
    
    func getItemByIndex(_ index:Int) -> Pokemon{
        return queue.sync{
            return self.dataSource[index]
        }
    }
    
    func getPokeUrlByIndex(_ index:IndexPath) -> String?{
        let index = index.row
        if(index >= self.dataSource.count) {
            return nil
        }
        return queue.sync{
            return self.dataSource[index].sprites.frontDefault.absoluteString
        }
    }
    
    func getImageFromCache(_ url:String) -> UIImage? {
        return queue.sync {
            var keyExists:Bool = false
            keyExists = imageCache[url] != nil
            if(keyExists) {
                return self.imageCache[url]!
            } else {
                return nil
            }
        }
    }
    
    func putImagetoCache(_ url:String, image:UIImage) {
        queue.sync {
            self.imageCache[url] = image
        }
    }
    
    func downloadImage(indexPath:IndexPath) -> UIImage?{
        let index = indexPath.row
        if(index >= self.dataSource.count) {
            return nil
        }
       // print("download (\(index)")
        let poke = self.dataSource[index]
        let url = poke.sprites.frontDefault.absoluteString
        
        if let image = getImageFromCache(url) {
            return image
        }
        
        ImageDownloader.getImage(withURL: poke.sprites.frontDefault) { result in
            switch result {
            case .success(let image):
                self.putImagetoCache(url, image: image)
                let nc = NotificationCenter.default
                var info:[String:IndexPath] = [:]
                info["data"] = indexPath
                DispatchQueue.main.async {
                    nc.post(name: Notification.Name("DownloadImage"), object: nil, userInfo: info)
                }
            case .failure(let error):
                print(error)
            }
        }
        return nil
    }
    
    func listPokemon(compeletion: @escaping () -> Void) {
        
            PokeAPI.listPokemon(limit: 30, offset: self.getCount()) { result in
                switch result {
                case .success(let pokemon):
                    print("-------")
                    print(pokemon)
                    self.queue.sync {
                        self.dataSource.append(contentsOf: pokemon)
                    }
                    print(self.dataSource.count)
                    DispatchQueue.main.async {
                        compeletion()
                    }
                    
                    
                case .failure(let error):
                    print(error)
                    return
                }
            }
            
        
    }
    
    
}
