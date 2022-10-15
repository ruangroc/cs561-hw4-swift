import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}

enum Endpoint: String {
    case realAPI = "https://api.openweathermap.org"
    case mockAPI = "http://host.docker.internal:5000"
}

class WeatherServiceImpl: WeatherService {
    var url = "/data/2.5/weather?q=corvallis&units=imperial&appid=d9721734a23ddd5b8f9affc44c6c557e"

    public init(endpoint: Endpoint = Endpoint.realAPI) {
        self.url = "\(endpoint.rawValue)" + url
    }

    func getTemperature() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
                switch response.result {
                case let .success(weather):
                    let temperature = weather.main.temp
                    let temperatureAsInteger = Int(temperature)
                    continuation.resume(with: .success(temperatureAsInteger))

                case let .failure(error):
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
}

struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}
