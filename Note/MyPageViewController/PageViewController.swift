//
//  PageViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/7.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

//主界面控制器，两个page*/
class PageViewController: UIPageViewController,UIPageViewControllerDataSource
,UIPageViewControllerDelegate{
    
    @IBOutlet weak var EditButton: UIBarButtonItem!
    var pageControl = UIPageControl()
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.alpha = 0.5
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.brown
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
//编辑
    @IBAction func setEdit(_ sender: Any) {
        if(EditButton.title == "编辑")
        {
            EditButton.title = "完成"
            if(pageControl.currentPage == 0){
                (orderedViewControllers.first as! ViewController).setEdit()
            }
            else{
                (orderedViewControllers.last as! MemoViewController).setEdit()
            }
            
        }
        else{
            EditButton.title = "编辑"
            if(pageControl.currentPage == 0){
                (orderedViewControllers.first as! ViewController).endEdit()
            }
            else{
                (orderedViewControllers.last as! MemoViewController).endEdit()
            }
        }
        
    }
    
    @IBAction func chooseForSort(_ sender: UIBarButtonItem) {
        
        let alertVC = UIAlertController(title: "选择排序方法", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let acSortByCreateTime = UIAlertAction(title: "根据创建时间排序", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            
            if(self.pageControl.currentPage == 0){
                (self.orderedViewControllers.first as! ViewController).sortBySetUpTime()
            }else{
                (self.orderedViewControllers.last as! MemoViewController).sortBySetUpTime()
            }
            print("click sort1")
        }
        let acSortByModifyTime = UIAlertAction(title: "根据修改时间排序", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            
            if(self.pageControl.currentPage == 0){
                (self.orderedViewControllers.first as! ViewController).sortByModifiedTime()
            }else{
                (self.orderedViewControllers.last as! MemoViewController).sortByModifiedTime()
            }
            
            print("click sort2")
        }
        let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            print("click cancel")
        }
        alertVC.addAction(acSortByCreateTime)
        alertVC.addAction(acSortByModifyTime)
        alertVC.addAction(acCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController(name:"NoteStoryBoard"),
                self.newViewController(name: "MemoStoryBoard")]
    }()
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: name)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self as UIPageViewControllerDataSource
        delegate = self as UIPageViewControllerDelegate
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        configurePageControl()        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    @IBAction func unwindToInitView(segue:UIStoryboardSegue){
        
        
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

