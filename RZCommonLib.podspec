

Pod::Spec.new do |s|
  s.name             = 'RZCommonLib'
  s.version          = '0.1.0'
  s.summary          = 'A short description of RZCommonLib.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ReyZhang'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'reyzhang' => '27196849@qq.com' }
  s.source           = { :git => 'https://github.com/ReyZhang/RZCommonLib.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'
  s.source_files = 'RZCommonLib/Classes/**/*'
  
end
