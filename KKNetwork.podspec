Pod::Spec.new do |s|
  s.name             = 'KKNetwork'
  s.version          = '0.0.1'
  s.summary          = '网络库封装'
  s.description      = '针对http请求，文件上传、下载等功能的基础封装'
  s.homepage         = 'https://github.com/Kyle1018'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'linkun' => '419552038@qq.com' }
  s.source           = { :git => 'https://github.com/Kyle1018/KKNetwork.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files = 'KKNetwork/Classes/*.{h,m}'
end
