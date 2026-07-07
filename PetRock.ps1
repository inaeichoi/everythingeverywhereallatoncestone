Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$ErrorLogPath = Join-Path $PSScriptRoot 'PetRock.error.log'
function Log-Error([string]$context, $err) {
  "$(Get-Date -Format o) [$context] $err" | Out-File -FilePath $ErrorLogPath -Append -Encoding utf8
}

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public static class PetRockNativeInput {
    [StructLayout(LayoutKind.Sequential)]
    private struct LASTINPUTINFO {
        public uint cbSize;
        public uint dwTime;
    }

    [DllImport("user32.dll")]
    private static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

    [DllImport("kernel32.dll")]
    private static extern ulong GetTickCount64();

    public static double GetIdleMilliseconds() {
        LASTINPUTINFO info = new LASTINPUTINFO();
        info.cbSize = (uint)Marshal.SizeOf(typeof(LASTINPUTINFO));
        if (!GetLastInputInfo(ref info)) {
            return -1;
        }

        uint now = unchecked((uint)GetTickCount64());
        return unchecked(now - info.dwTime);
    }
}
'@

$xamlText = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="PetRock" Width="220" Height="176"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        Topmost="True" ShowInTaskbar="False" ResizeMode="NoResize" WindowStartupLocation="Manual">
  <Canvas Background="Transparent">
    <Viewbox Width="220" Height="176">
      <Canvas Width="300" Height="240">
        <Ellipse Canvas.Left="45" Canvas.Top="197" Width="210" Height="32">
          <Ellipse.Fill>
            <RadialGradientBrush>
              <GradientStop Color="#47000000" Offset="0"/>
              <GradientStop Color="#00000000" Offset="1"/>
            </RadialGradientBrush>
          </Ellipse.Fill>
        </Ellipse>

        <Canvas x:Name="RockBodyGroup">
          <Canvas.RenderTransform>
            <TranslateTransform x:Name="RockBobTransform" Y="0"/>
          </Canvas.RenderTransform>

          <Path Data="M46,168 C10,140 8,88 52,58 C86,34 130,10 186,14 C238,18 276,52 282,96 C288,142 262,182 214,204 C162,228 88,222 58,204 C40,192 30,180 46,168 Z">
            <Path.Fill>
              <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                <GradientStop Color="#FF6A6F74" Offset="0"/>
                <GradientStop Color="#FF4C5156" Offset="0.55"/>
                <GradientStop Color="#FF33373B" Offset="1"/>
              </LinearGradientBrush>
            </Path.Fill>
          </Path>
          <Path Data="M70,60 C110,30 170,20 220,40" Stroke="#5C6166" StrokeThickness="3" StrokeStartLineCap="Round" StrokeEndLineCap="Round" Opacity="0.5"/>
          <Ellipse Canvas.Left="73" Canvas.Top="58" Width="44" Height="24" Fill="#787D82" Opacity="0.28" RenderTransformOrigin="0.5,0.5">
            <Ellipse.RenderTransform><RotateTransform Angle="-18"/></Ellipse.RenderTransform>
          </Ellipse>
          <Ellipse Canvas.Left="194" Canvas.Top="136" Width="52" Height="28" Fill="#2C3033" Opacity="0.30" RenderTransformOrigin="0.5,0.5">
            <Ellipse.RenderTransform><RotateTransform Angle="10"/></Ellipse.RenderTransform>
          </Ellipse>
          <Ellipse Canvas.Left="110" Canvas.Top="175" Width="80" Height="20" Fill="#2C3033" Opacity="0.22"/>

          <Canvas x:Name="EyeL" Canvas.Left="87" Canvas.Top="99" Width="50" Height="58">
            <Canvas.Clip><EllipseGeometry Center="25,29" RadiusX="25" RadiusY="29"/></Canvas.Clip>
            <Canvas.RenderTransform>
              <ScaleTransform x:Name="EyeScaleL" ScaleX="1" ScaleY="1" CenterX="25" CenterY="29"/>
            </Canvas.RenderTransform>
            <Ellipse x:Name="SocketL" Width="50" Height="58" Fill="#F4F5F6"/>
            <Canvas x:Name="PupilGroupL" Canvas.Left="13" Canvas.Top="17">
              <Canvas.RenderTransform><TranslateTransform x:Name="PupilTransL" X="0" Y="0"/></Canvas.RenderTransform>
              <Ellipse Width="24" Height="24" Fill="#1C1E21"/>
              <Ellipse Canvas.Left="4" Canvas.Top="4" Width="5" Height="5" Fill="#F3F6F7"/>
            </Canvas>
            <Rectangle x:Name="LidTopL" Width="50" Height="34" Fill="#54585D">
              <Rectangle.RenderTransform><TranslateTransform x:Name="LidTopTransL" Y="-42"/></Rectangle.RenderTransform>
            </Rectangle>
            <Rectangle x:Name="LidBotL" Canvas.Top="34" Width="50" Height="34" Fill="#54585D">
              <Rectangle.RenderTransform><TranslateTransform x:Name="LidBotTransL" Y="42"/></Rectangle.RenderTransform>
            </Rectangle>
            <Path x:Name="HappyArcL" Data="M6,36 Q25,14 44,36" Stroke="#2B2F33" StrokeThickness="6" StrokeStartLineCap="Round" StrokeEndLineCap="Round" Opacity="0"/>
          </Canvas>

          <Canvas x:Name="EyeR" Canvas.Left="171" Canvas.Top="99" Width="50" Height="58">
            <Canvas.Clip><EllipseGeometry Center="25,29" RadiusX="25" RadiusY="29"/></Canvas.Clip>
            <Canvas.RenderTransform>
              <ScaleTransform x:Name="EyeScaleR" ScaleX="1" ScaleY="1" CenterX="25" CenterY="29"/>
            </Canvas.RenderTransform>
            <Ellipse x:Name="SocketR" Width="50" Height="58" Fill="#F4F5F6"/>
            <Canvas x:Name="PupilGroupR" Canvas.Left="13" Canvas.Top="17">
              <Canvas.RenderTransform><TranslateTransform x:Name="PupilTransR" X="0" Y="0"/></Canvas.RenderTransform>
              <Ellipse Width="24" Height="24" Fill="#1C1E21"/>
              <Ellipse Canvas.Left="4" Canvas.Top="4" Width="5" Height="5" Fill="#F3F6F7"/>
            </Canvas>
            <Rectangle x:Name="LidTopR" Width="50" Height="34" Fill="#54585D">
              <Rectangle.RenderTransform><TranslateTransform x:Name="LidTopTransR" Y="-42"/></Rectangle.RenderTransform>
            </Rectangle>
            <Rectangle x:Name="LidBotR" Canvas.Top="34" Width="50" Height="34" Fill="#54585D">
              <Rectangle.RenderTransform><TranslateTransform x:Name="LidBotTransR" Y="42"/></Rectangle.RenderTransform>
            </Rectangle>
            <Path x:Name="HappyArcR" Data="M6,36 Q25,14 44,36" Stroke="#2B2F33" StrokeThickness="6" StrokeStartLineCap="Round" StrokeEndLineCap="Round" Opacity="0"/>
          </Canvas>
        </Canvas>
      </Canvas>
    </Viewbox>
  </Canvas>
