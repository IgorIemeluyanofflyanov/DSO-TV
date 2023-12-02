// https://github.com/vvkuzmin1973

unit uOSCmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, MMSystem,
  Forms,
  Dialogs, StdCtrls, uOSCReader, uOSCTV, ExtCtrls, ComCtrls, vdsolib, Vcl.Mask,
  Vcl.Samples.Spin;

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
    procedure TrackBar4Change(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }

    cnt: Integer;



    procedure OnDeviceReadData(aData: PDoubleArray; aDataSize: DWORD);

  end;

var
  FormuOSCR: TFormuOSCR;


implementation

{$R *.dfm}

uses Math;

function BW: HPALETTE;
var
  DC: HDC;
  BI: PBitMapInfo;
  Pal: PLogPalette;
  i: Integer;
  ResIdHandle: THandle;
  ResDataHandle: THandle;
  Bitmap: HBitmap;
  C: HWnd;
  OldPalette, Palette: HPALETTE;

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
//FinishDll;
end;

procedure TFormuOSCR.btn3Click(Sender: TObject);
begin
IsStopped:=true;
end;

procedure TFormuOSCR.FormCreate(Sender: TObject);
begin

  if InitDll() <> 1 then
    Raise Exception.CreateFmt('Unable init : ''%s''', ['VDSO.dll']);

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
    IsStopped := false;
  while  not  IsStopped do
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
  PaintBox1.Canvas.FillRect(Rect(Point(0, 0), Point(PaintBox1.Width,
    PaintBox1.Height)));


  var
    f1, f2: Double;

  f1 := -1000000;
  f2 := +10000000;

  var
  j := 0;
  PaintBox1.Canvas.MoveTo(j, 0);
  for var i := 0 to aDataSize - 1 do
  begin

    var
    f := aData[i] * TrackBar1.Position / 10;

    f1 := max(f1, f);
    f2 := min(f2, f);

    if i mod TrackBar2.Position = 0 then
    begin
      if TrackBar2.Position <> 1 then
        PaintBox1.Canvas.MoveTo(j, round(PaintBox1.Height * (0.5 - f1)));
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

  var
    stTime: DWORD;

  stTime := timeGetTime;
  GetMem(OSCDoubleBuff, fCaptureLength * 1024 * SizeOf(Double));

  stTime := timeGetTime;


  // while not DataIsReady do

  IsStopped := false;
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
IsStopped:=true;
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
SetAcDc(0,ifthen(CheckBoxACDC.Checked,1));
end;

procedure TFormuOSCR.CheckBoxTriggerClick(Sender: TObject);
begin
SetTriggerMode(IfThen(CheckBoxTrigger.Checked,1));
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

var Volatge :integer := StrToIntDef(ComboBoxChannelRange.Text, 5000);
     SetOscChannelRange(0, -Volatge,Volatge);
end;

procedure TFormuOSCR.ComboBoxTriggerSourceChange(Sender: TObject);
begin
SetTriggerSource(ComboBoxTriggerSource.ItemIndex);
end;

procedure TFormuOSCR.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
IsStopped:=true;
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
SetDDSPinlv(TrackBarSetDDSPinlv.Position );
end;

procedure TFormuOSCR.TrackBar4Change(Sender: TObject);
begin

end;

{$IFDEF staticlink1}

initialization

RegisterClass(TFormuOSCR);

{$ENDIF}

end.
