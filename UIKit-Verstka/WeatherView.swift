import UIKit

class WeatherView: UIViewController {

	// MARK: - UI Elements
	private let bannerImage = UIImageView()
	private let tempLabel = UILabel()
	private let tempLabelFahrenheit = UILabel()
	private let cityLabel = UILabel()
	private let weatherDescription = UILabel()
	private let cityTextField = UITextField()
	private let refreshButton = UIButton(type: .system)
	private let backgroundEffectView = UIView()
	private let adviceMessage = UILabel()
	private let weatherImageView = UIImageView()

	// API
	private let apiKey = "1e3eef1d7f9da9c80d5c0eeaa6de89b5"
	private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupConstraints()
		setupDelegates()
		setupGestures()
		refreshWeather()
	}

	// MARK: - Setup UI
	private func setupUI() {
		view.backgroundColor = .progBackground
		setupBackground()
		setupBanner()
		setupLabels()
		setupTextField()
		setupButton()
		
	}

	private func setupBackground() {
		backgroundEffectView.translatesAutoresizingMaskIntoConstraints = false
		view.insertSubview(backgroundEffectView, at: 0)

		let gradient = CAGradientLayer()
		gradient.frame = view.bounds
		gradient.colors = [
			UIColor.progBlue.cgColor,
			UIColor.progAshyqKok.cgColor,
			UIColor.progOteAshyqKok.cgColor,
			UIColor.progBackground.cgColor
		]
		gradient.startPoint = CGPoint(x: 0.5, y: 0)
		gradient.endPoint = CGPoint(x: 0.5, y: 1)
		backgroundEffectView.layer.insertSublayer(gradient, at: 0)
	}

	private func setupBanner() {
		bannerImage.image = UIImage(systemName: "sun.max.fill")
		bannerImage.tintColor = .progSun
		bannerImage.contentMode = .scaleAspectFit
		bannerImage.addSymbolEffect(.pulse)
		bannerImage.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(bannerImage)
	}

	private func setupLabels() {
		tempLabel.font = .systemFont(ofSize: 36, weight: .bold)
		tempLabel.textColor = .progText
		tempLabel.textAlignment = .right
		tempLabel.text = "--°C"

		tempLabelFahrenheit.font = .systemFont(ofSize: 24, weight: .bold)
		tempLabelFahrenheit.textColor = .progText
		tempLabelFahrenheit.textAlignment = .right
		tempLabelFahrenheit.text = "--°F"

		cityLabel.font = .systemFont(ofSize: 24, weight: .medium)
		cityLabel.textColor = .progText
		cityLabel.text = "City"

		weatherDescription.font = .systemFont(ofSize: 18, weight: .medium)
		weatherDescription.textColor = .progText
		weatherDescription.text = "Description"
		weatherDescription.numberOfLines = 0

		adviceMessage.font = .systemFont(ofSize: 16, weight: .regular)
		adviceMessage.textColor = .progText
		adviceMessage.textAlignment = .right
		adviceMessage.text = "Loading..."

		[tempLabel, tempLabelFahrenheit, cityLabel, weatherDescription, adviceMessage].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
	}

	private func setupTextField() {
		cityTextField.placeholder = "Enter city"

		cityTextField.borderStyle = .roundedRect
		cityTextField.backgroundColor = .lightGray
		cityTextField.returnKeyType = .go
		cityTextField.clearButtonMode = .whileEditing
		cityTextField.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(cityTextField)
	}

	private func setupButton() {
		refreshButton.setTitle("Update", for: .normal)
		refreshButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
		refreshButton.setTitleColor(.progText, for: .normal)
		refreshButton.backgroundColor = .progBackground
		refreshButton.layer.cornerRadius = 12
		refreshButton.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(refreshButton)
		refreshButton.addTarget(self, action: #selector(refreshWeather), for: .touchUpInside)
	}



	// MARK: - Constraints
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			// Background
			backgroundEffectView.topAnchor.constraint(equalTo: view.topAnchor),
			backgroundEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			backgroundEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			backgroundEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			// Banner
			bannerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			bannerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
			bannerImage.widthAnchor.constraint(equalToConstant: 120),
			bannerImage.heightAnchor.constraint(equalToConstant: 100),

			// Temperature
			tempLabel.centerYAnchor.constraint(equalTo: bannerImage.centerYAnchor, constant: -10),
			tempLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

			tempLabelFahrenheit.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 4),
			tempLabelFahrenheit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

			adviceMessage.topAnchor.constraint(equalTo: tempLabelFahrenheit.bottomAnchor, constant: 4),
			adviceMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

			// City & Description
			cityLabel.topAnchor.constraint(equalTo: bannerImage.bottomAnchor, constant: 30),
			cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

			weatherDescription.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
			weatherDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
			weatherDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

			// Text Field
			cityTextField.topAnchor.constraint(equalTo: weatherDescription.bottomAnchor, constant: 30),
			cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
			cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
			cityTextField.heightAnchor.constraint(equalToConstant: 50),

			// Button
			refreshButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
			refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
			refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
			refreshButton.heightAnchor.constraint(equalToConstant: 50),


		
		])
	}

	// MARK: - Delegates & Gestures
	private func setupDelegates() {
		cityTextField.delegate = self
	}

	private func setupGestures() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		view.addGestureRecognizer(tap)
	}

	// MARK: - Weather Logic
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
					   let tempC = main["temp"] as? Double {
						self.tempLabel.text = "\(Int(tempC))°C"
						self.tempLabelFahrenheit.text = "\(Int(tempC * 9/5 + 32))°F"
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
							self.bannerImage.tintColor = .yellow
							self.adviceMessage.text = "Cмело жүре бер"
							
						case "02d", "02n", "03d", "03n", "04d", "04n":
							symbolName = "cloud.fill"
							self.bannerImage.tintColor = .white
							
						case "09d", "09n", "10d", "10n":
							symbolName = "cloud.rain.fill"
							self.bannerImage.tintColor = .gray
							self.adviceMessage.text = "Возьми зонт"
						case "11d", "11n":
							symbolName = "cloud.bolt.fill"
							self.bannerImage.tintColor = .darkGray
							
						case "13d", "13n":
							symbolName = "snowflake"
							self.bannerImage.tintColor = .gray
							
						case "50d", "50n":
							symbolName = "cloud.fog.fill"
							self.bannerImage.tintColor = .gray
							
						default:
							symbolName = "cloud"
						}
						self.bannerImage.image = UIImage(systemName: symbolName)
					}
				}
			} catch {
				DispatchQueue.main.async {
					self.showErrorAlert(message: "JSON parsing error: \(error.localizedDescription)")
				}
			}
		}.resume()
	}

	private func updateWeatherIcon(icon: String) {
		let symbolName: String
		switch icon {
		case "01d", "01n": symbolName = "sun.max.fill"; bannerImage.tintColor = .yellow
		case "02d", "02n", "03d", "03n", "04d", "04n": symbolName = "cloud.fill"; bannerImage.tintColor = .white
		case "09d", "09n", "10d", "10n": symbolName = "cloud.rain.fill"; bannerImage.tintColor = .gray
		case "11d", "11n": symbolName = "cloud.bolt.fill"; bannerImage.tintColor = .darkGray
		case "13d", "13n": symbolName = "snowflake"; bannerImage.tintColor = .white
		case "50d", "50n": symbolName = "cloud.fog.fill"; bannerImage.tintColor = .lightGray
		default: symbolName = "cloud"
		}
		bannerImage.image = UIImage(systemName: symbolName)
	}

	private func updateAdvice(temp: Double, icon: Any?) {
		let iconStr = (icon as? [String: Any])?.first?.value as? String ?? ""
		let isRainy = ["09d", "09n", "10d", "10n"].contains(iconStr)
		let isSnowy = ["13d", "13n"].contains(iconStr)

		let advice: String
		switch temp {
		case ..<0:
			advice = "Одевайся очень тепло! Шапка, шарф, перчатки."
		case 0..<10:
			advice = isSnowy ? "Снег! Теплая куртка и сапоги." : "Холодно. Одевай куртку и шапку."
		case 10..<18:
			advice = isRainy ? "Дождь. Возьми зонт и ветровку." : "Прохладно. Свитер или лёгкая куртка."
		case 18..<25:
			advice = isRainy ? "Тепло, но дождь. Зонт + футболка." : "Отлично! Футболка и джинсы."
		case 25..<30:
			advice = "Жарко! Лёгкая одежда, кепка, вода."
		default:
			advice = "Очень жарко! Пей воду, избегай солнца."
		}
		adviceMessage.text = advice
	}

	// MARK: - Actions
	@objc private func hideKeyboard() {
		view.endEditing(true)
	}

	private func showErrorAlert(message: String) {
		let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)
	}
}

// MARK: - UITextFieldDelegate
extension WeatherView: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		refreshWeather()
		return true
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField.text?.isEmpty ?? true {
			textField.text = ""
		}
	}
}
