import AesGcm from './NativeAesGcm';

export function encrypt(
  plainText: string,
  key: string,
  iterationCount: number
): Promise<string> {
  return AesGcm.encrypt(plainText, key, iterationCount);
}

export function decrypt(
  encryptedText: string,
  key: string,
  iterationCount: number
): Promise<string> {
  return AesGcm.decrypt(encryptedText, key, iterationCount);
}
