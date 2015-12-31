//
// Created by 周宁 on 15/12/28.
// Copyright (c) 2015 slyak. All rights reserved.
//

import UIKit

enum PageControlPosition {
    case CenterAbove, CenterBelow
}

class ImageItem: NSObject {
    var url: String
    var link: String
    init(url: String, link: String) {
        self.url = url
        self.link = link
    }
}

extension UIImageView {
    func downloadedFrom(link: String) {
        guard
        let url = NSURL(string: link)
        else {
            return
        }
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {
            (data, _, error) -> Void in
            guard
            let data = data where error == nil,
            let image = UIImage(data: data)
            else {
                return
            }
            dispatch_async(dispatch_get_main_queue()) {
                () -> Void in
                self.image = image
            }
        }).resume()
    }
}

class PagedImageScrollView: UIView, UIScrollViewDelegate {
    let PAGECONTROL_DOT_WIDTH = CGFloat(20)

    let PAGECONTROL_HEIGHT = CGFloat(20)

    var timer: NSTimer!

    var scrollView: UIScrollView = UIScrollView()

    var pageControl: UIPageControl = UIPageControl()

    var pageControlPos: PageControlPosition = .CenterAbove

    var pageControlIsChangingPage: Bool = false

    var items: [ImageItem]! {
        didSet {
            setupScrollViewAndPageControll()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDefaults()
    }

    func setPageControlPos(pos: PageControlPosition) {
        let width = PAGECONTROL_DOT_WIDTH * CGFloat(items.count)
        let x = (self.frame.size.width - width) / CGFloat(2)
        if (pageControlPos == .CenterAbove) {
            self.pageControl.frame = CGRectMake(x, self.scrollView.frame.size.height - PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT)
        } else {
            self.pageControl.frame = CGRectMake(x, self.scrollView.frame.size.height + PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT)
        }
    }

    func setDefaults() {
        self.scrollView.pagingEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
        self.addSubview(scrollView)

        self.pageControl.currentPageIndicatorTintColor = UIColor(CGColor: UIColor.redColor().CGColor)
        self.pageControl.hidesForSinglePage = true
        self.pageControl.addTarget(self, action: "changePage:", forControlEvents: UIControlEvents.ValueChanged)
        self.insertSubview(pageControl, aboveSubview: scrollView)
    }

    func configure(container: UIView, ratio: Double, items: ImageItem...) {
        self.scrollView.frame = CGRectMake(container.frame.origin.x, container.frame.origin.y, container.frame.size.width, container.frame.size.width * CGFloat(ratio))
        container.addSubview(self)
        self.items = items
    }

    func setupScrollViewAndPageControll() {
        //remove original subviews first.
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        if items == nil {
            self.pageControl.numberOfPages = 0;
            return
        }

        self.setPageControlPos(.CenterAbove)

        let imageW: CGFloat = self.scrollView.frame.size.width; //获取ScrollView的宽作为图片的宽；
        let imageH: CGFloat = self.scrollView.frame.size.height //获取ScrollView的高作为图片的高；
        let imageY: CGFloat = 0; //图片的Y坐标就在ScrollView的顶端；
        for (var i = 0; i < items.count; i++) {
            let imageView: UIImageView = UIImageView();
            let imageX: CGFloat = CGFloat(i) * imageW;
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH); //设置图片的大小，注意Image和ScrollView的关系，其实几张图片是按顺序从左向右依次放置在ScrollView中的，但是ScrollView在界面中显示的只是一张图片的大小，效果类似与画廊；
            imageView.downloadedFrom(items[i].url)
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.autoresizingMask = .FlexibleWidth
            imageView.clipsToBounds = true
            self.scrollView.addSubview(imageView); //把图片加入到ScrollView中去，实现轮播的效果；
        }

        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * CGFloat(items.count), self.scrollView.frame.size.height)
        self.addTimer()

        self.pageControl.numberOfPages = self.items.count
    }


    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        removeTimer()
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }

    func addTimer() {
        //图片轮播的定时器；
        timer = NSTimer.scheduledTimerWithTimeInterval(Double(items.count), target: self, selector: "nextImage:", userInfo: nil, repeats: true);
    }

    func removeTimer() {
        timer.invalidate()
    }

    func nextImage(sender: AnyObject!) {
        //图片轮播；
        var page: Int = pageControl.currentPage;
        if (page == items.count - 1) {
            //循环；
            page = 0;
        } else {
            page++;
        }

        UIView.animateWithDuration(0.5, animations: {
            self.scrollView.contentOffset = CGPointMake(CGFloat(page) * self.frame.size.width, 0); //注意：contentOffset就是设置ScrollView的偏移；
        })
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (self.pageControlIsChangingPage) {
            return;
        }
        let pageWidth = scrollView.frame.size.width;
        //switch page at 50% across
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControl.currentPage = Int(page);
    }

    func changePage(sender: UIPageControl) {
        var frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * CGFloat(self.pageControl.currentPage)
        frame.origin.y = 0
        frame.size = self.scrollView.frame.size
        self.scrollView.scrollRectToVisible(frame, animated: true)
        self.pageControlIsChangingPage = true;
    }
}