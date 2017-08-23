Pod::Spec.new do |s|
s.name         = 'JGWebView'
s.version      = '1.0.2'
s.summary      = '使用虚拟工厂的方法，在系统WKWebView和UIWebView的基础上，集成封装的一个简单易用、无耦、可一键切换的webView'
s.homepage     = 'https://github.com/fcgIsPioneer/JGWebView'
s.license      = 'MIT'
s.author       = { 'fcgIsPioneer' => '2044471447@qq.com' }
s.platform     = :ios,'8.0'
s.source       = {:git => 'https://github.com/fcgIsPioneer/JGWebView.git', :tag => s.version}
s.source_files = 'JGWebView/JGWebView/**/*.{h,m}'
s.resource = 'JGWebView/JGWebView/JGWebView/JGWebViewResources/JGWebViewResources.bundle'
s.requires_arc = true
end
