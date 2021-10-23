# PowerShell で Flip Window

## これは何か

<img src=".\動作画面.png" alt="動作画面"  align="left"  style="float: left; width: 35%; margin-right: 30px" align="left" >Web siteでよく見かける、画面要素がカードのように回転する演出。あれが PowerShellでもできると聞き、その実現方法を確認したもの。
(library や control として提供する目的のものではありません。ハードコードです；´Д｀)💨💨)

裏と表、どちらにもボタンなどの Controlを配置可能で、もちろん押すこともできる(今回は[閉じる]以外は/ダミー)。

とにかく簡単に実現したかったのと、WPFはまだ勉強中のため、コード(というよりXamlの定義)は全くまとまっていない。

<div style="clear: both;"></div>

## 動作環境

動作環境というより、動作確認した環境；´Д｀)

- PowerShell 5.1 (Windows 11標準のもの)
- Windows 10 or 11
- .Net Framework 4.7
- WPF (Xaml)による画面表示

## 実行方法

1. **ADS (ZoneID) を削除する**  
GitHubから downloadすると、Windowsが「Internet から取得したものです」とか言って実行を禁止してくる。非常に大きなお世話です。
```powershell
PS> Remove-Item PsFlipWindow-master.zip -Stream Zone.Identifier
```
2. **Zipを解凍する**  
    好きな方法で。
1. **Scriptを実行する**   
`PsFlipWindow.bat`をダブルクリック

しばらく待って、設定dialogが出てくればOK。

## 操作方法

<dl>
	<dt><strong>ウィンドウの移動</strong></dt>
	<dd>ボタンなどの要素が無い場所をマウスドラッグ🖱️で移動</dd>
	<dt><strong>終了方法</strong></dt>
	<dd>[閉じる]ボタンを押す</dd>
</dl>

## 参考リンク

* [Animation **しない** Viewport3D のサンプル](https://docs.microsoft.com/en-us/dotnet/api/system.windows.media.media3d.viewport2dvisual3d?redirectedfrom=MSDN&view=windowsdesktop-5.0) (microsoft)
* [WPF rotating button](https://stackoverflow.com/questions/7168420/wpf-rotating-button) (stack overflow)

