unit uOSCReader;

interface

uses Windows, Classes, SysUtils, Forms, MMSystem, vdsolib  ;
type
  TOSCTVstatus = (osSetup, osProcessData, osWaitFirstFrame, osWaitNewFrame,
    osWaitEndRow, osWaitStartRowOrFrame);


var
            IsStopped: Boolean;
    fSampleRate: DWORD;
    fDataArray: array of Double;
    fCaptureIsReady: Boolean;

    fStatus: TOSCTVstatus;
    fBytesPerMicroSec: Integer;
    fCurrentPosInBytes: Int64;
    fBytesInColor: Integer;
    lastPossynhroNewFrameVoltage: Int64;
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

//  function SetOscSample(Sample: DWORD): Integer; stdcall;
//  external 'VDSO.dll' delayed  name '_SetOscSample@4';
procedure DevNoticeCallBack(aData: Pointer); stdcall;
procedure DataReadyCallBack(aData: Pointer); stdcall;
procedure DevRemoveCallBack(aData: Pointer); stdcall;


implementation


//function InitDll: Integer; stdcall; external 'VDSO.dll' delayed   name '_InitDll@0';
//function FinishDll: Integer; stdcall; external 'VDSO.dll' delayed  name '_FinishDll@0';
//function GetOscSupportSampleNum: Integer; stdcall;
//  external 'VDSO.dll' delayed  name '_GetOscSupportSampleNum@0';
//function IsDevAvailable: Integer; stdcall;
//  external 'VDSO.dll' delayed  name '_IsDevAvailable@0';
//procedure SetDevNoticeCallBack(aData: Pointer; AddCallBack: PNoticeCallBack;
//  RemoveCallBack: PNoticeCallBack); stdcall;
//  external 'VDSO.dll' delayed  name '_SetDevNoticeCallBack@12';
//procedure SetDataReadyCallBack(aData: Pointer;
//  DataReadyCallBack: PNoticeCallBack); stdcall;
//  external 'VDSO.dll' delayed  name '_SetDataReadyCallBack@8';
//function Capture(Capture_length: Integer): Integer; stdcall;
//  external 'VDSO.dll' delayed  name '_Capture@4';
//function IsDataReady: Integer; stdcall;
//  external 'VDSO.dll' delayed  name '_IsDataReady@0';
//function GetOscSupportSamples(Samples: Pointer; NumSamples: Integer): Integer;
//  stdcall; external 'VDSO.dll' delayed  name '_GetOscSupportSamples@8';
//function ReadVoltageDatas(Channel: Integer; DoubleArray: Pointer;
//  DataLen: DWORD): DWORD; stdcall;
//  external 'VDSO.dll' delayed  name '_ReadVoltageDatas@12';
//function SetOscChannelRange(Channel, Minmv, Maxmv: Integer): Integer; stdcall;
//  external 'VDSO.dll' delayed  name '_SetOscChannelRange@12';
//function GetMemoryLength: DWORD; stdcall;
//  external 'VDSO.dll' delayed  name '_GetMemoryLength@0';

{ TOSC }


uses uOSCmain;



{ TOSCReaderDevice }

procedure DevRemoveCallBack(aData: Pointer); stdcall;
begin
  // ShowMessage('RemoveCallBack');
end;

procedure DevNoticeCallBack(aData: Pointer); stdcall;
var
  sample_num, i: Integer;
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
//   SetOscSample(12000000);
 fSampleRate := GetOscSample ;
  DeviceIsReady := True;
 end;

procedure DataReadyCallBack(aData: Pointer); stdcall;
begin
  ReadBytesFromOSC := ReadVoltageDatas(ChannelNum, OSCDoubleBuff, fRealLength);
  DataIsReady := True;
end;







end.
