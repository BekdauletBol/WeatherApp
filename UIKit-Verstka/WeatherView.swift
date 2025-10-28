import UIKit

class WeatherView: UIViewController {
	

		
		private let bannerImage = ViewBuilder.shared.bannerImage
		private let tempLabel = UILabel()
		private let cityLabel = UILabel()
		private let refreshButton = UIButton(type: .system)
		private let weatherDescription = UILabel()
		private let cityTextField = UITextField()
		private let tempLabelFahrenheit = UILabel()
		private let backgroundEffectView = UIView()
		
		
		//API
		
		private let apiKey = "1e3eef1d7f9da9c80d5c0eeaa6de89b5"
		private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
		
	
		override func viewDidLoad() {
			super.viewDidLoad()
			
			view.backgroundColor = .progBackground
			
			setContentView()
			setRefreshButton()
			setupBackgroundEffcet()
			
			
			let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
			view.addGestureRecognizer(tap)
			
			func textFieldShouldReturn(_ textField: UITextField) -> Bool {
					textField.resignFirstResponder()
					refreshWeather()
					return true
				}
				
				// Очистка при начале редактирования
				func textFieldDidBeginEditing(_ textField: UITextField) {
					if textField.text == "" || textField.text == "Enter city" {
						textField.text = ""
					}
				}
		}
		
		
		private func setContentView(){
			
			bannerImage.image = UIImage(systemName: "sun.max.fill")
			bannerImage.tintColor = .progSun
			bannerImage.contentMode = .scaleAspectFit
			
			view.addSubview(bannerImage)
			view.addSubview(cityLabel)
			view.addSubview(tempLabel)
			view.addSubview(tempLabelFahrenheit)
			view.addSubview(weatherDescription)
			view.addSubview(cityTextField)
			view.addSubview(refreshButton)
			
			
			
			NSLayoutConstraint.activate([
				bannerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
				bannerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
				bannerImage.widthAnchor.constraint(equalToConstant: 120),
				bannerImage.heightAnchor.constraint(equalToConstant: 100)
				
			])
			
			tempLabel.text = "--"
			tempLabel.font = .systemFont(ofSize: 36, weight: .bold)
			tempLabel.textColor = .progText
			tempLabel.translatesAutoresizingMaskIntoConstraints = false
			
			NSLayoutConstraint.activate([
				tempLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
				tempLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
			])
			
			tempLabelFahrenheit.text = "--"
			tempLabelFahrenheit.font = .systemFont(ofSize: 24, weight: .bold)
			tempLabelFahrenheit.textColor = .progText
			tempLabelFahrenheit.translatesAutoresizingMaskIntoConstraints = false
			
			NSLayoutConstraint.activate([
				tempLabelFahrenheit.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 4),
				tempLabelFahrenheit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
			])
			
			cityLabel.text = "City"
			cityLabel.font = .systemFont(ofSize: 24, weight: .medium)
			cityLabel.textColor = .progText
			cityLabel.translatesAutoresizingMaskIntoConstraints = false
			
			NSLayoutConstraint.activate([
				cityLabel.topAnchor.constraint(equalTo: bannerImage.bottomAnchor, constant: 50),
				cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
				
			])
			
			weatherDescription.text = "Description"
			weatherDescription.font = .systemFont(ofSize: 18, weight: .medium)
			weatherDescription.textColor = .progText
			weatherDescription.translatesAutoresizingMaskIntoConstraints = false
			
			NSLayoutConstraint.activate([
				weatherDescription.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
				weatherDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
				weatherDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
			])
			
			
			
			cityTextField.placeholder = "Enter city"
			cityTextField.text = ""
			refreshWeather()
			cityTextField.borderStyle = .roundedRect
			cityTextField.backgroundColor = .gray
			cityTextField.translatesAutoresizingMaskIntoConstraints = false
			
			
			
			NSLayoutConstraint.activate([
				cityTextField.topAnchor.constraint(equalTo: weatherDescription.bottomAnchor, constant: 20),
				cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
				cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
				cityTextField.heightAnchor.constraint(equalToConstant: 44)
			])
			
			
		}
		
		private func setRefreshButton(){
			refreshButton.setTitle("Update", for: .normal)
			refreshButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
			refreshButton.setTitleColor(.progText, for: .normal)
			refreshButton.backgroundColor = .lightGray
			refreshButton.layer.cornerRadius = 10
			refreshButton.translatesAutoresizingMaskIntoConstraints = false
			
			NSLayoutConstraint.activate([
				refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				refreshButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 10),
				refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
				refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
			])
			refreshButton.addTarget(self, action: #selector(refreshWeather), for: .touchUpInside)
			
		}
	
	// effect via AI these are not my code (only effects not mine)
	
	private func setupBackgroundEffcet(){
		backgroundEffectView.translatesAutoresizingMaskIntoConstraints = false
		view.insertSubview(backgroundEffectView, at: 0) // Под всеми элементами
		
		NSLayoutConstraint.activate([
			backgroundEffectView.topAnchor.constraint(equalTo: view.topAnchor),
			backgroundEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			backgroundEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			backgroundEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	private func startWeatherAnimation(for icon: String){
		backgroundEffectView.layer.sublayers?.removeAll()
		
		let emitter = CAEmitterLayer()
		emitter.emitterPosition = CGPoint(x: view.bounds.midX,y: -50)
		emitter.emitterShape = .line
		emitter.emitterSize = CGSize(width: view.bounds.width, height: 1)
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
							case "02d", "02n", "03d", "03n", "04d", "04n":
								symbolName = "cloud.fill"
								self.bannerImage.tintColor = .progBlue
							case "09d", "09n", "10d", "10n":
								symbolName = "cloud.rain.fill"
								self.bannerImage.tintColor = .gray
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

