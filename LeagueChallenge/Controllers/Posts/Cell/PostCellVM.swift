import Foundation

class PostCellVM: NSObject {
    var cell: PostCell.Type!
    var profileImage: String?
    var username: String?
    var title: String?
    var content: String?

    init(profileImage: String?, username: String?, title: String?, content: String?) {
        super.init()
        self.cell = PostCell.self
        self.profileImage = profileImage
        self.username = username
        self.title = title
        self.content = content
    }
    
    var reuseIdentifier: String {
        return cell.cellReuseIdentifier
    }
}
