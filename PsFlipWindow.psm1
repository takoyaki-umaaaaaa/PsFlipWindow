# Dialog定義
function Xaml_FlipWindow(){
	$resource_image1 = Join-Path "$PSScriptRoot" "サラマンカ.jpg"
	$resource_image2 = Join-Path "$PSScriptRoot" "TrashCan.png"
	return @"
<Window xmlns  ="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Title="Window1" x:Name="basewindow" Height="680" Width="500"  WindowStyle="None" AllowsTransparency="True" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" Background="{x:Null}"  FontFamily="UD Digi Kyokasho N-R" FontSize="18">
	<Viewport3D>
		<Viewport3D.Camera>
			<!-- 				カメラ位置				視野角				視線方向	-->
			<PerspectiveCamera	Position="0, 0, 2.7"	FieldOfView="45"	LookDirection="0, 0, -1"/>
		</Viewport3D.Camera>

		<Viewport2DVisual3D  x:Name="CardBack">
			<!-- Give the plane a slight rotation -->
			<!-- カード裏面の3D表示設定 -->
			<Viewport2DVisual3D.Transform>
				<RotateTransform3D>
					<!-- Animationさせたい propertyには名前をつけておく -->
					<RotateTransform3D.Rotation>
						<AxisAngleRotation3D  x:Name="rotateB" Angle="0" Axis="0, 1, 0" />
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
			<Image	x:Name="image2"  Source="$resource_image1" Stretch="None">
				<Image.Triggers>
					<EventTrigger RoutedEvent="FrameworkElement.Loaded">
						<BeginStoryboard>
							<Storyboard RepeatBehavior="Forever">
								<Rotation3DAnimation	Storyboard.TargetName="CardBack"
														Storyboard.TargetProperty="(Viewport2DVisual3D.Transform).(RotateTransform3D.Rotation)"
														Duration  ="0:0:2"
														BeginTime ="0:0:0">
									<!-- 0～180度まで回転するが、実質見えるのは 0～90度まで。Backface cullingで消えるので。 -->
									<Rotation3DAnimation.From>
										<AxisAngleRotation3D Angle="0" Axis="0, 1, 0" />
									</Rotation3DAnimation.From>
									<Rotation3DAnimation.To>
										<AxisAngleRotation3D Angle="180" Axis="0, 1, 0" />
									</Rotation3DAnimation.To>
								</Rotation3DAnimation>
								<!-- 戻りの定義 -->
								<Rotation3DAnimation	Storyboard.TargetName="CardBack"
														Storyboard.TargetProperty="(Viewport2DVisual3D.Transform).(RotateTransform3D.Rotation)"
														Duration ="0:0:2"
														BeginTime="0:0:2">
									<Rotation3DAnimation.From>
										<AxisAngleRotation3D Angle="-180" Axis="0, 1, 0" />
									</Rotation3DAnimation.From>
									<Rotation3DAnimation.To>
										<AxisAngleRotation3D Angle="0" Axis="0, 1, 0" />
									</Rotation3DAnimation.To>
								</Rotation3DAnimation>
							</Storyboard>
						</BeginStoryboard>
					</EventTrigger>
				</Image.Triggers>
			</Image>
		</Viewport2DVisual3D>

		<!-- カードのもう一面の定義。基本的には上の定義と同じ。 -->
		<Viewport2DVisual3D  x:Name="CardFront">
				<!-- Give the plane a slight rotation -->
				<Viewport2DVisual3D.Transform>
					<RotateTransform3D>
						<RotateTransform3D.Rotation>
							<!-- Angleに 180を設定しているが、Visual Studioの編集画面でこの要素が消える以上の意味はない。どうせ animation定義で開始角度、終了角度を設定するんだから。 -->
							<AxisAngleRotation3D  x:Name="rotateF" Angle="180" Axis="0, 1, 0" />
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
			<Grid Margin="0,0,0,0" Background="White" Width="460" Height="485">
				<Grid.Triggers>
					<EventTrigger RoutedEvent="FrameworkElement.Loaded">
						<BeginStoryboard>
							<Storyboard RepeatBehavior="Forever">
								<Rotation3DAnimation	Storyboard.TargetName="CardFront"
														Storyboard.TargetProperty="(Viewport2DVisual3D.Transform).(RotateTransform3D.Rotation)"
														Duration ="0:0:2"
														BeginTime="0:0:0">
									<Rotation3DAnimation.From>
										<AxisAngleRotation3D Angle="-180" Axis="0, 1, 0" />
									</Rotation3DAnimation.From>
									<Rotation3DAnimation.To>
										<AxisAngleRotation3D Angle="0" Axis="0, 1, 0" />
									</Rotation3DAnimation.To>
								</Rotation3DAnimation>
								<Rotation3DAnimation	Storyboard.TargetName="CardFront"
														Storyboard.TargetProperty="(Viewport2DVisual3D.Transform).(RotateTransform3D.Rotation)"
														Duration ="0:0:2"
														BeginTime="0:0:2">
									<Rotation3DAnimation.From>
										<AxisAngleRotation3D Angle="0" Axis="0, 1, 0" />
									</Rotation3DAnimation.From>
									<Rotation3DAnimation.To>
										<AxisAngleRotation3D Angle="180" Axis="0, 1, 0" />
									</Rotation3DAnimation.To>
								</Rotation3DAnimation>
							</Storyboard>
						</BeginStoryboard>
					</EventTrigger>
				</Grid.Triggers>
				<!-- Gridの子要素を定義。閉じるボタン以外はダミー -->
				<Label		x:Name="LBL_Title"	Content="設定"														Margin="40,4,40,0"			VerticalAlignment="Top"								FontSize="48" />
				<Label		x:Name="label"		Content="画像保存先"					HorizontalAlignment="Left"	Margin="40,75,0,0"			VerticalAlignment="Top"	HorizontalContentAlignment="Right" />
				<TextBox	x:Name="textBox"																		Margin="145,75,93,0"	VerticalAlignment="Top"		Height="34"	IsUndoEnabled="False" MaxLines="1" VerticalContentAlignment="Center" Cursor="Pen" />
				<Button		x:Name="button"		Content="…" 				 			HorizontalAlignment="Right"	Margin="0,75,40,0"		VerticalAlignment="Top"		Height="34" Width="54" VerticalContentAlignment="Bottom"	/>
				<Button		x:Name="button1"											Margin="40,132,40,0"		VerticalAlignment="Top"		Height="53"	Cursor="Hand" >
					<StackPanel Orientation="Horizontal">
						<Image x:Name="image1" Source="$resource_image2" Margin="10,10,0,10" Width="20" Height="20"/>
						<Label x:Name="label1" Content="保存先情報を削除" VerticalContentAlignment="Center"/>
					</StackPanel>
				</Button>
				<CheckBox	x:Name="checkBox"	Content="保存後に画像を表示" 			HorizontalAlignment="Left"	Margin="40,210,0,0"			VerticalAlignment="Top"	VerticalContentAlignment="Center" />
				<Button		x:Name="button2"	Content="スタートメニューに&#xD;&#xA;登録する"	HorizontalAlignment="Left"	Margin="40,247,0,0"			VerticalAlignment="Top"		Height="45"	Width="260" Opacity="0.3" />
				<Button		x:Name="button3"	Content="アンインストール"				HorizontalAlignment="Left"	Margin="40,327,0,0"			VerticalAlignment="Top"		Height="42"	Width="260"	Foreground="Red" BorderBrush="Red" />
				<Button		x:Name="button4"	Content="閉じる"						HorizontalAlignment="Right" Margin="0,0,40,31"			VerticalAlignment="Bottom"	Height="64"	Width="114" IsDefault="True" Background="White" />
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