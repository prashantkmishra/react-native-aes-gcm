package com.aesgcm

import android.util.Base64
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import java.nio.ByteBuffer
import java.nio.charset.StandardCharsets
import java.security.InvalidAlgorithmParameterException
import java.security.InvalidKeyException
import java.security.NoSuchAlgorithmException
import java.security.SecureRandom
import java.security.spec.InvalidKeySpecException
import java.security.spec.KeySpec
import javax.crypto.Cipher
import javax.crypto.NoSuchPaddingException
import javax.crypto.SecretKey
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.PBEKeySpec
import javax.crypto.spec.SecretKeySpec


@ReactModule(name = AesGcmModule.NAME)
class AesGcmModule(reactContext: ReactApplicationContext) : NativeAesGcmSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  override fun encrypt(
    plainText: String,
    key: String,
    iterationCount: Double,
    promise: Promise
  ) {
    try {
      val salt = getRandomNonce(SALT_LENGTH)
      val secretKey: SecretKey = getAESKeyFromPassword(key.toCharArray(), salt, iterationCount)
      val iv = getRandomNonce(IV_LENGTH)
      val cipher = initCipher(Cipher.ENCRYPT_MODE, secretKey, iv)
      val encryptedMessageByte = cipher.doFinal(plainText.toByteArray())
      val cipherByte = ByteBuffer.allocate(salt.size + iv.size + encryptedMessageByte.size)
        .put(salt)
        .put(iv)
        .put(encryptedMessageByte)
        .array()
      val result = Base64.encodeToString(cipherByte, Base64.NO_WRAP)
      promise.resolve(result);
    } catch (e: Exception) {
      return promise.reject("ENCRYPT_ERROR", e.message)
    }
  }

  override fun decrypt(
    encryptedText: String,
    key: String,
    iterationCount: Double,
    promise: Promise
  ) {
    try {
      val decode: ByteArray = Base64.decode(
        encryptedText.toByteArray(StandardCharsets.UTF_8),
        Base64.NO_WRAP
      )
      val byteBuffer = ByteBuffer.wrap(decode)
      val salt = ByteArray(SALT_LENGTH)
      byteBuffer.get(salt)
      val iv = ByteArray(IV_LENGTH)
      byteBuffer.get(iv)
      val content = ByteArray(byteBuffer.remaining())
      byteBuffer.get(content)
      val cipher = Cipher.getInstance(CIPHER_ALGORITHM)
      val aesKeyFromPassword: SecretKeySpec = getAESKeyFromPassword(key.toCharArray(), salt, iterationCount)
      cipher.init(Cipher.DECRYPT_MODE, aesKeyFromPassword, GCMParameterSpec(GCM_TAG_LENGTH * 8, iv))
      val plainText = String(cipher.doFinal(content))
      promise.resolve(plainText);
    } catch (e: java.lang.Exception) {
      promise.reject("DECRYPT_ERROR", e.message)
    }
  }

  private fun getRandomNonce(length: Int): ByteArray {
    val nonce = ByteArray(length)
    SecureRandom().nextBytes(nonce)
    return nonce
  }

  @Throws(
    InvalidKeyException::class,
    InvalidAlgorithmParameterException::class,
    NoSuchPaddingException::class,
    NoSuchAlgorithmException::class
  )
  private fun initCipher(mode: Int, secretKey: SecretKey?, iv: ByteArray): Cipher {
    val cipher = Cipher.getInstance(CIPHER_ALGORITHM)
    cipher.init(mode, secretKey, GCMParameterSpec(GCM_TAG_LENGTH * 8, iv))
    return cipher
  }

  @Throws(NoSuchAlgorithmException::class, InvalidKeySpecException::class)
  private fun getAESKeyFromPassword(password: CharArray?, salt: ByteArray, iterationCount: Double): SecretKeySpec {
    val factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA512")
    val spec: KeySpec = PBEKeySpec(password, salt, iterationCount.toInt(), KEY_LENGTH * 8)
    return SecretKeySpec(factory.generateSecret(spec).getEncoded(), "AES")
  }

  companion object {
    const val NAME = "AesGcm"
    private const val GCM_TAG_LENGTH: Int = 16
    private const val SALT_LENGTH: Int = 16
    private const val IV_LENGTH: Int = 12
    private const val KEY_LENGTH: Int = 32
    private const val CIPHER_ALGORITHM: String = "AES/GCM/NoPadding"
  }
}
