import AesGcm from './NativeAesGcm';

type EncryptOptions = {
  saltLength?: number;
  ivLength?: number;
  iterationCount?: number;
};
const SALT_LENGTH = 16;
const IV_LENGTH = 12;
const ITERATION_COUNT = 1000;

export function encrypt(
  plainText: string,
  key: string,
  options?: EncryptOptions
): Promise<string> {
  return AesGcm.encrypt(
    plainText,
    key,
    options?.saltLength ?? SALT_LENGTH,
    options?.ivLength ?? IV_LENGTH,
    options?.iterationCount ?? ITERATION_COUNT
  );
}

export function decrypt(
  encryptedText: string,
  key: string,
  options?: EncryptOptions
): Promise<string> {
  return AesGcm.decrypt(
    encryptedText,
    key,
    options?.saltLength ?? SALT_LENGTH,
    options?.ivLength ?? IV_LENGTH,
    options?.iterationCount ?? ITERATION_COUNT
  );
}