</Window>
'@

[xml]$xamlXml = $xamlText
$reader = New-Object System.Xml.XmlNodeReader $xamlXml
$window = [Windows.Markup.XamlReader]::Load($reader)

$pupilTransL   = $window.FindName('PupilTransL')
$pupilTransR   = $window.FindName('PupilTransR')
$eyeScaleL     = $window.FindName('EyeScaleL')
$eyeScaleR     = $window.FindName('EyeScaleR')
$lidTopTransL  = $window.FindName('LidTopTransL')
$lidTopTransR  = $window.FindName('LidTopTransR')
$lidBotTransL  = $window.FindName('LidBotTransL')
$lidBotTransR  = $window.FindName('LidBotTransR')
$socketL       = $window.FindName('SocketL')
$socketR       = $window.FindName('SocketR')
$pupilGroupL   = $window.FindName('PupilGroupL')
$pupilGroupR   = $window.FindName('PupilGroupR')
$happyArcL     = $window.FindName('HappyArcL')
$happyArcR     = $window.FindName('HappyArcR')
$rockBob       = $window.FindName('RockBobTransform')

$work = [System.Windows.SystemParameters]::WorkArea
$window.Left = $work.Left + ($work.Width - $window.Width) / 2
$window.Top  = $work.Top + ($work.Height - $window.Height) / 2

