//
//  HomeController.swift
//  zreader
//
//  Created by 周宁 on 15/12/25.
//  Copyright (c) 2015 slyak. All rights reserved.
//


import UIKit


class HomeController: BaseViewController {

    var banner: PagedImageScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.configure(ControllerConfig(title: "首页", rootView: true))
        banner = PagedImageScrollView(frame: CGRectMake(0, self.navigationController!.navigationBar.frame.size.height, view.frame.width, 100))
        banner.configure(view, ratio: 0.3, items:
        ImageItem(url: "http://h.hiphotos.baidu.com/news/q%3D100/sign=1ea4b7c29b82d158bd825db1b00b19d5/dcc451da81cb39db7950567ad7160924ab18300d.jpg", link: ""),
                ImageItem(url: "http://a.hiphotos.baidu.com/news/q%3D100/sign=9aa6ab14def9d72a1164141de42b282a/b90e7bec54e736d1afc443239c504fc2d46269c2.jpg", link: ""),
                ImageItem(url: "http://a.hiphotos.baidu.com/news/q%3D100/sign=50195721219759ee4c5064cb82fa434e/5243fbf2b2119313e89dcc9c62380cd791238d3b.jpg", link: ""),
                ImageItem(url: "http://f.hiphotos.baidu.com/news/q%3D100/sign=6e316b99d658ccbf1dbcb13a29d9bcd4/50da81cb39dbb6fd8f89270d0e24ab18962b37cf.jpg", link: ""),
                ImageItem(url: "http://h.hiphotos.baidu.com/news/q%3D100/sign=d14cf1132f381f30981989a999014c67/0d338744ebf81a4c1e6c2fe2d02a6059252da6bb.jpg", link: "")
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareViewModel() {

    }
}
