func getStreamKeys() {
        let MUX_TOKEN_ID: String = "abdcefg"
        let MUX_TOKEN_SECRET: String = "1234567"
        let url = URL(string: "https://api.mux.com/video/v1/live-streams")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let auth = "\(MUX_TOKEN_ID):\(MUX_TOKEN_SECRET)" 
        let base64Auth = Data(auth.utf8).base64EncodedString() 
        request.setValue("Basic \(base64Auth)", forHTTPHeaderField: "Authorization") 
        request.httpMethod = "POST"
        let parameters : [String:Any] = ["playback_policy": ["public"], "new_asset_settings": ["playback_policy": ["public"]]]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch let e {
            print(e)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                            
                print("error", error ?? "Unknown error")
                return
            }
            guard (200 ... 299) ~= response.statusCode else {                   
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            let newResponse = responseString!.replacingOccurrences(of: "\\", with: "")
            print(String(describing: newResponse))
            
        }
        task.resume()
    }
