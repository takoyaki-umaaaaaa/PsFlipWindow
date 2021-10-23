
$global:Controls = 
	@([pscustomobject]@{ Name="lbl_title";				Content="設定";							Element=$null},	# 0
	  [pscustomobject]@{ Name="lbl_SaveFolder";			Content="画像保存先";					Element=$null},	# 1
	  [pscustomobject]@{ Name="txt_SaveFolder";			Content="";								Element=$null},	# 2
	  [pscustomobject]@{ Name="btn_SelectFolder";		Content="…"; 							Element=$null},	# 3
	  [pscustomobject]@{ Name="btn_DeleteEnvVal";		Content="保存先情報を削除";				Element=$null},	# 4
	  [pscustomobject]@{ Name="chk_DisplayImage";		Content="保存後に画像を表示";			Element=$null},	# 5
	  [pscustomobject]@{ Name="btn_RegisterInStart";	Content="スタートメニューに登録する";	Element=$null},	# 6
	  [pscustomobject]@{ Name="btn_Uninstall";			Content="アンインストール";				Element=$null},	# 7
	  [pscustomobject]@{ Name="btn_Close";				Content="閉じる";						Element=$null},	# 8
	  [pscustomobject]@{ Name="img_Background";			Content="";								Element=$null})	# 9

