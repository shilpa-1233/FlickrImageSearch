//
//  ViewController.swift
//  DunzoImageSearch
//
//  Created by Shilpa Garg on 01/08/20.
//  Copyright © 2020 Shilpa Garg. All rights reserved.
//

import UIKit

let reuseIdentifier = "ImageCell"
let scaleConstant : CGFloat = 0.67

public class ImageSearchController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!{
        didSet{
            searchField.becomeFirstResponder()
        }
    }
    var searchResults = [Photo]()
    public var searcher = ImageSearcher()
    fileprivate let imageProvider = ImageProvider()
    var fetching = false
    var currentPage = 0
    var currentSearchTerm : String?
    public var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    
    override public func viewDidLoad() {
        activityIndicator.hidesWhenStopped = true
        searchField.addSubview(activityIndicator)
        activityIndicator.frame = searchField.bounds
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func loadDataFromGoogle(){
        searcher.searchForTerm(term: currentSearchTerm!, page: currentPage) {
            results, error in
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if let error = error {
                    self.showError(error: error)
                }
                
                if let results = results, let phot0 = results.photos?.photo , phot0.count > 0 {
                    self.fetching = false
                    
                    var indexPaths = [IndexPath]()
                    for i in (self.searchResults.count)..<(self.searchResults.count)+phot0.count-1 {
                        indexPaths.append(IndexPath(item: i, section: 0))
                    }
                    self.searchResults += results.photos?.photo ?? []

                    self.collectionView?.insertItems(at: indexPaths)
                    self.currentPage += 1
                }
            }
        }
    }
    
    func showError(error: NSError)  {
        let errorUI = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
        errorUI.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(errorUI, animated: true, completion: nil)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchField.resignFirstResponder()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if !self.fetching && self.currentSearchTerm != nil {
                self.fetching = true
                loadDataFromGoogle()
            }
        }
    }
    
    // MARK: UITextFieldDelegate
    @objc func textFieldDidChange(_ textField: UITextField){
        currentSearchTerm = textField.text
        currentPage = 0
        if currentSearchTerm?.replacingOccurrences(of: " ", with: "").isEmpty ?? true {
            resetData()
        }else {
            searchResults.removeAll()
            activityIndicator.startAnimating()
            loadDataFromGoogle()
        }
    }
    
    func resetData()  {
        
        let indexPaths = searchResults.count > 0 ? Array(0...searchResults.count-1).map{index in
            IndexPath(item: index, section: 0)
            } : []
        searchResults.removeAll()
        collectionView.deleteItems(at: indexPaths)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ImageCell

        guard let mediaUrl = searchResults[indexPath.row].getImagePath() else {
            return cell
        }
                
        cell.activityIndicator.startAnimating()
        imageProvider.requestImage(from :mediaUrl, completion: { (image) -> Void in
            let indexPath_ = collectionView.indexPath(for: cell)
            if indexPath == indexPath_ {
                cell.activityIndicator.stopAnimating()
                cell.imageView.image = image
            }
        })
        return cell
    }
}


