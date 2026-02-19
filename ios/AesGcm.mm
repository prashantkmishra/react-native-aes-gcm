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

- (void)encrypt:(NSString *)plainText
            key:(NSString *)key
     saltLength:(double)saltLength
       ivLength:(double)ivLength
 iterationCount:(double)iterationCount
        resolve:(RCTPromiseResolveBlock)resolve
         reject:(RCTPromiseRejectBlock)reject {
  
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

- (void)decrypt:(NSString *)encryptedText
            key:(NSString *)key
     saltLength:(double)saltLength
       ivLength:(double)ivLength
 iterationCount:(double)iterationCount
        resolve:(RCTPromiseResolveBlock)resolve
         reject:(RCTPromiseRejectBlock)reject {
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

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeAesGcmSpecJSI>(params);
}

@end
