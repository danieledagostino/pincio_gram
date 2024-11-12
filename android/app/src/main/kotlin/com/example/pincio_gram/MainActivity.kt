package com.example.pincio_gram

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import org.drinkless.td.libcore.telegram.Client
import org.drinkless.td.libcore.telegram.TdApi

class MainActivity: FlutterActivity() {
    private val CHANNEL = "telegram_client"
    private lateinit var client: Client

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initializeClient" -> {
                    initializeClient()
                    result.success(null)
                }
                "setPhoneNumber" -> {
                    val phoneNumber = call.argument<String>("phoneNumber")!!
                    setPhoneNumber(phoneNumber)
                    result.success(null)
                }
                "checkCode" -> {
                    val code = call.argument<String>("code")!!
                    checkCode(code)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun initializeClient() {
        client = Client.create({ update -> handleUpdate(update) }, null, null)
    }

    private fun setPhoneNumber(phoneNumber: String) {
        client.send(TdApi.SetAuthenticationPhoneNumber(phoneNumber, null)) {}
    }

    private fun checkCode(code: String) {
        client.send(TdApi.CheckAuthenticationCode(code)) {}
    }

    private fun handleUpdate(update: TdApi.Update) {
        // Handle updates from Telegram
    }
}
