//
//  LoadingIndicator.swift
//  JojoDataSources
//
//  Created by Yousef Hamza on 5/22/17.
//  Copyright © 2017 yousefhamza. All rights reserved.
//

import UIKit
import SnapKit

class LoadingIndicator: UIView {
    let loadingTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let activityIndicator = UIActivityIndicatorView()

    init(withAttributedTitle attributedTitle: NSAttributedString) {
        loadingTitle.attributedText = attributedTitle

        super.init(frame: .zero)

        addSubview(loadingTitle)
        addSubview(activityIndicator)

        activityIndicator.startAnimating()

        layout()
    }

    func layout() {
        loadingTitle.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.left.greaterThanOrEqualTo(self).offset(30)
            make.right.lessThanOrEqualTo(self).offset(-30)
            print("frame: \(self.frame)")
        }

        activityIndicator.snp.makeConstraints { (make) in
            make.top.equalTo(loadingTitle.snp.bottom).offset(10)
            make.centerX.equalTo(self)
        }
    }

    convenience init(withTitle title: String) {
        self.init(withAttributedTitle: NSAttributedString(string: title))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