$IDLE_MS = 10000
$MAXOFF = 9.0
$LAG_K = 11.0
$STIFF = 90.0
$DAMP = 11.0
$SHAKE_SPEED_MIN = 0.35
$SHAKE_WINDOW_MS = 600
$SHAKE_REVERSALS = 3
$SHAKE_COOLDOWN_MS = 1200

$script:state = 'normal'
$script:stateUntil = [DateTime]::MinValue
$script:lastActivity = Get-Date
$script:isDragging = $false
$script:downWinLeft = 0; $script:downWinTop = 0
$script:downTime = Get-Date
$script:prevLeft = $window.Left
$script:prevTop = $window.Top
$script:pupilX = 0.0; $script:pupilY = 0.0
$script:pupilVX = 0.0; $script:pupilVY = 0.0
$script:lidProgress = 0.0
$script:scaleProgress = 0.0
$script:happyProgress = 0.0
$script:dozePhase = 0.0
$script:lastTick = Get-Date
$script:shakeHistory = New-Object System.Collections.Generic.List[psobject]
$script:lastShakeTime = [DateTime]::MinValue

function Set-State {
  param([string]$next, [int]$durationMs = 0)
  $script:state = $next
  if ($durationMs -gt 0) { $script:stateUntil = (Get-Date).AddMilliseconds($durationMs) }
  else { $script:stateUntil = [DateTime]::MinValue }
}

function Note-Activity {
  $script:lastActivity = Get-Date
  if ($script:state -eq 'sleepy') { Set-State 'normal' }
}

function Get-IdleMilliseconds {
  $manualIdle = ((Get-Date) - $script:lastActivity).TotalMilliseconds
  try {
    $globalIdle = [PetRockNativeInput]::GetIdleMilliseconds()
    if ($globalIdle -ge 0) {
      return [Math]::Min($manualIdle, [double]$globalIdle)
    }
  } catch {
    Log-Error 'GetIdleMilliseconds' $_
  }

  return $manualIdle
}

function Track-Shake {
  param([double]$vx, [double]$vy, [DateTime]$now)
  $speed = [Math]::Sqrt($vx * $vx + $vy * $vy)
  if ($speed -lt $SHAKE_SPEED_MIN) { return }
  $sign = if ($vx -ne 0) { [Math]::Sign($vx) } else { [Math]::Sign($vy) }
  $script:shakeHistory.Add([pscustomobject]@{ t = $now; s = $sign })
  while ($script:shakeHistory.Count -gt 0 -and ($now - $script:shakeHistory[0].t).TotalMilliseconds -gt $SHAKE_WINDOW_MS) {
    $script:shakeHistory.RemoveAt(0)
  }
  $reversals = 0
  for ($i = 1; $i -lt $script:shakeHistory.Count; $i++) {
    $a = $script:shakeHistory[$i - 1].s
    $b = $script:shakeHistory[$i].s
    if ($a -ne 0 -and $b -ne 0 -and $a -ne $b) { $reversals++ }
  }
  if ($reversals -ge $SHAKE_REVERSALS -and ($now - $script:lastShakeTime).TotalMilliseconds -gt $SHAKE_COOLDOWN_MS) {
    $script:lastShakeTime = $now
    Set-State 'surprised' 900
  }
}

$window.Add_MouseLeftButtonDown({
  param($s, $e)
  try {
    $script:downWinLeft = $window.Left; $script:downWinTop = $window.Top
    $script:downTime = Get-Date
    $script:shakeHistory.Clear()
    $script:isDragging = $true
    Note-Activity

    $window.DragMove()

    $script:isDragging = $false
    $dist = [Math]::Sqrt([Math]::Pow($window.Left - $script:downWinLeft, 2) + [Math]::Pow($window.Top - $script:downWinTop, 2))
    $dur = ((Get-Date) - $script:downTime).TotalMilliseconds
    if ($dist -lt 6 -and $dur -lt 400) { Set-State 'happy' 1100 }
    Note-Activity
  } catch { Log-Error 'MouseLeftButtonDown' $_; $script:isDragging = $false }
})

$window.Add_MouseRightButtonDown({ $window.Close() })

