# Requires -Version 5.0
. $PSScriptRoot\Utilities.ps1	# 同じ名前空間で実行する必要があるため、ドットソースで呼び出す

Add-Type -AssemblyName system.windows.forms
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName system
Import-Module -Name $PSScriptRoot\dummyWindow.psm1

# 環境設定
Set-StrictMode -Version 3.0
$ErrorActionPreference = "stop"						# エラーが発生した場合はスクリプトの実行を停止
$PSDefaultParameterValues['out-file:width'] = 2000	# Script実行中は1行あたり2000文字設定

Add-Type -AssemblyName system.windows.forms
# 少しだけ今どきの Control表示にする
[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::VisualStyleState = 3

# 使用するWin32 APIを定義
DefineWin32API

[IntPtr]$hConsoleWnd = [Win32.NativeAPIs]::GetConsoleWindow()

# Window作成前に呼ぶことで、これ以降にこのScriptで作られる
# Top Level windowが High DPI対応として動作する
$script:DpiAwareness = SetThreadDpiAwarenessContext(-4)
# 画面用設定を反映させるため、dummy window を作成し、すぐに破棄する
displayDummyWindow -hParentwnd $hConsoleWnd

# Display Scaling Value を得るために child windowを作る(RectでなくPointなのは、幅高さをもらうため)
$Resolution_Scale	= New-Object System.Windows.Point
$Resolution_Pixcel	= New-Object System.Windows.Point
$rcWorkarea_Scale	= New-Object System.Windows.Point
$rcWorkarea_Pixcel	= New-Object System.Windows.Point

[IntPtr]$script:DpiOldSetting = SetThreadDpiAwarenessContext(-1)
displayDummyWindow 0 ([ref]$Resolution_Scale) ([ref]$rcWorkarea_Scale)

[IntPtr]$script:DpiOldSetting = SetThreadDpiAwarenessContext(-4)
displayDummyWindow 0 ([ref]$Resolution_Pixcel) ([ref]$rcWorkarea_Pixcel)

Write-Host "$($Resolution_Scale.x)  $($Resolution_Scale.y)"
Write-Host "$($Resolution_Pixcel.x)  $($Resolution_Pixcel.y)"

[double]$scale = ($Resolution_Pixcel.x) / $Resolution_Scale.x
Write-Host -ForegroundColor Yellow "`n画面の拡大率は $scale 倍です。"


# Dialog定義を読み込み
#[xml]$xaml = Get-Content ($PSScriptRoot + "\SettingWindow.xaml")
Import-Module -Name $PSScriptRoot\SettingWindow.psm1
[xml]$xaml  = Xaml_SettingWindow
$xamlReader = $xaml -as "System.Xml.XmlNodeReader"
$flipWnd = [Windows.Markup.XamlReader]::Load( $xamlReader )

# Control elementの objectを取得
$baseWnd = $flipWnd.FindName( "baseWindow" )
$grdBase = $flipWnd.FindName( "grid" )
$btnClose = $flipWnd.FindName( $global:Controls[8].Name )
$imgBack = $flipWnd.FindName( "Back_image1" )

# Event handler登録
$baseWnd.Add_MouseLeftButtonDown({$baseWnd.DragMove() })
$btnClose.Add_Click({ $flipWnd.Close() })

$baseWnd.add_Loaded({
	$hwnd = (New-Object System.Windows.Interop.WindowInteropHelper($this)).Handle
	Write-Host "hwnd = $hwnd"

#	$baseWnd.Left = 0
#	$baseWnd.Top = 0
	$rcGrid = New-Object RECT
	$rcGrid.left	= $baseWnd.Left * $scale	+ ($baseWnd.ActualWidth  - $grdBase.ActualWidth)  / 2 * $scale
	$rcGrid.top 	= $baseWnd.Top  * $scale	+ ($baseWnd.ActualHeight - $grdBase.ActualHeight) / 2 * $scale
	$rcGrid.right	= ($rcGrid.left / $scale	+ $grdBase.ActualWidth)  * $scale
	$rcGrid.bottom	= ($rcGrid.top  / $scale	+ $grdBase.ActualHeight) * $scale
	Write-Host "$($baseWnd.Left),  $($baseWnd.Top),  ActualWidth = $($baseWnd.ActualWidth),  ActualHeight = $($baseWnd.ActualHeight)"
	Write-Host "            ActualWidth = $($grdBase.ActualWidth),  ActualHeight = $($grdBase.ActualHeight)"
	Write-Host "$($rcGrid)"
	TakeScreenshot 0 $rcGrid ([ref]$imgBack)
	Write-Host "return "

})



# Dialog表示 (Dialogの[閉じる]ボタン押下まで帰ってこない)
[void]$flipWnd.showDialog()

# 終了処理
exit 0
