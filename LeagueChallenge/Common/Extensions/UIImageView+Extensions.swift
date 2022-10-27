import AlamofireImage
import Alamofire
import UIKit

extension UIImageView {

    static func prepareImagesCache() {
        let imageCache = AutoPurgingImageCache(
            memoryCapacity: 900 * 1024 * 1024,
            preferredMemoryUsageAfterPurge: 600 * 1024 * 1024
        )

        UIImageView.af.sharedImageDownloader = ImageDownloader(
            configuration: ImageDownloader.defaultURLSessionConfiguration(),
            downloadPrioritization: .fifo,
            maximumActiveDownloads: 10,
            imageCache: imageCache
        )
    }

    func setImageWithActivityIndicator(withUrl url: URL,
                                       placeholder: UIImage? = nil,
                                       removeCache: Bool = false,
                                       transition: ImageTransition = .crossDissolve(0.2),
                                       success: ((UIImage?) -> Void)? = nil,
                                       failure: ((Error) -> Void)? = nil) {

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .gray
        addSubview(activityIndicator)
        activityIndicator.startAnimating()

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0))
        
        self.image = placeholder
        AF.request(url).responseImage { response in
            activityIndicator.removeFromSuperview()
            if let error = response.error {
                failure?(error)
            } else {
                self.image = response.value
                success?(self.image)
            }
        }
    }
}