$timer = New-Object System.Windows.Threading.DispatcherTimer ([System.Windows.Threading.DispatcherPriority]::Render)
$timer.Interval = [TimeSpan]::FromMilliseconds(16)
$timer.Add_Tick({
 try {
  $now = Get-Date
  $dt = ($now - $script:lastTick).TotalMilliseconds
  if ($dt -le 0) { $dt = 16 }
  $dt = [Math]::Min($dt, 48)
  $script:lastTick = $now
  $dtSec = $dt / 1000.0

  if ($script:stateUntil -ne [DateTime]::MinValue -and $now -ge $script:stateUntil) {
    $script:state = 'normal'
    $script:stateUntil = [DateTime]::MinValue
  }

  $idleMs = Get-IdleMilliseconds
  if ($script:state -eq 'sleepy' -and $idleMs -lt $IDLE_MS) {
    Set-State 'normal'
  }

  if ($script:state -ne 'sleepy' -and $script:state -ne 'happy' -and $script:state -ne 'surprised') {
    if ($idleMs -gt $IDLE_MS) { Set-State 'sleepy' }
  }

  $curLeft = $window.Left; $curTop = $window.Top
  $rvx = ($curLeft - $script:prevLeft) / $dt
  $rvy = ($curTop - $script:prevTop) / $dt
  $script:prevLeft = $curLeft; $script:prevTop = $curTop

  if ($script:isDragging) {
    Track-Shake $rvx $rvy $now
    Note-Activity
  }

  $targetX = [Math]::Max(-$MAXOFF, [Math]::Min($MAXOFF, -$rvx * $LAG_K))
  $targetY = [Math]::Max(-$MAXOFF, [Math]::Min($MAXOFF, -$rvy * $LAG_K))

  $accX = $STIFF * ($targetX - $script:pupilX) - $DAMP * $script:pupilVX
  $script:pupilVX += $accX * $dtSec
  $script:pupilX += $script:pupilVX * $dtSec

  $accY = $STIFF * ($targetY - $script:pupilY) - $DAMP * $script:pupilVY
  $script:pupilVY += $accY * $dtSec
  $script:pupilY += $script:pupilVY * $dtSec

  $script:pupilX = [Math]::Max(-$MAXOFF, [Math]::Min($MAXOFF, $script:pupilX))
  $script:pupilY = [Math]::Max(-$MAXOFF, [Math]::Min($MAXOFF, $script:pupilY))

  $pupilTransL.X = $script:pupilX; $pupilTransL.Y = $script:pupilY
  $pupilTransR.X = $script:pupilX; $pupilTransR.Y = $script:pupilY

  $lidTarget = if ($script:state -eq 'sleepy') { 1.0 } else { 0.0 }
  $script:lidProgress += ($lidTarget - $script:lidProgress) * 0.12
  $lt = -42 + 42 * $script:lidProgress
  $lb = 42 - 42 * $script:lidProgress
  $lidTopTransL.Y = $lt; $lidTopTransR.Y = $lt
  $lidBotTransL.Y = $lb; $lidBotTransR.Y = $lb

  $scaleTarget = if ($script:state -eq 'surprised') { 1.0 } else { 0.0 }
  $script:scaleProgress += ($scaleTarget - $script:scaleProgress) * 0.25
  $sc = 1.0 + 0.24 * $script:scaleProgress
  $eyeScaleL.ScaleX = $sc; $eyeScaleL.ScaleY = $sc
  $eyeScaleR.ScaleX = $sc; $eyeScaleR.ScaleY = $sc

  $happyTarget = if ($script:state -eq 'happy') { 1.0 } else { 0.0 }
  $script:happyProgress += ($happyTarget - $script:happyProgress) * 0.35
  $happyArcL.Opacity = $script:happyProgress; $happyArcR.Opacity = $script:happyProgress
  $socketL.Opacity = 1.0 - $script:happyProgress; $socketR.Opacity = 1.0 - $script:happyProgress
  $pupilGroupL.Opacity = 1.0 - $script:happyProgress; $pupilGroupR.Opacity = 1.0 - $script:happyProgress

  if ($script:state -eq 'sleepy') {
    $script:dozePhase += $dtSec
    $rockBob.Y = [Math]::Sin($script:dozePhase * (2 * [Math]::PI / 3.2)) * 3.0
  } else {
    $script:dozePhase = 0
    $rockBob.Y = $rockBob.Y * 0.8
  }
 } catch { Log-Error 'Tick' $_ }
})
$timer.Start()

$window.Add_Closed({ $timer.Stop() })

$window.ShowDialog() | Out-Null
