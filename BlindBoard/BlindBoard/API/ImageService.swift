//
//  ImageService.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/26.
//

import UIKit

struct ImageService {
    
    static func imagesFetch(word: String, completion: @escaping(UIImage) -> Void) {
        let search = "https://api.pexels.com/v1/search?query=\(word)"
        
        guard let url = URL(string: search) else { return print("URL ERROR")}
        var request = URLRequest(url: url)
        request.addValue(AUTH.USER_AUTH_KEY, forHTTPHeaderField: "Authorization")
        URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let error = error {
                print("ERROR IN URLSESSION: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                guard let imageData = try? JSONDecoder().decode(Img.self, from: data) else { return }
                guard let photos = imageData.photos else { return }
                guard let photo = imageData.photos else { return }
                if photo.count != 0 {
                    guard let photoFirst: ImgInfo? = photo[0] else { return }
                    guard let realurl = URL(string: photoFirst?.src?.original ?? "") else { return print("realURL ERROR") }
                    if let imageReal = try? Data(contentsOf: realurl) {
                        guard let image = UIImage(data: imageReal) else { return }
                        completion(image)
                    }
                }
            }
        }.resume()
        
    }
}
