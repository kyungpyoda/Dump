//
//  ViewController.swift
//  AsyncAwait
//
//  Created by 홍경표 on 2022/09/04.
//

import UIKit

class ViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchRandomImage()
    }

    private func setUpUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func fetchRandomImage() {
        Task {
            do {
                let (data, _) = try await URLSession.shared.dataFrom(url: URL(string: "https://random.imagecdn.app/v1/image")!)
                let imageURLStr = String(data: data, encoding: .utf8)!
                let (imageData, _) = try await URLSession.shared.dataFrom(url: URL(string: imageURLStr)!)
                let image = UIImage(data: imageData)
                imageView.image = image
            } catch {
                print("⚠️", error, error.localizedDescription)
            }
        }
    }
}

extension URLSession {
    @available(iOS, deprecated: 15.0, message: "Use API build into SDK, not this.")
    func dataFrom(url: URL, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
}
