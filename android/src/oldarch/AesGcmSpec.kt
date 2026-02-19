package com.aesgcm

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule

abstract class AesGcmSpec (context: ReactApplicationContext ) : ReactContextBaseJavaModule(context) {

  abstract fun encrypt(
    plainText: String,
    key: String,
    saltLength: Double,
    ivLength: Double,
    iterationCount: Double,
    promise: Promise
  )

  abstract fun decrypt(
    encryptedText: String,
    key: String,
    saltLength: Double,
    ivLength: Double,
    iterationCount: Double,
    promise: Promise
  )

}
