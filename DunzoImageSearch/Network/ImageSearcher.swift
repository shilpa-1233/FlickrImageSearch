import UIKit

public class ImageSearcher {
    
    func searchForTerm(term: String, page: Int,  completion: @escaping (_ results: ImageModel?, _ error: NSError?) -> Void){
        
        let URLString = "https://api.flickr.com/services/rest/"
        var urlComponents = URLComponents(string: URLString)
        urlComponents?.queryItems = [
            "method": "flickr.photos.search",
            "api_key": "062a6c0c49e4de1d78497d13a7dbb360",
            "text": term.replacingOccurrences(of: " ", with: ""),
            "format": "json",
            "nojsoncallback": "1",
            "per_page": "20",
            "page": "\(page)"
            ].map { (key, value) in
                URLQueryItem(name: key, value: value)}
        
        
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completion(nil, error as NSError?)
                return
            }
            
            let jsonError : NSError? = error as NSError?
            let resultsDictionary = try! JSONDecoder.init().decode(ImageModel.self, from: data!)
            if jsonError != nil {
                completion(nil, jsonError)
                return
            }
            
            completion(resultsDictionary, nil)
            
        }).resume()
    }
}
