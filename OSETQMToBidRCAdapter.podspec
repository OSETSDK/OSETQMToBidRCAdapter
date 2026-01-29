Pod::Spec.new do |s|
  s.name         = "OSETQMToBidRCAdapter"
  s.version      = "6.6.2.0"
  s.summary      = "AdSet广告对接Tobid适配器"
  s.description  = <<-DESC
                    OSETSDK 是一个专业的广告聚合SDK，提供高效的广告展示和收益优化功能。
                    DESC
  s.homepage     = "https://github.com/OSETSDK/OSETQMToBidRCAdapter"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { 'shenshi' => 'yaohaofei@shenshiads.com' }
  
  # 设置最低支持版本
  s.ios.deployment_target = '11.0'
  s.static_framework = true
  # 源文件配置
  s.source       = {
    :git => 'https://github.com/OSETSDK/OSETQMToBidRCAdapter.git',
    :tag => s.version.to_s
  }
  # 主框架文件
  # 检查 OSETQMToBidRCAdapter.podspec 关键字段
  s.source_files = 'OSETQMToBidRCAdapter/**/*.{h,m}'
  # 系统框架依赖
  s.frameworks = "Foundation", "UIKit"

  # 资源文件
    
  # Swift版本设置
  s.swift_version = '5.0'
  
  # ================= 第三方依赖库 =================
 
  s.dependency 'OSETQMSDK'
  s.dependency 'ToBid-iOS-RC'
end
