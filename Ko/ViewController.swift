//
//  ViewController.swift
//  Ko
//
//  Created by Mulang Su on 1/9/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var boardView: BoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = boardView.intrinsicContentSize
        scrollView.delegate = self
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 2 - scrollView.bounds.width / 2,
                                           y: scrollView.contentSize.height / 2 - scrollView.bounds.height / 2)
    }


}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        boardView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}
