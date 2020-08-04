import UIKit

struct ImageModel: Codable {
    var photos: Photos?
    var stat: String?
}

// MARK: - Photos
struct Photos: Codable {
    var page, pages, perpage: Int?
    var total: String?
    var photo: [Photo]?
}

// MARK: - Photo
struct Photo: Codable, PhotoURL {
    var id, owner, secret, server: String?
    var farm: Int?
    var title: String?
    var ispublic, isfriend, isfamily: Int?
}

protocol PhotoURL {}

extension PhotoURL where Self == Photo{
    
    func getImagePath() -> URL?{
        let path = "http://farm\(self.farm ?? 0).static.flickr.com/\(self.server ?? "")/\(self.id ?? "")_\(self.secret ?? "").jpg"
        return URL(string: path)
    }
    
}
