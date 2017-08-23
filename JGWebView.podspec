Pod::Spec.new do |s|
s.name         = 'JGWebView'
s.version      = '1.0.1'
s.description      = <<-DESC
使用虚拟工厂的方法，在系统WKWebView和UIWebView的基础上，集成封装的一个简单易用、无耦、可一键切换的webView。
DESC
s.summary      = 'A simple webView'
s.homepage     = 'https://github.com/fcgIsPioneer/JGWebView'
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.author       = { 'fcgIsPioneer' => '2044471447@qq.com' }
s.platform     = :ios
s.source       = {:git => 'https://github.com/fcgIsPioneer/JGWebView.git', :tag => s.version}
s.source_files = 'JGWebView/JGWebView/**/*.{h,m}'
s.resource = 'JGWebView/JGWebView/JGWebView/JGWebViewResources/JGWebViewResources.bundle'
end
