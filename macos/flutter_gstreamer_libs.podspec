#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_gstreamer_libs.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_gstreamer_libs'
  s.version          = '1.24.8'
  s.summary          = 'GStreamer.framework package for macOS'
  s.description      = <<-DESC
Provide GStreamer.framework native library (no bindings provided).
                       DESC
  s.homepage         = 'https://github.com/ConferreAI'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Hao Su' => 'hao@conferre.ai' }

  s.source           = { :path => '.' }
  s.platform = :osx, '10.11'
  s.osx.vendored_frameworks = "Frameworks/GStreamer.framework"

  # Download the GStreamer, unpack it, and prepare the framework
  s.prepare_command = <<-CMD
    GSTREAMER_PKG_URL="https://github.com/ConferreAI/GStreamer.framework/releases/download/v1.24.8/gstreamer-macos-1.24.8.zip"
    GSTREAMER_PKG_HASH_SHA256="493de0c8c18f3c91bbac83c14532a3c67a83c50ca9ace11ea7a76a1dcb7b85bb"

    download_and_extract_gstreamer() {
      echo "Downloading and extracting GStreamer.framework..."
      rm -rf temp
      mkdir temp

      # Download GStreamer package
      curl -L "$GSTREAMER_PKG_URL" -o temp/gstreamer-macos.zip

      # Verify downloaded package hash
      echo "Verifying package integrity..."
      ACTUAL_PKG_HASH=$(shasum -a 256 temp/gstreamer-macos.zip | awk '{ print $1 }')
      if [ "$ACTUAL_PKG_HASH" != "$GSTREAMER_PKG_HASH_SHA256" ]; then
        echo "Package hash verification failed! Exiting..."
        exit 1
      fi

      # Extract the package
      unzip temp/gstreamer-macos.zip -d ./Frameworks

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
