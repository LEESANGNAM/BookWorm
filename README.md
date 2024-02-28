 

# MyShop

### 실행화면
<p>
<!-- [둘러보기메인] -->
<img src = "https://github.com/LEESANGNAM/BookWorm/assets/61412496/8d3293eb-cfde-48a9-9d7c-5060648d9f13" width="22%"/> 
<!-- [책장에추가] -->
<img src = "https://github.com/LEESANGNAM/BookWorm/assets/61412496/840ef527-b19b-47a9-b930-4d9defb41ef0" width="22%"/>  
<!-- [책검색] -->
<img src = "https://github.com/LEESANGNAM/BookWorm/assets/61412496/cb9c6956-52be-4d91-832f-e85361bc78bd" width="22%"/> 
 
<!-- [책상세정보] -->
<img src = "https://github.com/LEESANGNAM/BookWorm/assets/61412496/367ee7ed-88c9-4df4-8265-5550f319c813" width="22%"/> 
<!-- [나의책방] -->
<img src = "https://github.com/LEESANGNAM/BookWorm/assets/61412496/b6eae85a-4b83-4653-a5d2-c5ff545faea2" width="22%"/>  
<!-- [나의좋아요] -->
<img src = "https://github.com/LEESANGNAM/BookWorm/assets/61412496/3058ee2a-5948-488d-b6f1-845408f19633" width="22%"/>  
</p>

### 간단소개
책정보 검색을통해 나의 책장과, 좋아요, 메모 등을 입력할 수 있는 앱

## 개발기간
+ 개인프로젝트
+ 2023.07.31 ~ 2023.08.10
## 최소타겟
+ iOS 16.0

## 기술스택
+ MVC 
+ UIKit,Storyboard, Xib, AutoLayout
+ Kingfisher,Alamofire
+ Realm, SwiftyJSON

## 기능소개
+ KakaoBook 검색 기능
+ 책장 추가 기능
+ 책 좋아요 기능
+ 책 상세 정보확인 및 메모 가능

## 트러블슈팅

### 중복 데이터
+ 검색 후 책장에 넣을 때 같은 책을 넣으면 여러 책이 중복된다.
+ 검색 데이터를 realm 데이터로 변환 (기본키를 isbn 으로 설정해서 중복 제거)
~~~ swift
class RealmBook: Object {
//    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(primaryKey: true) var isbn: String
    @Persisted var title: String //책제목
    @Persisted var authors: String // 저자
    @Persisted var releaseDate: String //
    @Persisted var price: Int // 
    @Persisted var overview: String
    @Persisted var urlString: String
    @Persisted var islikeCheck: Bool
    @Persisted var memo:String?
}
~~~

### 탭 전환시 데이터 반영
+ viewWillAppear 에서 데이터 반영하도록 적용
~~~ swift 
override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookList = RealmDBManager.shared.readAllRealmBook()
        collectionView.reloadData()
    }
~~~

### API 호출 코드 중복 
+ Singleton 을 통해 호출
~~~ swift 
class APIManager {
    static let shard = APIManager()
    
    private init(){ }
    
    func callRequest(text: String = "클린코드",page: Int,completionHandler: @escaping ([RealmBook])->Void){
        let text = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://dapi.kakao.com/v3/search/book?query=\(text)&size=30&page=\(page)"
        let header: HTTPHeaders = ["Authorization":APIKey.KakaoKey]
        AF.request(url, method: .get,headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if response.response?.statusCode == 200 {
                    let json = JSON(value)
//                    print("JSON: \(json)")
                    var bookList: [RealmBook] = []
                    for item in json["documents"].arrayValue{
                        let title = item["title"].stringValue
                        let isbn = item["isbn"].stringValue
                        let authors = item["authors"][0].stringValue
                        let overview = item["contents"].stringValue
                        let url = item["thumbnail"].stringValue
                        let price = item["price"].intValue
                        let date = item["datetime"].stringValue
                        
                        let book = RealmBook(isbn: isbn, title: title, authors: authors , releaseDate: date.changeFormatDateString(), price: price, overview: overview, urlString: url)
                        bookList.append(book)
                    }
                    completionHandler(bookList)
                }else{
                    print("오류")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
~~~
