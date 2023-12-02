// https://github.com/vvkuzmin1973

unit uOSCmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, MMSystem,
  Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls, vdsolib, Vcl.Samples.Spin;

type
  TOSCTVstatus = (osSetup, osProcessData, osWaitFirstFrame, osWaitNewFrame, osWaitEndRow, osWaitStartRowOrFrame);

type
  TFormuOSCR = class(TForm)
    img1: TImage;
    pnl1: TPanel;
    lst1: TListBox;
    btnReadGraph: TButton;
    btn3: TButton;
    btnReadTV: TButton;
    btn6: TButton;
    odmain: TOpenDialog;
    tbGain: TTrackBar;
    tbDelta: TTrackBar;
    PaintBox1: TPaintBox;
    Memo1: TMemo;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Splitter2: TSplitter;
    bbDDSOutputEnable: TButton;
    Button1: TButton;
    ComboBoxChannelRange: TComboBox;
    CheckBoxACDC: TCheckBox;
    TrackBarSetDDSPinlv: TTrackBar;
    TrackBarDDSDutyCycle: TTrackBar;
    ComboBoxDDSBoxingStyle: TComboBox;
    ButtonFinishDll: TButton;
    ButtonResetDevice: TButton;
    Panel2: TPanel;
    CheckBoxTrigger: TCheckBox;
    ComboBoxTriggerStyle: TComboBox;
    ComboBoxTriggerSource: TComboBox;
    SpinEditTriggerLevel: TSpinEdit;
    GroupBox1: TGroupBox;
    TrackBar3: TTrackBar;
    procedure FormDestroy(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnReadGraphClick(Sender: TObject);
    procedure btnReadTVClick(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure bbDDSOutputEnableClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonResetDeviceClick(Sender: TObject);
    procedure ButtonFinishDllClick(Sender: TObject);
    procedure CheckBoxACDCClick(Sender: TObject);
    procedure CheckBoxTriggerClick(Sender: TObject);
    procedure ComboBoxTriggerStyleChange(Sender: TObject);
    procedure ComboBoxDDSBoxingStyleChange(Sender: TObject);
    procedure ComboBoxChannelRangeChange(Sender: TObject);
    procedure ComboBoxTriggerSourceChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tbDeltaChange(Sender: TObject);

    procedure lst1Click(Sender: TObject);
    procedure SpinEditTriggerLevelChange(Sender: TObject);
    procedure TrackBarDDSDutyCycleChange(Sender: TObject);
    procedure TrackBarSetDDSPinlvChange(Sender: TObject);

  public
    { Public declarations }

    cnt: Integer;
    procedure OnDeviceReadData(aData: PDoubleArray; aDataSize: DWORD);

  end;

var
  FormuOSCR: TFormuOSCR;

function CurrentPosInMicroSec: Int64;

type
  TSynhroPulse = (spNone, spHSYN, spVSYN);

function IsSynhroPulse(PulseData: Double): TSynhroPulse;

procedure ChangeStat(aNewStat: TOSCTVstatus);

procedure TOSCTV_Create;

function VoltToColor(Volt: Double): Byte;

function StatusAsString(OSCTVstatus: TOSCTVstatus): string;

procedure OnReadDataTV(aData: PDoubleArray; aSize: DWORD);

procedure OnNewFrame;

procedure DevNoticeCallBack(aData: Pointer); stdcall;

procedure DataReadyCallBack(aData: Pointer); stdcall;

procedure DevRemoveCallBack(aData: Pointer); stdcall;

implementation

{$R *.dfm}

uses
  Math;

var
  IsStopped: Boolean;
  fSampleRate: DWORD;
  fStatus: TOSCTVstatus;
  fBytesPerMicroSec: Integer;
  fCurrentPosInBytes: Int64;
  fBytesInColor: Integer;
  lastTimeSynhroPulse: Int64;
  timeTolastTimeSynhroPulse: Int64;
  synhroTimes: Integer;
  VSYNcount: Integer;
  xPos: Integer;
  RowNum: Integer;
  synhroVoltageLevel: Double;
  lastPulseData: Double;
  aRowData: PByteArray;
  MaxX: DWORD;
  lastRowsValues: PDoubleArray;
  BuffProcess: Integer;
  IsEvenFrame: Boolean;
  DebugVoltage: Double;
  MinVoltageLevel: Double;
  MaxVoltageLevel: Double;
  ColorVoltageGain: Double;
  ColorVoltageDelta: Double;
  DebugStr: string;
  fRealLength, fCaptureLength: DWORD;
  DataIsReady: Boolean;
  DeviceIsReady: Boolean;
  OSCDoubleBuff: PDoubleArray;
  ReadBytesFromOSC: DWORD;
  ChannelNum: Integer;

  // function SetOscSample(Sample: DWORD): Integer; stdcall;
  // external 'VDSO.dll' delayed  name '_SetOscSample@4';

function BW: HPALETTE;
var
  Bitmap: HBitmap;
  i: Integer;
  Pal: PLogPalette;
  Palette: HPALETTE;
begin
  Bitmap := 0;
  Palette := 0;

  GetMem(Pal, SizeOf(TLogPalette) + 256 * SizeOf(TPaletteEntry));
  for i := 0 to 255 do
    with Pal^.palPalEntry[i] do
    begin

      // case i of
      // 0..32    : begin peRed  := 0;  peGreen:= 0; peBlue := 0; end;
      // 33..64   : begin peRed  := 0;  peGreen:= 0; peBlue := 255; end;
      // 65..96   : begin peRed  := 255;  peGreen:= 0; peBlue := 0; end;
      // 97..128  : begin peRed  := 255;  peGreen:= 0; peBlue := 255; end;
      // 129..160 : begin peRed  := 0;  peGreen:= 255; peBlue := 0; end;
      // 161..192 : begin peRed  := 0;  peGreen:= 255; peBlue := 255; end;
      // 193..224 : begin peRed  := 255;  peGreen:= 255; peBlue := 0; end;
      // 225..256 : begin peRed  := 255;  peGreen:= 255; peBlue := 255; end;
      // end;

      peRed := i;
      peGreen := i;
      peBlue := i;
      peFlags := 0;
      peFlags := 0;
    end;
  Pal^.palNumEntries := 256;
  Pal^.palVersion := $300;
  Palette := CreatePalette(Pal^);
  result := Palette;
  // FreeMem(Pal, SizeOf(TLogPalette) + 256 * SizeOf(TPaletteEntry));
end;

procedure TFormuOSCR.FormDestroy(Sender: TObject);
begin
  // FinishDll;
end;

procedure TFormuOSCR.btn3Click(Sender: TObject);
begin
  IsStopped := true;
end;

procedure TFormuOSCR.FormCreate(Sender: TObject);
begin

  if InitDll() <> 1 then
    raise Exception.CreateFmt('Unable init : ''%s''', ['VDSO.dll']);

  Memo1.text := format('Id %X %X', [GetOnlyId0(), GetOnlyId1()]);

  SetDevNoticeCallBack(nil, @DevNoticeCallBack, @DevRemoveCallBack);
  SetDataReadyCallBack(nil, @DataReadyCallBack);

end;

procedure TFormuOSCR.btnReadGraphClick(Sender: TObject);
var
  stTime: DWORD;
begin
  inherited;
  stTime := timeGetTime;
  GetMem(OSCDoubleBuff, fCaptureLength * 1024 * SizeOf(Double));

  stTime := timeGetTime;
  DataIsReady := False;

  // while not DataIsReady do
  IsStopped := False;
  while not IsStopped do
  begin

    fRealLength := Capture(fCaptureLength, 0);
    fRealLength := fRealLength * 1024;

    while true do
    begin
      Application.ProcessMessages;
      // if timeGetTime > stTime + 5000 then
      // Raise Exception.CreateFmt
      // ('Waiting for data resulted in an error : %d', [5000]);

      if DataIsReady then
      begin
        OnDeviceReadData(OSCDoubleBuff, ReadBytesFromOSC);
        break;
      end;
    end;

    // FreeMem(OSCDoubleBuff);
  end;
  FreeMem(OSCDoubleBuff);

end;

procedure TFormuOSCR.OnDeviceReadData(aData: PDoubleArray; aDataSize: DWORD);
begin
  DataIsReady := False;

  Inc(cnt);
  Label1.CAPTION := Format('%d Read file data len:%d', [cnt, aDataSize]);

  if aDataSize = 0 then
    Exit;

  PaintBox1.Canvas.Lock;

  PaintBox1.Canvas.Brush.Color := clWhite;
  PaintBox1.Canvas.Brush.Style := TBrushStyle.bsSolid;
  PaintBox1.Canvas.FillRect(Rect(Point(0, 0), Point(PaintBox1.Width, PaintBox1.Height)));

  var f1, f2: Double;

  f1 := -1000000;
  f2 := +10000000;

  var j := 0;
  PaintBox1.Canvas.MoveTo(j, 0);
  for var i := 0 to aDataSize - 1 do
  begin

    var f := (aData[i] - TrackBar3.Position ) * TrackBar1.Position / 10  ;

    f1 := max(f1, f);
    f2 := min(f2, f);

    if i mod TrackBar2.Position = 0 then
    begin
      if TrackBar2.Position <> 1 then
        PaintBox1.Canvas.MoveTo(j, round(PaintBox1.Height * (0.5- f1)));
      PaintBox1.Canvas.LineTo(j, round(PaintBox1.Height * (0.5 - f2)));

      f1 := -1000000;
      f2 := +10000000;
      Inc(j);
    end;
    if j > PaintBox1.Width - 20 then
      break;

  end;
  PaintBox1.Canvas.Unlock;

end;

procedure TFormuOSCR.btnReadTVClick(Sender: TObject);
begin
  img1.Picture.Bitmap.Create;
  img1.Picture.Bitmap.Width := img1.Width * 10;
  img1.Picture.Bitmap.Height := img1.Height * 5;
  img1.Picture.Bitmap.PixelFormat := pf8bit;
  img1.Picture.Bitmap.Palette := BW;

  TOSCTV_Create;

  var stTime: DWORD;

  stTime := timeGetTime;
  GetMem(OSCDoubleBuff, fCaptureLength * 1024 * SizeOf(Double));

  stTime := timeGetTime;


  // while not DataIsReady do

  IsStopped := False;
  while not IsStopped do
  begin

    fRealLength := Capture(fCaptureLength, 0);
    fRealLength := fRealLength * 1024;
    DataIsReady := False;

    while not DataIsReady do
      Application.ProcessMessages;

    OnReadDataTV(OSCDoubleBuff, ReadBytesFromOSC);

  end;
  FreeMem(OSCDoubleBuff);
end;

procedure TFormuOSCR.btn6Click(Sender: TObject);
begin
  IsStopped := true;
end;

procedure TFormuOSCR.bbDDSOutputEnableClick(Sender: TObject);
begin
  DDSOutputEnable(1);
end;

procedure TFormuOSCR.Button1Click(Sender: TObject);
begin
  DDSOutputEnable(0);
end;

procedure TFormuOSCR.ButtonResetDeviceClick(Sender: TObject);
begin
  ResetDevice;
end;

procedure TFormuOSCR.ButtonFinishDllClick(Sender: TObject);
begin
  FinishDll;
  Sleep(1000);
  FormCreate(nil);
end;

procedure TFormuOSCR.CheckBoxACDCClick(Sender: TObject);
begin
  SetAcDc(0, ifthen(CheckBoxACDC.Checked, 1));
end;

procedure TFormuOSCR.CheckBoxTriggerClick(Sender: TObject);
begin
  SetTriggerMode(ifthen(CheckBoxTrigger.Checked, 1));
end;

procedure TFormuOSCR.ComboBoxTriggerStyleChange(Sender: TObject);
begin
  SetTriggerStyle(ComboBoxTriggerStyle.ItemIndex);
end;

procedure TFormuOSCR.ComboBoxDDSBoxingStyleChange(Sender: TObject);
begin
  SetDDSBoxingStyle(ComboBoxDDSBoxingStyle.ItemIndex);
end;

procedure TFormuOSCR.ComboBoxChannelRangeChange(Sender: TObject);
begin

  var Volatge: Integer := StrToIntDef(ComboBoxChannelRange.Text, 5000);
  SetOscChannelRange(0, -Volatge, Volatge);
end;

procedure TFormuOSCR.ComboBoxTriggerSourceChange(Sender: TObject);
begin
  SetTriggerSource(ComboBoxTriggerSource.ItemIndex);
end;

procedure TFormuOSCR.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IsStopped := true;
end;

procedure TFormuOSCR.tbDeltaChange(Sender: TObject);
var
  d: Double;
begin

  d := tbGain.Position;
  ColorVoltageGain := d / 10;
  d := tbDelta.Position;
  ColorVoltageDelta := d / 10;

end;

procedure TFormuOSCR.lst1Click(Sender: TObject);
begin
  SetOscSample(StrToInt(lst1.Items[lst1.ItemIndex]));
end;

procedure TFormuOSCR.SpinEditTriggerLevelChange(Sender: TObject);
begin
  SetTriggerLevel(SpinEditTriggerLevel.Value);
end;

procedure TFormuOSCR.TrackBarDDSDutyCycleChange(Sender: TObject);
begin
  SetDDSDutyCycle(TrackBarDDSDutyCycle.Position);
end;

procedure TFormuOSCR.TrackBarSetDDSPinlvChange(Sender: TObject);
begin
  SetDDSPinlv(TrackBarSetDDSPinlv.Position);
end;

{ TOSCReaderDevice }

procedure DevRemoveCallBack(aData: Pointer); stdcall;
begin
  // ShowMessage('RemoveCallBack');
end;

procedure DevNoticeCallBack(aData: Pointer); stdcall;
var
  i: Integer;
  sample_num: Integer;
  smpArr: PDwordArray;
begin
  sample_num := GetOscSupportSampleNum();
  SetOscChannelRange(0, -6000, 6000);
  fCaptureLength := GetMemoryLength();

  GetMem(smpArr, sample_num * SizeOf(DWORD));
  GetOscSupportSamples(smpArr, sample_num);

  for i := 0 to sample_num - 1 do
    FormuOSCR.lst1.AddItem(Format('%d', [smpArr[i]]), nil);

  SetOscSample(smpArr[sample_num - 2]);
  // SetOscSample(12000000);
  fSampleRate := GetOscSample;
  DeviceIsReady := true;

end;

procedure DataReadyCallBack(aData: Pointer); stdcall;
begin
  ReadBytesFromOSC := ReadVoltageDatas(ChannelNum, OSCDoubleBuff, fRealLength);
  DataIsReady := true;
end;

procedure OnNewFrame;
begin
  Inc(FormuOSCR.cnt);
  FormuOSCR.img1.Repaint;
  // Memo1.Lines.Add(Format('NewFrame %d; %d',[cnt,OSCTV.PositionInMicroSec]));
end;

procedure OnNewRow(var RowDataToFill: Pointer; RowNumber: Integer; var MaxX: DWORD; var RowVolts: PDoubleArray);
begin
  if RowNumber < FormuOSCR.img1.Picture.Bitmap.Height then
    RowDataToFill := FormuOSCR.img1.Picture.Bitmap.ScanLine[RowNumber];
  MaxX := 1500;
  RowVolts := nil;
  {
    if FrameDoubleArray[RowNumber] = nil then
    GetMem(FrameDoubleArray[RowNumber],SizeOf(Double)*MaxX);

    RowVolts := FrameDoubleArray[RowNumber];
  }



  // Memo1.Lines.Add(Format('%.8dR %.7f %d ',[OSCTV.PositionInMicroSec, OSCTV.DebugVoltage, MaxX]));
  // img1.Picture.Bitmap.Width div 2;

  // lbl1.Caption:=format('Min: %.3f; Max: %.3f',[OSCTV.MinVoltageLevel, OSCTV.MaxVoltageLevel]);

  // img1.Repaint;
  Application.ProcessMessages;
  {
    if MaxRow <  RowNumber then
    begin
    Memo1.Lines.Add(Format('New max row in %d usec; %d',[OSCTV.PositionInMicroSec, RowNumber]));
    MaxRow:=RowNumber;
    end;
  }
end;

procedure ChangeStat(aNewStat: TOSCTVstatus);
begin
  fStatus := aNewStat;
end;

procedure TOSCTV_Create;
begin
  fStatus := osSetup;
  fBytesPerMicroSec := fSampleRate div 1000000;
  fCurrentPosInBytes := 0;
  fBytesInColor := 3;
  MinVoltageLevel := 0;
  MaxVoltageLevel := 0;
  lastTimeSynhroPulse := $FFFFFFFF;
  timeTolastTimeSynhroPulse := 0;
  synhroVoltageLevel := -30;
  aRowData := 0;
  ColorVoltageGain := 3;
  ColorVoltageDelta := 3;
  lastRowsValues := nil;
end;

function CurrentPosInMicroSec: Int64;
begin
  result := fCurrentPosInBytes div fBytesPerMicroSec;
end;

function IsSynhroPulse(PulseData: Double): TSynhroPulse;
begin
  result := spNone;
  if DWORD(fStatus) <= 0 then
    Exit;

  if (lastPulseData <= synhroVoltageLevel) then
    Inc(synhroTimes);

  if (synhroTimes div fBytesPerMicroSec > 15) and (lastPulseData > synhroVoltageLevel + 0.1) then // Pulse > 3us
  begin
    Inc(VSYNcount);
    if (VSYNcount > 18) then
    begin
      result := spVSYN;
      synhroTimes := 0;
      VSYNcount := 0;
    end;
  end;

  if (synhroTimes div fBytesPerMicroSec > 3) and (synhroTimes div fBytesPerMicroSec < 15) and (lastPulseData > synhroVoltageLevel + 0.1) then // Pulse > 3us
  begin
    result := spHSYN;
    synhroTimes := 0;
  end;

  lastPulseData := PulseData;
end;

procedure OnReadDataTV(aData: PDoubleArray; aSize: DWORD);
var
  aIsSynhroPulse: TSynhroPulse;
  i: Integer;
begin

  DataIsReady := False;

  Inc(BuffProcess);
  DebugStr := IntToStr(BuffProcess);
  // inherited;//(OnReadData) then  OnReadData (aData; aSize);

  i := 0;
  aRowData := nil;
  while (i < aSize) do
  begin

    DebugVoltage := aData[i];
    if (MinVoltageLevel > aData[i]) then
      MinVoltageLevel := aData[i];
    if (MaxVoltageLevel < aData[i]) then
      MaxVoltageLevel := aData[i];

    aIsSynhroPulse := IsSynhroPulse(aData[i]);

    if (DWORD(aIsSynhroPulse) > 0) then
      lastTimeSynhroPulse := CurrentPosInMicroSec;

    timeTolastTimeSynhroPulse := CurrentPosInMicroSec - lastTimeSynhroPulse;

    case fStatus of
      osSetup:
        begin
          if CurrentPosInMicroSec > 500 then // wait 500us
          begin
            synhroVoltageLevel := MinVoltageLevel + 0.15;
            ChangeStat(osProcessData);
          end;

        end;
      osProcessData:
        case aIsSynhroPulse of
          spNone:
            begin
              if (Assigned(aRowData)) and (xPos < MaxX) then
              begin
                aRowData[xPos] := VoltToColor(aData[i]);
                if lastRowsValues <> nil then
                  lastRowsValues[xPos] := aData[i];
                Inc(xPos);
              end;

            end;
          spVSYN:
            begin

              OnNewFrame;

              IsEvenFrame := not IsEvenFrame;

              if IsEvenFrame then
                RowNum := 0
              else
                RowNum := 1;
              MaxX := xPos;

              begin
                OnNewRow(Pointer(aRowData), RowNum, MaxX, lastRowsValues);
              end;
              xPos := 0;
            end;
          spHSYN:
            begin
              RowNum := RowNum + 2;

              MaxX := xPos;

              OnNewRow(Pointer(aRowData), RowNum, MaxX, lastRowsValues);

              xPos := 0;
            end;
        end;

    end;
    Inc(fCurrentPosInBytes);
    Inc(i);
  end;

end;

function StatusAsString(OSCTVstatus: TOSCTVstatus): string;
begin
  case OSCTVstatus of
    osWaitFirstFrame:
      result := 'osWaitFirstFrame';
    osWaitNewFrame:
      result := 'osWaitNewFrame';
    osWaitEndRow:
      result := 'osWaitEndRow';
    osWaitStartRowOrFrame:
      result := 'osWaitStartRowOrFrame';
  end;
end;

function VoltToColor(Volt: Double): Byte;
var
  delta: Double;
  rs: Double;
begin // MinVoltageLevel

  delta := (MaxVoltageLevel + Abs(MinVoltageLevel)) / ColorVoltageDelta;
  Volt := Abs(MinVoltageLevel - Volt) - delta;
  if Volt < 0 then
    Volt := 0;
  Volt := Volt * ColorVoltageGain;
  {
    DebugStr:=Format('Range: %.3f;',[MaxVoltageLevel + Abs(MinVoltageLevel)]);
    DebugStr:=Format('%sDelta: %.3f;',[DebugStr,delta]);
    DebugStr:=Format('%sVolt: %.3f',[DebugStr,Volt]);

  }
  rs := 255 * Volt / (MaxVoltageLevel + Abs(MinVoltageLevel));
  if rs > 255 then
    rs := 255;
  if rs < 0 then
    rs := 0;
  result := Ceil(rs)

end;

{$IFDEF staticlink1}

initialization
  RegisterClass(TFormuOSCR);

{$ENDIF}

end.

