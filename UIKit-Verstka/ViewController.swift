import UIKit

class ViewController: UIViewController {
	private let build = ViewBuilder.shared
	
	private let bannerImage = ViewBuilder.shared.bannerImage
	private let tempLabel = UILabel()
	private let cityLabel = UILabel()
	private let refreshButton = UIButton(type: .system)
	private let weatherDescription = UILabel()
	private let contentView = ViewBuilder.shared.contentView
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .progBlue
		
		setBannerImage()
		setTempLabel()
		setContentView()
		setRefreshButton()
		//
	}
	
	private func setBannerImage() {
		bannerImage.image = UIImage(systemName: "sun.max.fill")
		bannerImage.contentMode = .scaleAspectFit
		bannerImage.tintColor = .yellow
		view.addSubview(bannerImage)
		
		NSLayoutConstraint.activate([
			bannerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			bannerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
		])
	}
	
	private func setTempLabel() {
		tempLabel.text = "19°C"
		tempLabel.font = .systemFont(ofSize: 36, weight: .bold)
		tempLabel.textColor = .white
		tempLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tempLabel)
		
		NSLayoutConstraint.activate([
			tempLabel.topAnchor.constraint(equalTo: bannerImage.bottomAnchor, constant: 20),
			tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
	
	private func setContentView() {
		view.addSubview(contentView)
		
		// City Label
		cityLabel.text = "Astana"
		cityLabel.font = .systemFont(ofSize: 24, weight: .medium)
		cityLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(cityLabel)
		
		// Weather Description Label
		weatherDescription.text = "Sunny"
		weatherDescription.font = .systemFont(ofSize: 18)
		weatherDescription.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(weatherDescription) // Исправление: добавляем в contentView
		
		// Constraints для contentView
		NSLayoutConstraint.activate([
			contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
			contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
			contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
			contentView.heightAnchor.constraint(equalToConstant: 0) // Уменьшил высоту, так как только тексты
		])
		
		// Constraints для cityLabel внутри contentView
		NSLayoutConstraint.activate([
			cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
			cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
		])
		
		// Constraints для weatherDescription внутри contentView
		NSLayoutConstraint.activate([
			weatherDescription.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
			weatherDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			weatherDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
		])
	}
	
	private func setRefreshButton() {
		refreshButton.setTitle("Update", for: .normal)
		refreshButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
		refreshButton.setTitleColor(.white, for: .normal)
		refreshButton.backgroundColor = .purple
		refreshButton.layer.cornerRadius = 10
		refreshButton.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(refreshButton)
		
		NSLayoutConstraint.activate([
			refreshButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -60),
			refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			refreshButton.widthAnchor.constraint(equalToConstant: 120),
			refreshButton.heightAnchor.constraint(equalToConstant: 44)
		])
		
		refreshButton.addTarget(self, action: #selector(refreshWeather), for: .touchUpInside)
	}
	
	@objc func refreshWeather() {
		cityLabel.text = "Astana"
		tempLabel.text = "19°C"
		weatherDescription.text = "Sunny"
		bannerImage.image = UIImage(systemName: "sun.max.fill")
	}
}
