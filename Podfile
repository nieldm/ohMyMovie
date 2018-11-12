platform :ios, '11.0'

target 'ohMyPost' do
  use_frameworks!

  pod 'Moya/RxSwift',      '~> 10.0'
  pod 'Then',              '~> 2.3'
  pod 'RxSwiftExt',        '~> 3.2'
  pod 'RxCocoa',           '~> 4.0'
  pod 'SnapKit',           '~> 4.2'
  pod 'RxDataSources',     '~> 3.0'
  pod 'CSV.swift',         '~> 2.2.1'
  pod 'AlamofireImage',    '~> 3.4'

  target 'ohMyPostBase' do
  end

  target 'ohMyPostTests' do
    inherit! :search_paths
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest',     '~> 4.0'

    target 'ohMyPostBaseTests' do
    end
  end

  inhibit_all_warnings!

end
