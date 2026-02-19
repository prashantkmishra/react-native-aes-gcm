import { NativeModules, TurboModuleRegistry } from 'react-native';
import type { TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  encrypt(
    plainText: string,
    key: string,
    saltLength: number,
    ivLength: number,
    iterationCount: number
  ): Promise<string>;

  decrypt(
    encryptedText: string,
    key: string,
    saltLength: number,
    ivLength: number,
    iterationCount: number
  ): Promise<string>;
}

const isTurboModuleEnabled = (global as any).__turboModuleProxy != null;

const AesGcmModule = isTurboModuleEnabled
  ? TurboModuleRegistry.get<Spec>('AesGcm')
  : NativeModules.AesGcm;

if (!AesGcmModule) {
  throw new Error(
    'AesGcm native module not found.\n\n' +
      '• Did you run pod install?\n' +
      '• Did you rebuild the app?\n'
  );
}

export default AesGcmModule;
