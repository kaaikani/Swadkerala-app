/// Creates app icon with green background (for iOS - replaces black from remove_alpha).
/// Makes logo bigger by scaling up before compositing.
/// Run: dart run tools/create_icon_green_bg.dart
import 'dart:io';
import 'package:image/image.dart' as img;

/// Scale factor (1.0 = use source image as-is; image was updated for bigger logo)
const double logoScale = 1.0;

void main() {
  // #4CB150 = 76, 177, 80
  const r = 76, g = 177, b = 80;
  final green = img.ColorRgba8(r, g, b, 255);

  final input = File('assets/images/kklogo_padded.png');
  if (!input.existsSync()) {
    print('Error: assets/images/kklogo_padded.png not found');
    exit(1);
  }

  final image = img.decodeImage(input.readAsBytesSync());
  if (image == null) {
    print('Error: Could not decode image');
    exit(1);
  }

  // Scale logo up so it appears bigger in the final icon
  final scaledW = (image.width * logoScale).round();
  final scaledH = (image.height * logoScale).round();
  final scaledLogo = img.copyResize(
    image,
    width: scaledW,
    height: scaledH,
    interpolation: img.Interpolation.average,
  );

  // Create green background, composite scaled logo centered (edges crop = zoom in)
  final background = img.Image(width: image.width, height: image.height, numChannels: 4)
    ..clear(green);
  img.compositeImage(background, scaledLogo, center: true);

  final output = File('assets/images/kklogo_icon_ios.png');
  output.writeAsBytesSync(img.encodePng(background));
  print('Created ${output.path} with green background (logo ${(logoScale * 100).toInt()}% larger)');

  // Create larger foreground for Android adaptive icon (crop center to original size)
  final cropX = (scaledW - image.width) ~/ 2;
  final cropY = (scaledH - image.height) ~/ 2;
  final foregroundCropped = img.copyCrop(
    scaledLogo,
    x: cropX,
    y: cropY,
    width: image.width,
    height: image.height,
  );
  final foregroundOutput = File('assets/images/kklogo_foreground_large.png');
  foregroundOutput.writeAsBytesSync(img.encodePng(foregroundCropped));
  print('Created ${foregroundOutput.path} for Android adaptive icon');
}
