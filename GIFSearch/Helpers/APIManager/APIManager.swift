import Foundation

class APIManager {
    
    static let shared = APIManager()

    func fetchGifsBy(keyWord: String, completion: @escaping ([Gif]) -> Void) {
        
        guard let url = urlBuilder(searchKeyWord: keyWord) else {
            print("URL is invalid!")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Error fetching from Giphy: ", err.localizedDescription)
            }
            guard let data else { return }
            do {
                DispatchQueue.main.async {
                    if let gifArray = try? JSONDecoder().decode(GifArray.self, from: data) {
                        guard let gifs = gifArray.gifs else {
                            print("Some error")
                            return
                        }
                        completion(gifs)
                        print("Success")
                    } else {
                        print("JSON Serialisation Error...")
                    }
                }
            }
        }.resume()
    }
    
    func fetchGifBy(url urlString: String, completion: @escaping (Data) -> Void) {
        
        guard let url = URL(string: urlString) else {
            print("GIF URL is invalid!")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                print("Error fetching from Giphy: ", err.localizedDescription)
            }
            guard let data else { return }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
    
    func urlBuilder(searchKeyWord: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.giphy.com"
        components.path = "/v1/gifs/search"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "q", value: searchKeyWord),
            URLQueryItem(name: "limit", value: String(requestLimit)),
            URLQueryItem(name: "lang", value: requestLang)
        ]
        return components.url
    }
}
