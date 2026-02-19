require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "AesGcm"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { 
    :git => "https://github.com/prashantkmishra/react-native-aes-gcm.git",
    :tag => "#{s.version}" 
  }

  # ✅ Build source file list safely
  source_files = ["ios/**/*.{h,m,mm,swift}"]

  if ENV['RCT_NEW_ARCH_ENABLED'] == '1'
    source_files << "ios/generated/**/*.{h,mm}"
  end

  s.source_files = source_files

  # ✅ Exclusions
  exclusions = [
    "ios/**/RCTAppDependencyProvider.*",
    "ios/**/RCTModuleProviders.*", 
    "ios/**/RCTThirdPartyComponentsProvider.*",
    "ios/**/RCTModulesConformingToProtocolsProvider.*",
    "ios/**/RCTUnstableModulesRequiringMainQueueSetupProvider.*",
    "**/Package.swift"
  ]

  if ENV['RCT_NEW_ARCH_ENABLED'] != '1'
    exclusions << "ios/generated/**/*"
  end

  s.exclude_files = exclusions
  s.private_header_files = "ios/**/*.h"

  # ✅ Dependencies
  s.dependency "CryptoSwift"

  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  else
    s.dependency "React-Core"
  end

  # ✅ New Architecture flags
  if ENV['RCT_NEW_ARCH_ENABLED'] == '1'
    s.compiler_flags = "-DRCT_NEW_ARCH_ENABLED=1"
    s.pod_target_xcconfig = {
      "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\"",
      "CLANG_CXX_LANGUAGE_STANDARD" => "c++17"
    }
  end
end
