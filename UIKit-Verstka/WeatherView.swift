import UIKit

class WeatherView: UIViewController { //error Invalid redeclaration of 'ViewController'
	
	private let build = ViewBuilder.shared
	
	private let bannerImage = ViewBuilder.shared.bannerImage
	private let tempLabel = UILabel()
	private let cityLabel = UILabel()
	private let refreshButton = UIButton(type: .system)
	private let weatherDescription = UILabel()
	private let contentView = ViewBuilder.shared.contentView
	private let cityTextField = UITextField()
	
	
	//API
	
	private let apiKey = "1e3eef1d7f9da9c80d5c0eeaa6de89b5"
	private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		setBannerImage()
		setTempLabel()
		setContentView()
		setRefreshButton()
		setCityTextField()
		refreshWeather()
		let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		view.addGestureRecognizer(tap)
	}
	
	private func setBannerImage() {
		bannerImage.image = UIImage(systemName: "sun.max.fill")
		bannerImage.tintColor = .yellow
		bannerImage.contentMode = .scaleAspectFit
		view.addSubview(bannerImage)
		
		NSLayoutConstraint.activate([
			bannerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			bannerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
		])
	}
	
	private func setTempLabel() {
		tempLabel.text = "19°C"
		tempLabel.font = .systemFont(ofSize: 36, weight: .bold)
		tempLabel.textColor = .black
		tempLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tempLabel)
		
		NSLayoutConstraint.activate([
			tempLabel.topAnchor.constraint(equalTo: bannerImage.bottomAnchor, constant: 20),
			tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
	
	private func setContentView() {
		view.addSubview(contentView)
		
		contentView.backgroundColor = .white
		// City Label
		cityLabel.text = "Astana"
		cityLabel.font = .systemFont(ofSize: 24, weight: .medium)
		cityLabel.textColor = .black
		cityLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(cityLabel)
		
		NSLayoutConstraint.activate([
			cityLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor,constant: 10)
		])
		
		// Weather Description Label
		weatherDescription.text = "Sunny"
		weatherDescription.textColor = .black
		weatherDescription.font = .systemFont(ofSize: 18)
		weatherDescription.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(weatherDescription) // Исправление: добавляем в contentView
		
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
	
	// Search city
	private func setCityTextField(){
		cityTextField.placeholder = "Enter city"
		cityTextField.borderStyle = .roundedRect
		cityTextField.backgroundColor = .gray
		cityTextField.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(cityTextField)
		
		NSLayoutConstraint.activate([
			cityTextField.topAnchor.constraint(equalTo: weatherDescription.bottomAnchor, constant: 50),
			cityTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
			cityTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
			cityTextField.widthAnchor.constraint(equalToConstant: 120),
			cityTextField.heightAnchor.constraint(equalToConstant: 44)
		])
	}
	private func setRefreshButton() {
		refreshButton.setTitle("Update", for: .normal)
		refreshButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
		refreshButton.setTitleColor(.white, for: .normal)
		refreshButton.backgroundColor = .progBlue
		refreshButton.layer.cornerRadius = 10
		refreshButton.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(refreshButton)
		
		NSLayoutConstraint.activate([
			refreshButton.topAnchor.constraint(equalTo: weatherDescription.bottomAnchor, constant: 200),
			refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			refreshButton.widthAnchor.constraint(equalToConstant: 120),
			refreshButton.heightAnchor.constraint(equalToConstant: 44)
		])
		
		refreshButton.addTarget(self, action: #selector(refreshWeather), for: .touchUpInside)
	}
	
	@objc func refreshWeather() {
		let city = cityTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == false ? cityTextField.text! : "Astana"
		
		// Формируем URL с экранированием символов
		guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
			  let url = URL(string: "\(baseURL)?q=\(encodedCity)&appid=\(apiKey)&units=metric") else {
			showErrorAlert(message: "Invalid city name")
			return
		}
		
		// Сетевой запрос
		URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			guard let self = self else { return }
			
			if let error = error {
				DispatchQueue.main.async {
					self.showErrorAlert(message: "Network error: \(error.localizedDescription)")
				}
				return
			}
			
			guard let data = data else {
				DispatchQueue.main.async {
					self.showErrorAlert(message: "No data received")
				}
				return
			}
			
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
				
				DispatchQueue.main.async {
					// Проверяем, есть ли ошибка в ответе API
					if let cod = json?["cod"] as? Int, cod != 200,
					   let message = json?["message"] as? String {
						self.showErrorAlert(message: "API error: \(message)")
						return
					}
					
					// Температура
					if let main = json?["main"] as? [String: Any],
					   let temp = main["temp"] as? Double {
						self.tempLabel.text = "\(Int(temp))°C"
					}
					
					// Город
					if let city = json?["name"] as? String {
						self.cityLabel.text = city
					}
					
					// Описание погоды и иконка
					if let weatherArray = json?["weather"] as? [[String: Any]],
					   let weather = weatherArray.first,
					   let description = weather["description"] as? String,
					   let icon = weather["icon"] as? String {
						self.weatherDescription.text = description.capitalized
						
						let symbolName: String
						switch icon {
						case "01d", "01n":
							symbolName = "sun.max.fill"
						case "02d", "02n", "03d", "03n", "04d", "04n":
							symbolName = "cloud.fill"
						case "09d", "09n", "10d", "10n":
							symbolName = "cloud.rain.fill"
						case "11d", "11n":
							symbolName = "cloud.bolt.fill"
						case "13d", "13n":
							symbolName = "snowflake"
						case "50d", "50n":
							symbolName = "cloud.fog.fill"
						default:
							symbolName = "cloud"
						}
						self.bannerImage.image = UIImage(systemName: symbolName)
						self.bannerImage.tintColor = .yellow
					}
				}
			} catch {
				DispatchQueue.main.async {
					self.showErrorAlert(message: "JSON parsing error: \(error.localizedDescription)")
				}
			}
		}.resume()
	}
	
	// Метод для отображения ошибок
	private func showErrorAlert(message: String) {
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)
	}
	
	@objc func hideKeyboard(){
		view.endEditing(true)
	}
}


