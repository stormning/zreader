//
//  BaseViewController.swift
//  flower
//
//  Created by 周宁 on 15/12/3.
//  Copyright © 2015年 orange. All rights reserved.
//

import UIKit
import Alamofire

protocol ControllerConfig: class {
    var barRootView: Bool { get }
    var rootView: Bool { get }
    var title: String { get }
}

class BaseViewController: UIViewController {

    var params: AnyObject?;
    var errorHandler: ErrorHandler!
    weak var config: ControllerConfig?;

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        prepareViewModel()
    }

    func configure(config: ControllerConfig) {
        self.config = config
    }

    func setupNavigation() {
        if let navCtl = self.navigationController {
            //导航栏
            let navBar = navCtl.navigationBar
            navBar.barTintColor = UIColor.init(red: 0.17, green: 0.76, blue: 0.76, alpha: 1)
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            if let cfg = self.config {
                self.navigationItem.title = cfg.title
                if (!cfg.barRootView && !cfg.rootView) {
                    self.navigationItem.setLeftBarButtonItem(createUiBarButtonItem("leftBarBtn", selector: "navLeftBarTouched:"), animated: false)
                }
                //TODO show tools
            }
        }
    }

    private func createUiBarButtonItem(named: String, selector: String) -> UIBarButtonItem {
        let barBtn = UIBarButtonItem(image: UIImage(named: named), style: .Plain, target: self, action: Selector(selector))
        barBtn.width = 44
        return barBtn;
    }

    //后退
    func navLeftBarTouched(sender: UIBarButtonItem) {
    }

    //设置
    func navRightBarTouched(sender: UIBarButtonItem) {

    }

    func prepareViewModel() {
        preconditionFailure("This method must be overridden")
    }

    //storyboard控制器切换,约定一个controller对应一个storyboard
    func changeController(params: AnyObject, controllerName: String) {
        changeStoryboard(params, storyboardName: controllerName, controllerName: controllerName)
    }

    //storyboard切换
    private func changeStoryboard(params: AnyObject, storyboard: UIStoryboard, controllerName: String) {
        let vc = storyboard.instantiateViewControllerWithIdentifier(controllerName) as! BaseViewController;
        vc.params = params
        presentViewController(vc, animated: true, completion: nil)
    }

    //storyboard切换
    private func changeStoryboard(params: AnyObject, storyboardName: String, controllerName: String) {
        changeStoryboard(params, storyboard: UIStoryboard(name: storyboardName, bundle: nil), controllerName: controllerName)
    }


    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        super.performSegueWithIdentifier(identifier, sender: sender)
    }

}