function Xaml_SettingWindow(){
	$res_img_cover		= Join-Path "$PSScriptRoot" "\resource\cover.png"
	$res_img_background	= Join-Path "$PSScriptRoot" "\resource\Gear2.png"
	$res_ico_delete		= Join-Path "$PSScriptRoot" "\resource\eraser.png"
	$res_ico_trashcan	= Join-Path "$PSScriptRoot" "\resource\TrashCan.png"
	$res_ico_folder		= Join-Path "$PSScriptRoot" "\resource\Folder.png"
	$res_ico_exit		= Join-Path "$PSScriptRoot" "\resource\Exit.png"
	$res_ico_start		= Join-Path "$PSScriptRoot" "\resource\Start.png"
	return @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Title="設定画面" Name="baseWindow" Height="650" Width="500" WindowStyle="None" AllowsTransparency="True" ResizeMode="NoResize"  MinWidth="400" MinHeight="500" ShowInTaskbar = "True" WindowStartupLocation="CenterScreen" Background="{x:Null}" FontFamily="UD Digi Kyokasho N-R" FontSize="18" Icon="$res_img_background">
	<Window.Resources>
		<Storyboard x:Key="StoryLinear">
			<DoubleAnimationUsingKeyFrames Storyboard.TargetProperty="(AxisAngleRotation3D.Angle)"
										   Storyboard.TargetName="rotateY1">
				<LinearDoubleKeyFrame KeyTime="00:00:04" Value="180"></LinearDoubleKeyFrame>
			</DoubleAnimationUsingKeyFrames>
			<DoubleAnimationUsingKeyFrames Storyboard.TargetProperty="(AxisAngleRotation3D.Angle)"
										   Storyboard.TargetName="rotateY2">
				<LinearDoubleKeyFrame KeyTime="00:00:04" Value="360"></LinearDoubleKeyFrame>
			</DoubleAnimationUsingKeyFrames>
		</Storyboard>
		<Storyboard x:Key="StoryFlip">
			<DoubleAnimationUsingKeyFrames Storyboard.TargetProperty="(AxisAngleRotation3D.Angle)"
										   Storyboard.TargetName="rotateY1">
				<SplineDoubleKeyFrame KeyTime="00:00:02" KeySpline="0,0,0,1" Value="180"></SplineDoubleKeyFrame>
			</DoubleAnimationUsingKeyFrames>
			<DoubleAnimationUsingKeyFrames Storyboard.TargetProperty="(AxisAngleRotation3D.Angle)"
										   Storyboard.TargetName="rotateY2">
				<SplineDoubleKeyFrame KeyTime="00:00:02" KeySpline="0,0,0,1" Value="360"></SplineDoubleKeyFrame>
			</DoubleAnimationUsingKeyFrames>
		</Storyboard>

		<Storyboard x:Key="StoryFlipBack">
			<DoubleAnimationUsingKeyFrames Storyboard.TargetProperty="(AxisAngleRotation3D.Angle)"
										   Storyboard.TargetName="rotateY1">
				<SplineDoubleKeyFrame KeyTime="00:00:02" KeySpline="0,0,0,1" Value="0"></SplineDoubleKeyFrame>
			</DoubleAnimationUsingKeyFrames>
			<DoubleAnimationUsingKeyFrames Storyboard.TargetProperty="(AxisAngleRotation3D.Angle)"
										   Storyboard.TargetName="rotateY2">
				<SplineDoubleKeyFrame KeyTime="00:00:02" KeySpline="0,0,0,1" Value="180"></SplineDoubleKeyFrame>
			</DoubleAnimationUsingKeyFrames>
		</Storyboard>
	</Window.Resources>
	<Viewport3D RenderTransformOrigin="0.5,0.5">
		<Viewport3D.RenderTransform>
			<TransformGroup>
				<ScaleTransform ScaleY="1.07"/>
				<SkewTransform/>
				<RotateTransform/>
				<TranslateTransform/>
			</TransformGroup>
		</Viewport3D.RenderTransform>
		<Viewport3D.Camera>
			<!-- 				カメラ位置				視野角				視線方向	-->
			<PerspectiveCamera x:Name="Camera"	Position="0, 0, 2.97"	FieldOfView="45"	LookDirection="0, 0, -1"/>
		</Viewport3D.Camera>

		<Viewport2DVisual3D  x:Name="CardBack">
			<!-- Give the plane a slight rotation -->
			<!-- カード裏面の3D表示設定 -->
			<Viewport2DVisual3D.Transform>
				<RotateTransform3D>
					<!-- Animationさせたい propertyには名前をつけておく -->
					<RotateTransform3D.Rotation>
						<AxisAngleRotation3D  x:Name="rotateY1" Angle="0" Axis="0, 1, 0" />
					</RotateTransform3D.Rotation>
				</RotateTransform3D>
			</Viewport2DVisual3D.Transform>

			<!-- The Geometry, Material, and Visual for the Viewport2DVisual3D -->
			<Viewport2DVisual3D.Geometry>
				<!-- 三角形2枚 -->
				<MeshGeometry3D Positions="-1,1,0 -1,-1,0 1,-1,0 1,1,0"
							TextureCoordinates="0,0 0,1 1,1 1,0" TriangleIndices="0 1 2 0 2 3"/>
			</Viewport2DVisual3D.Geometry>

			<Viewport2DVisual3D.Material>
				<!-- Control要素をこのControlの上に置く場合 IsVisualHostMaterial=Trueが必要です、とのことなので設定する -->
				<DiffuseMaterial Viewport2DVisual3D.IsVisualHostMaterial="True" Brush="White"/>
			</Viewport2DVisual3D.Material>
			<!-- 3D表示設定ここまで -->
			<!-- 3D Animation設定 -->
			<Image	x:Name="Back_image1"  Source="$res_img_cover" Stretch="None" >
				<Image.Triggers>
					<EventTrigger RoutedEvent="FrameworkElement.Loaded">
						<BeginStoryboard Storyboard="{StaticResource StoryLinear}" />
					</EventTrigger>
					<EventTrigger RoutedEvent="FrameworkElement.MouseEnter">
						<BeginStoryboard Storyboard="{StaticResource StoryFlip}" />
					</EventTrigger>
				</Image.Triggers>
			</Image>
		</Viewport2DVisual3D>

		<!-- カードのもう一面の定義。基本的には上の定義と同じ。 -->
		<Viewport2DVisual3D  x:Name="CardFront">
				<Viewport2DVisual3D.Transform>
					<RotateTransform3D>
						<RotateTransform3D.Rotation>
							<!-- Angleに 180を設定しているが、Visual Studioの編集画面でこの要素が消える以上の意味はない。どうせ animation定義で開始角度、終了角度を設定するんだから。 -->
							<AxisAngleRotation3D  x:Name="rotateY2" Angle="180" Axis="0, 1, 0" />
						</RotateTransform3D.Rotation>
					</RotateTransform3D>
				</Viewport2DVisual3D.Transform>

				<!-- The Geometry, Material, and Visual for the Viewport2DVisual3D -->
				<Viewport2DVisual3D.Geometry>
					<!-- Geometry定義も上と同じ。座標定義順がこっちは逆回転で、とか考えなくてもいい。同じように定義して、こちらは180度状態からの開始にする。 -->
					<MeshGeometry3D Positions="-1,1,0 -1,-1,0 1,-1,0 1,1,0"
							TextureCoordinates="0,0 0,1 1,1 1,0" TriangleIndices="0 1 2 0 2 3"/>
				</Viewport2DVisual3D.Geometry>

				<Viewport2DVisual3D.Material>
					<DiffuseMaterial Viewport2DVisual3D.IsVisualHostMaterial="True" Brush="White"/>
				</Viewport2DVisual3D.Material>

			<!-- Dialog要素で最も根本の Grid controlを回転対象にする。親要素が回れば子要素も回る。ちなみに dialog配置定義の ZIndexは 3Dには反映されない。されれば面白かったかも。 -->
			<Grid Name="grid" Margin="0,0,0,0" Width="407" Height="434"  ClipToBounds="True">
				<Grid.Triggers>
					<EventTrigger RoutedEvent="FrameworkElement.MouseLeave">
						<BeginStoryboard Storyboard="{StaticResource StoryFlipBack}" />
					</EventTrigger>
				</Grid.Triggers>
				<Border BorderThickness="0" CornerRadius="30">
					<Border.Background>
						<LinearGradientBrush EndPoint="1,1" StartPoint="0,0">
							<GradientStop Color="White"/>
							<GradientStop Color="#FFD7D7D7" Offset="1"/>
							<GradientStop Color="#FFBCBCBC" Offset="0.988"/>
							<GradientStop Color="#FFEAEAEA" Offset="0.81"/>
						</LinearGradientBrush>
					</Border.Background>
				</Border>
				<Label		x:Name="$($global:Controls[0].Name)"	Content="$($global:Controls[0].Content)"	Margin=" 40,  4, 40,  0"								VerticalAlignment="Top"																				FontSize="48" />
				<Label		x:Name="$($global:Controls[1].Name)"	Content="$($global:Controls[1].Content)"	Margin=" 40, 75,  0,  0"	HorizontalAlignment="Left"	VerticalAlignment="Top"																				HorizontalContentAlignment="Right" />
				<TextBox	x:Name="$($global:Controls[2].Name)"												Margin="145, 75, 93,  0"								VerticalAlignment="Top"		Height="34"												Cursor="Pen"	VerticalContentAlignment="Center" IsUndoEnabled="False" MaxLines="1" />
				<Button		x:Name="$($global:Controls[3].Name)"												Margin="  0, 75, 40,  0"	HorizontalAlignment="Right"	VerticalAlignment="Top"		Height="34" 	Width="54"		Background="White"		Cursor="Hand"	VerticalContentAlignment="Bottom" >
					<Image x:Name="image10" Source="$res_ico_folder" Margin="3,3,3,3" Height="22" Width="22"/>
				</Button>
				<Button		x:Name="$($global:Controls[4].Name)"												Margin=" 40,132, 41,  0"								VerticalAlignment="Top"		Height="53"						Background="White"		Cursor="Hand"	>
					<StackPanel Orientation="Horizontal">
						<Image x:Name="image1" Source="$res_ico_delete" Margin="10,10,0,10" Height="22" Width="22"/>
						<Label x:Name="label1" Content="$($global:Controls[4].Content)" VerticalContentAlignment="Center"/>
					</StackPanel>
				</Button>
				<CheckBox	x:Name="$($global:Controls[5].Name)"	Content="$($global:Controls[5].Content)" 	Margin=" 40,210,  0,  0"	HorizontalAlignment="Left"	VerticalAlignment="Top"																Cursor="Hand"	VerticalContentAlignment="Center" />
				<Button		x:Name="$($global:Controls[6].Name)"												Margin=" 40,255,  0,  0"	HorizontalAlignment="Left"	VerticalAlignment="Top"		Height="45"		Width="300"		Background="White"		Cursor="Hand"	>
					<StackPanel Orientation="Horizontal">
						<Image x:Name="image2" Source="$res_ico_start" Margin="5,5,0,5" Height="22" Width="22"/>
						<Label x:Name="label2" Content="$($global:Controls[6].Content)" VerticalContentAlignment="Center"/>
					</StackPanel>
				</Button>
				<Button		x:Name="$($global:Controls[8].Name)"												Margin="  0,  0, 40, 31"	HorizontalAlignment="Right" VerticalAlignment="Bottom"	Height="64"		Width="150"		Background="White"		Cursor="Hand"	IsDefault="True" >
					<StackPanel Orientation="Horizontal">
						<Image x:Name="image4" Source="$res_ico_exit" Margin="5,5,0,5" Height="30" Width="30"/>
						<Label x:Name="label4" Content="$($global:Controls[8].Content)" VerticalContentAlignment="Center"/>
					</StackPanel>
				</Button>
				<Image		x:Name="$($global:Controls[9].Name)"												Margin="145,210,-45,-77"																																	Source="$res_img_background" Panel.ZIndex="-100" Opacity="0.3" />
			</Grid>
		</Viewport2DVisual3D>

		<!-- Lights -->
		<ModelVisual3D>
			<ModelVisual3D.Content>
				<DirectionalLight Color="#FFFFFFFF" Direction="0,0,-1"/>
			</ModelVisual3D.Content>
		</ModelVisual3D>
	</Viewport3D>
</Window>
"@
}
