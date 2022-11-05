#import "CompassHeadingPlugin.h"
#if __has_include(<compass_heading/compass_heading-Swift.h>)
#import <compass_heading/compass_heading-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "compass_heading-Swift.h"
#endif

@implementation CompassHeadingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCompassHeadingPlugin registerWithRegistrar:registrar];
}
@end
