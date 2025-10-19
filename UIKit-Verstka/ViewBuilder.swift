import UIKit

class ViewBuilder{
	static let shared = ViewBuilder()
	private init() {}
	
	lazy var bannerImage: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		image.widthAnchor.constraint(equalToConstant: 178).isActive = true
		image.heightAnchor.constraint(equalToConstant: 178).isActive = true
		

		return image
	}()
	
	lazy var contentView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 50
		view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
		return view
	}()
}
