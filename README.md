# iosCounter-swift

你好，我是 iosCounter 的開發者 Wkalpha

這個 App 主要提供給有計數需求的人

當初會設計這支 App

是因為看到了某篇學習筆記 https://ithelp.ithome.com.tw/articles/10209474

認為這對於剛接觸 swift 的新手來說較 Hello World 更能學習到更多的技巧


開發環境

Xcode Version 10.2 (10E125)

swift 5

另外使用 Cocoapods 管理工具來管理第三方套件

關於 Cocoapods 的安裝及使用方式請參考 https://notcodingwilldie.blogspot.com/2018/10/cocoapods.html

接著來大略說明專案內容包含了哪些部分

首先是 Main.storyboard，換句話說就是 App 的 UI，可以拉幾個簡單的 Label、Button、Item 元件，初步理解這些元件有什麼屬性、可以做哪些事情

再來是如何讓 Main.storyboard 與 ViewController.swift 溝通
譬如點擊了哪個 Button 會觸發什麼事件去改變 Label 的顯示
Example:點擊 A 更改 Label 的文字為 Hello World

然後我增加了存取 SQLite 的功能，這個功能當然不是我自己刻出來的，Google 上面有許多資源，我一開始是參考這篇https://ithelp.ithome.com.tw/articles/10202042?sc=iThelpR
但完全照著上面做還是會有一些問題，不過對 swift 如何操作 SQLite 能有初步了解，剩下不清楚的可以直接觀看我的範例即可

最後我增加了 Alert 的功能，稍微增加用戶體驗

日後有想到什麼需要補充的會直接加進來

2019/04/11

為了不讓 UI 在不同裝置上亂七八糟的呈現
增加了 CONTRAINTS

歡迎透過 Email 來與我討論任何問題
wkalphakao@gmail.com

願你學習 Swift 順利
