# async/await - Swift Concurrency

# 개요

## 기존 방식의 단점

Swift 에서 비동기 작업을 위해 completion handler(closure)를 많이 사용함.

그런데 **연속적인 비동기 작업, 오류 처리, 비동기 호출간의 제어 흐름**이 복잡할 때 문제가 됨.

```swift
// 예시
func loadRandomUserProfileImage(completion: @escaping (UIImage?) -> Void) {
	loadUsers() { users in
		guard let randomUser = users.randomElement() else {
			completion(nil) // ⚠️ <- 깜빡하면 안됨
			return
		}
		if randomUser.hasProfile {
			loadImageResult(of: randomUser.profile) { imageResult in
				completion(imageResult)
			}
		} else {
	  	loadUserDetail(of: randomUser) { userDetail in
  			loadImage(of: userDetail.profile) { profileImage in
				  completion(profileImage)
			  }
		  }
		}
	}
}
```

- 일련의 비동기 작업은 여러 중첩의 closure가 필요함
- 오류 처리를 위해 각 closure의 인자를 Result 타입(swift 5.0에 추가)으로 한다면 코드가 더욱 장황해짐.
- completion의 인자에 따라 분기 처리가 필요한 경우 더욱 복잡해짐
- completion을 호출하지 않고 그냥 return 하면 메소드를 콜한 쪽에서는 작업의 성공/실패 여부를 노티 받지 못함

## why async/await?

async await 는 프로그래밍 이론 중 코루틴 이라는 개념을 swift에서 지원하는 api

### 코루틴 (참고: [https://kotlinworld.com/214](https://kotlinworld.com/214))

코루틴은 스레드 안에서 실행되는 일시 중단 가능한 작업의 단위

하나의 스레드에 여러 코루틴이 존재할 수 있음

코루틴은 스레드를 만드는 대신 하나의 스레드 상에서 코루틴 자신을 일시 중지할 수 있도록 하여 스레드 생성, 컨텍스트 스위칭 비용을 줄임 (스레드는 생성 비용, 컨텍스트 스위칭 비용이 비쌈)

[https://developer.apple.com/videos/play/wwdc2021/10254](https://developer.apple.com/videos/play/wwdc2021/10254)

[https://velog.io/@wansook0316/Swift-ConcurrencyBehind-the-scenes-Part.-01](https://velog.io/@wansook0316/Swift-ConcurrencyBehind-the-scenes-Part.-01)

[https://velog.io/@wansook0316/Swift-ConcurrencyBehind-the-scenes-Part.-02](https://velog.io/@wansook0316/Swift-ConcurrencyBehind-the-scenes-Part.-02)

# 어떻게 적용할 수 있을까?

Xcode 13.2 부터는 iOS 13 에서도 async/await를 사용할 수 있다. Xcode 13.2 미만은 iOS 15 이상만 async/await를 사용할 수 있다.

[https://www.hackingwithswift.com/quick-start/concurrency/where-is-swift-concurrency-supported](https://www.hackingwithswift.com/quick-start/concurrency/where-is-swift-concurrency-supported)

RxSwift 6.5.0 부터 Swift Concurrency를 지원하여 Observable을 await 할 수 있고 AsyncStream을 Observable로 wrap할 수 있다.

[https://okanghoon.medium.com/rxswift-에서-modern-concurrency-사용하기-f8f5214ff53a](https://okanghoon.medium.com/rxswift-%EC%97%90%EC%84%9C-modern-concurrency-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0-f8f5214ff53a)

기존의 클로저를 이용한 비동기 처리 코드를 아래와 같이 확장할 수 있다.

```swift
func fetchData(_ completionHandler: @escaping (Result<Data, Error>) -> Void) {
    ...
}

func fetchData() async throws -> Data {
    return try await withCheckedThrowingContinuation { continuation in
        fetchData { result in
            switch result {
            case .success(let value):
                continuation.resume(returning: value)
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
}
```

[https://developer.apple.com/documentation/swift/withcheckedcontinuation(function:_:)](https://developer.apple.com/documentation/swift/withcheckedcontinuation(function:_:))

[https://developer.apple.com/documentation/swift/withcheckedthrowingcontinuation(function:_:)](https://developer.apple.com/documentation/swift/withcheckedthrowingcontinuation(function:_:))

[https://wwdcbysundell.com/2021/wrapping-completion-handlers-into-async-apis/](https://wwdcbysundell.com/2021/wrapping-completion-handlers-into-async-apis/)

위 방법을 이용해서 iOS 15 미만에서 사용 불가능한 URLSession의 dataTask async를 직접 구현할 수 있다.

```swift
extension URLSession {
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func data(url: URL, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
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
```

> 참고
[https://zeddios.tistory.com/1230](https://zeddios.tistory.com/1230)
[https://kotlinworld.com/214](https://kotlinworld.com/214)
[https://kotlinworld.com/139](https://kotlinworld.com/139)
[https://github.com/ReactiveX/RxSwift/blob/main/Documentation/SwiftConcurrency.md](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/SwiftConcurrency.md)
[https://okanghoon.medium.com/rxswift-에서-modern-concurrency-사용하기-f8f5214ff53a](https://okanghoon.medium.com/rxswift-%EC%97%90%EC%84%9C-modern-concurrency-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0-f8f5214ff53a)
[https://www.hackingwithswift.com/quick-start/concurrency/where-is-swift-concurrency-supported](https://www.hackingwithswift.com/quick-start/concurrency/where-is-swift-concurrency-supported)
[https://developer.apple.com/documentation/swift/withcheckedcontinuation(function:_:)](https://developer.apple.com/documentation/swift/withcheckedcontinuation(function:_:))
[https://developer.apple.com/documentation/swift/withcheckedthrowingcontinuation(function:_:)](https://developer.apple.com/documentation/swift/withcheckedthrowingcontinuation(function:_:))
[https://wwdcbysundell.com/2021/wrapping-completion-handlers-into-async-apis/](https://wwdcbysundell.com/2021/wrapping-completion-handlers-into-async-apis/)
[https://phillip5094.tistory.com/20](https://phillip5094.tistory.com/20)
[https://thisdevbrain.com/how-to-use-async-await-with-ios-13/](https://thisdevbrain.com/how-to-use-async-await-with-ios-13/)
>

