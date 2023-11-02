//
//  LibraryURLSession.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 11/2/23.
//

import Foundation

typealias SessionCompletionHandler = (_ data : Data?, _ response : URLResponse?, _ error : Error?) -> Void

class LibraryURLSession {
    func sendRequest(_ completionHandler: (@escaping(SessionCompletionHandler))) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: "https://data.cityofchicago.org/resource/x8fc-8rcq.json") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler:completionHandler)
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
