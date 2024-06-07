//
//  LazyView.swift
//  EOD
//  NavigationLink의 destination view를 lazy하게 생성하기 위한 코드.
//  이슈 : https://oss.navercorp.com/GP/app-issue/issues/2409
//  코드 출처 : https://gist.github.com/chriseidhof/d2fcafb53843df343fe07f3c0dac41d5
//
//  Created by JooYoung Kim on 6/7/24.
//

import SwiftUI

/// NavigationLink의 destination view를 lazy하게 생성하는 view
public struct LazyView<Content: View>: View {
    let build: () -> Content
    
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    public var body: Content {
        build()
    }
}
