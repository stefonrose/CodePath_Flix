//
//  Movie.swift
//  Flix
//
//  Created by Stephon Fonrose on 12/21/18.
//  Copyright © 2018 Stephon Fonrose. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class Movie {
    var id: NSNumber
    var title: String
    var overview: String
    var releaseDate: String
    var posterURL: URL?
    var backdropURL: URL?
    var posterFound: Bool?
    var backdropFound: Bool?
    
    
    init(dictionary: [String:Any]) {
        id = dictionary[MovieKeys.id] as? NSNumber ?? 00000
        title = dictionary[MovieKeys.title] as? String ?? "No title"
        overview = dictionary[MovieKeys.overview] as? String ?? "No overview"
        releaseDate = dictionary[MovieKeys.release] as? String ?? "No release date"
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let baseBackdropURL = "https://image.tmdb.org/t/p/original"
        let posterPath = dictionary[MovieKeys.poster] as? String ?? "No-poster-path"
        let backdropPath = dictionary[MovieKeys.backdrop] as? String ?? "No-backdrop-path"
        posterFound = posterPath == "No-poster-path" ? false : true
        backdropFound = backdropPath == "No-backdrop-path" ? false : true
        posterURL = URL(string: baseURL + posterPath)!
        backdropURL = URL(string: baseBackdropURL + backdropPath)!
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        return movies
    }
}

class MovieAPIClient {
    static let baseUrl = "https://api.themoviedb.org/3/movie/"
    static let apiKey = "edce9e69356447e62c65bf14906e8ab1"
    var session: URLSession
    var numItems = 0
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func nowPlayingMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieAPIClient.baseUrl + "now_playing?api_key=\(MovieAPIClient.apiKey)" + "&page=\(pageNum)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
                self.numItems = dataDictionary["total_results"] as! NSInteger
                UserDefaults.standard.set(self.numItems, forKey: "totalItems")
                //print(numItems)
                let movies = Movie.movies(dictionaries: movieDictionaries)
                completion(movies, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func superheroMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieAPIClient.baseUrl + "299536/similar?api_key=\(MovieAPIClient.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
                let movies = Movie.movies(dictionaries: movieDictionaries)
                completion(movies, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func youtubeLink(url: URL?, completion: @escaping (URL?, Error?) -> ()) {
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let videoLinks = dataDictionary[MovieKeys.results] as! [[String: Any]]
                let youtubeEndURL = videoLinks[safe: 0]?[MovieKeys.key] as? String ?? "dQw4w9WgXcQ"
                let youtubeURL = URL(string: "https://www.youtube.com/watch?v=" + youtubeEndURL )
                completion(youtubeURL, nil)
                
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
