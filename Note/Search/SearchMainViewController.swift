//
//  SearchMainViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/8.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit

class SearchMainViewController: UIViewController,UISearchBarDelegate{
    
    @IBOutlet weak var MemoButton: UIButton!
    @IBOutlet weak var NoteButton: UIButton!
    @IBOutlet weak var NoteLabel: UILabel!
    @IBOutlet weak var MemoLabel: UILabel!
    
    var pageViewController : UIPageViewController!
    var searchNoteTableViewController: SearchNoteTableViewController!
    var searchMemoTableViewController: SearchMemoTableViewController!
    var controllers = [UIViewController]()
    
    var searchBar = UISearchBar()
    
    var lastPage = 0
    var currentPage : Int = 0{
        didSet{
            if(currentPage == 0){
                NoteLabel.backgroundColor = UIColor.black
                MemoLabel.backgroundColor = UIColor.white
            }
            else{
                NoteLabel.backgroundColor = UIColor.white
                MemoLabel.backgroundColor = UIColor.black
            }
            if(currentPage > lastPage){
                self.pageViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: true, completion: nil)
            }
            else if(currentPage < lastPage){
                self.pageViewController.setViewControllers([controllers[currentPage]], direction: .reverse, animated: true, completion: nil)
            }
            
            lastPage = currentPage
        }
    }
    
    @IBAction func changePage(_ sender: UIButton) {
        currentPage = sender.tag - 100
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tempPageViewController = self.childViewControllers.first as? UIPageViewController{
            pageViewController = tempPageViewController
        }
        
        searchNoteTableViewController = (storyboard?.instantiateViewController(withIdentifier: "SearchNoteViewController"))! as! SearchNoteTableViewController
        
        searchMemoTableViewController = (storyboard?.instantiateViewController(withIdentifier: "SearchMemoViewController"))! as! SearchMemoTableViewController
        
        
        controllers.append(searchNoteTableViewController)
        controllers.append(searchMemoTableViewController)
        
        pageViewController.dataSource = self
        pageViewController.setViewControllers([searchNoteTableViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.currentPageChanged(notification:)), name: NSNotification.Name(rawValue: "currentPageChanged"), object: nil)
        
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        //searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        navigationItem.titleView = searchBar
        searchBar.placeholder = "输入搜索内容"
        searchBar.delegate = self
        
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //print(searchBar.text
        searchNoteTableViewController.Search(forSearchString: searchBar.text!)
        searchMemoTableViewController.Search(forSearchString: searchBar.text!)
        let count1 = searchNoteTableViewController.searchNotes.count
        let count2 = searchMemoTableViewController.searchMemos.count
        self.NoteButton.setTitle("笔记本(\(count1))", for: UIControlState.normal)
        self.MemoButton.setTitle("便笺(\(count2))", for: UIControlState.normal)
    }
    @objc func currentPageChanged(notification:NSNotification){
        print("ccccc")
        currentPage = notification.object as! Int
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchMainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
        
        if viewController.isKind(of: SearchNoteTableViewController.self) {
            return searchMemoTableViewController
        }
        
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        
        if viewController.isKind(of: SearchMemoTableViewController.self) {
            return searchNoteTableViewController
        }
        return nil
    }
    
}
