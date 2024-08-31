//
//  StorageManerger.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/30.
//

import Foundation
import FirebaseStorage
import Combine
import UIKit

class StorageManager {
    
    static let shared = StorageManager()
    
    func uploadImage(_ image: UIImage, path: String) -> AnyPublisher<String, Error> {
        return Future { promise in
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            
            Storage.storage().reference().child(path).putData(imageData, metadata: nil) { (_, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    Storage.storage().reference().child(path).downloadURL { (url, error) in
                        if let error = error {
                            promise(.failure(error))
                        } else if let downloadURL = url?.absoluteString {
                            promise(.success(downloadURL))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func downloadImage(from path: String) -> AnyPublisher<Data, Error> {
        return Future{ promise in
            Storage.storage().reference().child(path).getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = data {
                    promise(.success(data))
                } else {
                    promise(.failure(NSError(domain: "error", code: -1, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
