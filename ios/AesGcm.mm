#import "AesGcm.h"
#import "AesGcm-Swift.h"

@implementation AesGcm
RCT_EXPORT_MODULE()

#pragma mark - Init
- (instancetype)init {
  if (self = [super init]) {
    _manager = [EncryptionManager new];
  }
  return self;
}

#pragma mark - Properties
EncryptionManager *_manager;

RCT_EXPORT_METHOD(encrypt:(NSString *)plainText
            key:(NSString *)key
     saltLength:(double)saltLength
       ivLength:(double)ivLength
 iterationCount:(double)iterationCount
        resolve:(RCTPromiseResolveBlock)resolve
         reject:(RCTPromiseRejectBlock)reject) {
  
#ifdef RCT_NEW_ARCH_ENABLED
  NSLog(@"New Arch");
#else
  NSLog(@"Old Arch");
#endif
  
  NSError *error = nil;
  NSString *result = [_manager encrypt:plainText
                                   key:key
                            saltLength:@((int)saltLength)
                              ivLength: @((int)ivLength)
                        iterationCount:@((int)iterationCount)
                                 error:&error];
  if (result != nil) {
    resolve(result);
  } else {
    reject(@"encrypt_error",
           error.localizedDescription ?: @"Encryption failed",
           error);
  }
  
}

RCT_EXPORT_METHOD(decrypt:(NSString *)encryptedText
                  key:(NSString *)key
           saltLength:(double)saltLength
             ivLength:(double)ivLength
       iterationCount:(double)iterationCount
              resolve:(RCTPromiseResolveBlock)resolve
               reject:(RCTPromiseRejectBlock)reject ) {
  NSError *error = nil;
  
  NSString *result = [_manager decrypt:encryptedText
                                   key:key
                            saltLength:@((int)saltLength)
                              ivLength: @((int)ivLength)
                        iterationCount:@((int)iterationCount)
                                 error:&error];
  
  if (result != nil) {
    resolve(result);
  } else {
    reject(@"decrypt_error",
           error.localizedDescription ?: @"Decryption failed",
           error);
  }
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeAesGcmSpecJSI>(params);
}
#endif

@end
