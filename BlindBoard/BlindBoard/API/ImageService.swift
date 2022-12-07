//
//  ImageService.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/26.
//

import UIKit

struct ImageService {
    
    static func imagesFetch(word: String, completion: @escaping(UIImage) -> Void) {
        let word = ImageService.eraseWhiteSpace(word)
        let search = "https://api.pexels.com/v1/search?query=\(word)&per_page=3"
        guard let url = URL(string: search) else { return print("URL ERROR") }
        var request = URLRequest(url: url)
        request.addValue(AUTH.USER_AUTH_KEY, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return print("DEBUG: DATA ERROR \(String(describing: data?.description))") }
            if let error = error {
                print("ERROR IN URLSESSION: \(error.localizedDescription)")
            }
            guard let imageData = try? JSONDecoder().decode(Img.self, from: data) else { return }
            guard let photo = imageData.photos else { return }
            if photo.count != 0 {
                guard let photoFirst = photo.first else { return }
                guard let realurl = URL(string: photoFirst.src?.original ?? "") else { return print("realURL ERROR") }
                if let imageReal = try? Data(contentsOf: realurl) {
                    guard let image = UIImage(data: imageReal) else { return }
                    completion(image)
                }
            } else {
                completion(UIImage())
            }
        }
        .resume()
        
    }
    
    static func eraseWhiteSpace(_ word: String) -> String {
        var temp: String = ""
        for i in word {
            if i == " " {
                continue
            }
            temp += String(i)
        }
        return temp
    }
}
