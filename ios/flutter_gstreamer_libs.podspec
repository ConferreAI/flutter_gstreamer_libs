#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_gstreamer_libs.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_gstreamer_libs'
  s.version          = '1.24.8'
  s.summary          = 'GStreamer.framework package for iOS'
  s.description      = <<-DESC
Provide GStreamer.framework native library (no bindings provided).
                       DESC
  s.homepage         = 'https://github.com/ConferreAI'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Hao Su' => 'hao@conferre.ai' }

  s.source           = { :path => "." }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' 
  }
  s.swift_version = '5.0'

  s.ios.vendored_frameworks = "Frameworks/GStreamer.framework"

  # Download the GStreamer, unpack it, and prepare the framework
  s.prepare_command = <<-CMD
    GSTREAMER_PKG_URL="https://github.com/ConferreAI/GStreamer.framework/releases/download/v1.24.8/gstreamer-ios-1.24.8.zip"
    GSTREAMER_PKG_HASH_SHA256="bdfdfba0875236f24f1b468756c9209aa9957b2298a2d88164936f086d8db590"

    download_and_extract_gstreamer() {
      echo "Downloading and extracting GStreamer.framework..."
      rm -rf temp
      mkdir temp

      # Download GStreamer package
      curl -L "$GSTREAMER_PKG_URL" -o temp/gstreamer-ios.zip

      # Verify downloaded package hash
      echo "Verifying package integrity..."
      ACTUAL_PKG_HASH=$(shasum -a 256 temp/gstreamer-ios.zip | awk '{ print $1 }')
      if [ "$ACTUAL_PKG_HASH" != "$GSTREAMER_PKG_HASH_SHA256" ]; then
        echo "Package hash verification failed! Exiting..."
        exit 1
      fi

      # Extract the package
      unzip temp/gstreamer-ios.zip -d ./Frameworks

      # Clean up temporary files
      rm -rf temp
    }

    # Check if the framework exists
    if [ -d "Frameworks/GStreamer.framework" ]; then
      echo "GStreamer.framework found."
    else
      echo "GStreamer.framework not found. Downloading..."
      download_and_extract_gstreamer
    fi
  CMD
end
