#ifdef RCT_NEW_ARCH_ENABLED
#import "RNAesGcmSpec.h"

@interface AesGcm : NSObject <NativeAesGcmSpec>
#else
#import <React/RCTBridgeModule.h>

@interface AesGcm : NSObject <RCTBridgeModule>
#endif

@end
