import UIKit
import JellyGif

final class MainVC: UIViewController {
    
    var mainView: MainView { return self.view as! MainView }
    
    private var searchController = UISearchController()
    private var apiManager = APIManager()
    private var timer: Timer?
    
    private var gifArray: [Gif] = []
    private var gifData: [Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds)
    }
    
    private func setup() {
        navigationItem.title = "Search GIF"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        mainView.gifCollectionView.delegate = self
        mainView.gifCollectionView.dataSource = self
        
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Enter a keyword to search gif:"
        searchController.searchBar.returnKeyType = .search
        searchController.searchResultsUpdater = self
    }
    
    private func searchGifs(by keyWord: String) {
        apiManager.fetchGifsBy(keyWord: keyWord) { gifArray in
            self.gifArray = gifArray
            self.fetchGifs()
        }
    }
    
    private func fetchGifs() {
        for gif in gifArray {
            apiManager.fetchGifBy(url: gif.getGifURL()) { gifData in
                self.gifData.append(gifData)
                if gifData.count >= requestLimit {
                    self.mainView.gifCollectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - Extensions
extension MainVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        if text != "" {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [self] _ in
                gifArray.removeAll()
                gifData.removeAll()
                searchGifs(by: text)
            })
        } else {
            gifArray.removeAll()
            gifData.removeAll()
            mainView.gifCollectionView.reloadData()
        }
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return gifData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: mainView.gifCollectionView.frame.width, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.id, for: indexPath) as? MainCell else {
            fatalError("UnSupported")
        }
        guard gifData.count > indexPath.row else { return cell }
        
        let gif = gifData[indexPath.row]
        cell.imageView.startGif(with: .data(gif))

        return cell
    }
}
