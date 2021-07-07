package jp.techacademy.ayumi.autoslideshowapp

import android.Manifest
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import android.provider.MediaStore
import android.content.ContentUris
import android.database.Cursor
import android.os.Handler
import kotlinx.android.synthetic.main.activity_main.*
import java.util.*


class MainActivity : AppCompatActivity() {

    private val PERMISSIONS_REQUEST_CODE = 100

        //タイマー
    private val TIMER_SEC = 2000

    private var mTimer: Timer? = null
    private val mHandler = Handler()
    private var mCursor: Cursor? = null

    private var runflg = false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Android 6.0以降の場合
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            // パーミッションの許可状態を確認する
            if (checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                // 許可されている
               mCursor = getContentsInfo()
            } else {
                // 許可されていないので許可ダイアログを表示する
                requestPermissions(arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE), PERMISSIONS_REQUEST_CODE)
            }
            // Android 5系以下の場合
        } else {
            mCursor = getContentsInfo()
        }

    //再生停止ボタン
    buttonRun.setOnClickListener{
        if (runflg) {
            mTimer?.cancel()
            mTimer = null
        } else {
            if (mTimer == null){

                mTimer = Timer()
                mTimer!!.schedule(object : TimerTask() {
                    override fun run() {
                             mHandler.post {
                                if (mCursor != null) {
                                    showImage()
                                    //最後まで来たら最初から
                                    if (!mCursor!!.moveToNext()