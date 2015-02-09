def GetAdditionalFlags():
  flags = []

  # Xcode 5.1
  #flags.append('-isystem')
  #flags.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../lib/c++/v1')
  #flags.append('-isystem')
  #flags.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include')
  #flags.append('-isystem')
  #flags.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../lib/clang/5.1/include')

  # Xcode 6
  #flags.append('-isystem')
  #flags.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1')
  #flags.append('-isystem')
  #flags.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include')
  #flags.append('-isystem')
  #flags.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../lib/clang/6.0/include')

  # llvm+clang from source
  flags.extend(
    [
      '-isystem', '/Users/r0mai/build/libcxx/include',
      '-isystem', '/usr/local/Cellar/gcc49/4.9.2_1/include/c++/4.9.2/',
      '-isystem', '/usr/local/Cellar/gcc49/4.9.2_1/include/c++/4.9.2/x86_64-apple-darwin14.0.0/',
      '-isystem', '/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/usr/include',
      '-isystem', '/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/usr/include'
    ]
  )
  return flags
