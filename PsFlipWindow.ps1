# Requires -Version 5.0

Add-Type -AssemblyName system.windows.forms
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName system

# 環境設定
Set-StrictMode -Version 3.0
$ErrorActionPreference = "stop"						# エラーが発生した場合はスクリプトの実行を停止
$PSDefaultParameterValues['out-file:width'] = 2000	# Script実行中は1行あたり2000文字設定

Add-Type -AssemblyName system.windows.forms
# 少しだけ今どきの Control表示にする
[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::VisualStyleState = 3

# Window作成前に呼ぶことで、これ以降にこのScriptで作られる
# Top Level windowが High DPI対応として動作する
Add-Type -MemberDefinition @"
[DllImport("user32.dll", SetLastError=true)]
public static extern IntPtr SetThreadDpiAwarenessContext(IntPtr dpiContext);
"@ -Namespace Win32 -Name NativeMethods
[void][Win32.NativeMethods]::SetThreadDpiAwarenessContext(-4)

# Dialog定義を読み込み
#[xml]$xaml = Get-Content ($PSScriptRoot + "\SettingWindow.xaml")
Import-Module -Name $PSScriptRoot\SettingWindow.psm1
[xml]$xaml  = Xaml_SettingWindow
$xamlReader = $xaml -as "System.Xml.XmlNodeReader"
$flipWnd = [Windows.Markup.XamlReader]::Load( $xamlReader )


# Control elementの objectを取得
$baseWnd = $flipWnd.FindName( "baseWindow" )
$btnClose = $flipWnd.FindName( $global:Controls[8].Name )

# Event handler登録
$baseWnd.Add_MouseLeftButtonDown({$baseWnd.DragMove() })
$btnClose.Add_Click({ $flipWnd.Close() })

<#
$baseWnd.add_Loaded({
	$hwnd = (New-Object System.Windows.Interop.WindowInteropHelper($this)).Handle
	Write-Host "hwnd = $hwnd"
})
#>




# Dialog表示 (Dialogの[閉じる]ボタン押下まで帰ってこない)
[void]$flipWnd.showDialog()

# 終了処理
exit 0
