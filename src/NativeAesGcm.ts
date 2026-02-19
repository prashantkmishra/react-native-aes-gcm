import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

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

export default TurboModuleRegistry.getEnforcing<Spec>('AesGcm');
