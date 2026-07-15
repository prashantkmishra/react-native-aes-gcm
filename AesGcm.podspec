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

  s.source = {
    :git => "https://github.com/prashantkmishra/react-native-aes-gcm.git",
    :tag => s.version.to_s
  }

  #
  # Compile ONLY handwritten native sources.
  # React Native Codegen compiles generated sources separately.
  #
  s.source_files = [
    "ios/**/*.{h,m,mm,swift}"
  ]

  #
  # Never compile generated code from this pod.
  #
  s.exclude_files = [
    "ios/generated/**/*",
    "**/Package.swift",
    "ios/**/RCTAppDependencyProvider.*",
    "ios/**/RCTModuleProviders.*",
    "ios/**/RCTThirdPartyComponentsProvider.*",
    "ios/**/RCTModulesConformingToProtocolsProvider.*",
    "ios/**/RCTUnstableModulesRequiringMainQueueSetupProvider.*"
  ]

  s.private_header_files = [
    "ios/**/*.h"
  ]

  s.dependency "CryptoSwift"

  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  else
    s.dependency "React-Core"
  end

  s.compiler_flags = "-DRCT_NEW_ARCH_ENABLED=1"

  s.pod_target_xcconfig = {
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
    "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\""
  }
end