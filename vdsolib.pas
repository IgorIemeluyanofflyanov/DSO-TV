﻿unit vdsolib;

interface

uses System.Types;

const
  TRIGGER_MODE_AUTO = 0;
  TRIGGER_MODE_LIANXU = 1;
  TRIGGER_STYLE_NONE = $0000;
  TRIGGER_STYLE_RISE_EDGE = $0001;
  TRIGGER_STYLE_FALL_EDGE = $0002;
  TRIGGER_STYLE_EDGE = $0004;
  TRIGGER_STYLE_P_MORE = $0008;
  TRIGGER_STYLE_P_LESS = $0010;
  TRIGGER_STYLE_P = $0020;
  TRIGGER_STYLE_N_MORE = $0040;
  TRIGGER_STYLE_N_LESS = $0080;
  TRIGGER_STYLE_N = $0100;

type
  AddCallBack = procedure(ppara: Pointer); stdcall;
  RemoveCallBack = procedure(ppara: Pointer); stdcall;

type
  cppchar = byte;

  IOReadStateCallBack = procedure(ppara: Pointer; channel: cppchar;
    state: integer); stdcall;


type
  fNoticeCallBack = procedure(aData: Pointer); stdcall;

type
  PNoticeCallBack = ^fNoticeCallBack;


type
  TDwordArray = array [0 .. 0] of System.Types.DWORD;

type
  TDoubleArray = array [0 .. 0] of Double;

type
  PDwordArray = ^TDwordArray;

type
  PDoubleArray = ^TDoubleArray;


type
  TReadData = procedure(aData: PDoubleArray; aSize: DWORD) of object;



const
  BX_SINE = $00;
  BX_SQUARE = $01;
  BX_TRIANGULAR = $02;
  BX_UP_SAWTOOTH = $03;
  BX_DOWN_SAWTOOTH = $04;

const
  DLLName = 'VDSO.dll';


function Capture(length: Integer; force_length: cppchar): Integer; stdcall;
  external DLLName delayed  name '_Capture@8';
procedure DDSOutputEnable(enable: Integer); stdcall;
  external DLLName delayed  name '_DDSOutputEnable@4';
function FinishDll: Integer; stdcall; external DLLName delayed  name '_FinishDll@0';
function GetAcDc(chn: Cardinal): Integer; stdcall;
  external DLLName delayed  name '_GetAcDc@4';
function GetDDSBiasResistance: Integer; stdcall;
  external DLLName delayed  name '_GetDDSBiasResistance@0';
function GetDDSBiasResistanceRangeMax: Integer; stdcall;
  external DLLName delayed  name '_GetDDSBiasResistanceRangeMax@0';
function GetDDSBiasResistanceRangeMin: Integer; stdcall;
  external DLLName delayed  name '_GetDDSBiasResistanceRangeMin@0';
function GetDDSSupportBoxingStyle(style: PInteger): Integer; stdcall;
  external DLLName delayed  name '_GetDDSSupportBoxingStyle@4';
function GetDDSZoomResistance: Integer; stdcall;
  external DLLName delayed  name '_GetDDSZoomResistance@0';
function GetDDSZoomResistanceRangeMax: Integer; stdcall;
  external DLLName delayed  name '_GetDDSZoomResistanceRangeMax@0';
function GetDDSZoomResistanceRangeMin: Integer; stdcall;
  external DLLName delayed  name '_GetDDSZoomResistanceRangeMin@0';
function GetIOState(channel: cppchar): integer; stdcall;



  external DLLName delayed  name '_GetIOState@4';
function GetMemoryLength: Cardinal; stdcall;
  external DLLName delayed  name '_GetMemoryLength@0';
function GetOnlyId0: Cardinal; stdcall; external DLLName delayed  name '_GetOnlyId0@0';
function GetOnlyId1: Cardinal; stdcall; external DLLName delayed  name '_GetOnlyId1@0';
function GetOscSample: Cardinal; stdcall;
  external DLLName delayed  name '_GetOscSample@0';
function GetOscSupportSampleNum: Integer; stdcall;
  external DLLName delayed  name '_GetOscSupportSampleNum@0';
function GetOscSupportSamples(sample: PDwordArray; maxnum: Integer): Integer;
  stdcall; external DLLName delayed  name '_GetOscSupportSamples@8';
function GetPreTriggerPercent: Integer; stdcall;
  external DLLName delayed  name '_GetPreTriggerPercent@0';
function GetSupportIoNumber: Integer; stdcall;
  external DLLName delayed  name '_GetSupportIoNumber@0';
function GetTriggerLevel: Integer; stdcall;
  external DLLName delayed  name '_GetTriggerLevel@0';
function GetTriggerMode: Cardinal; stdcall;
  external DLLName delayed  name '_GetTriggerMode@0';
function GetTriggerPulseWidthDownNs: Integer; stdcall;
  external DLLName delayed  name '_GetTriggerPulseWidthDownNs@0';
function GetTriggerPulseWidthNsMax: Integer; stdcall;
  external DLLName delayed  name '_GetTriggerPulseWidthNsMax@0';
function GetTriggerPulseWidthNsMin: Integer; stdcall;
  external DLLName delayed  name '_GetTriggerPulseWidthNsMin@0';
function GetTriggerPulseWidthUpNs: Integer; stdcall;
  external DLLName delayed  name '_GetTriggerPulseWidthUpNs@0';
function GetTriggerSenseDiv: Double; stdcall;
  external DLLName delayed  name '_GetTriggerSenseDiv@0';
function GetTriggerSource: Cardinal; stdcall;
  external DLLName delayed  name '_GetTriggerSource@0';
function GetTriggerStyle: Cardinal; stdcall;
  external DLLName delayed  name '_GetTriggerStyle@0';
function InitDll: Integer; stdcall; external DLLName delayed  name '_InitDll@0';
function IsDataReady: Integer; stdcall; external DLLName delayed  name '_IsDataReady@0';
function IsDDSOutputEnable: Integer; stdcall;
  external DLLName delayed  name '_IsDDSOutputEnable@0';
function IsDDSSupportSoftwareControlZoomBias: Integer; stdcall;
  external DLLName delayed  name '_IsDDSSupportSoftwareControlZoomBias@0';
function IsDevAvailable: Integer; stdcall;
  external DLLName delayed  name '_IsDevAvailable@0';
function IsIOReadStateReady: Integer; stdcall;
  external DLLName delayed  name '_IsIOReadStateReady@0';
function IsSupportAcDc: Integer; stdcall;
  external DLLName delayed  name '_IsSupportAcDc@0';
function IsSupportDDSDevice: Integer; stdcall;
  external DLLName delayed  name '_IsSupportDDSDevice@0';
function IsSupportHardTrigger: Integer; stdcall;
  external DLLName delayed  name '_IsSupportHardTrigger@0';
function IsSupportIODevice: Integer; stdcall;
  external DLLName delayed  name '_IsSupportIODevice@0';
function IsSupportPreTriggerPercent: Boolean; stdcall;
  external DLLName delayed  name '_IsSupportPreTriggerPercent@0';
function IsSupportRollMode: Integer; stdcall;
  external DLLName delayed  name '_IsSupportRollMode@0';
function IsSupportTriggerForce: Integer; stdcall;
  external DLLName delayed  name '_IsSupportTriggerForce@0';
function IsSupportTriggerSense: Integer; stdcall;
  external DLLName delayed  name '_IsSupportTriggerSense@0';
function IsVoltageDatasOutRange(channel: cppchar): Integer; stdcall;
  external DLLName delayed  name '_IsVoltageDatasOutRange@4';
procedure ReadIOState(channel: cppchar); stdcall;
  external DLLName delayed  name '_ReadIOState@4';
function ReadVoltageDatas(channel: cppchar; buffer: PDoubleArray; length: Cardinal)
  : Cardinal; stdcall; external DLLName delayed  name '_ReadVoltageDatas@12';
function ResetDevice: Integer; stdcall; external DLLName delayed  name '_ResetDevice@0';
procedure SetAcDc(chn: Cardinal; ac: Integer); stdcall;
  external DLLName delayed  name '_SetAcDc@8';
procedure SetDataReadyCallBack(ppara: Pointer; datacallback: PNoticeCallBack);
  stdcall; external DLLName delayed  name '_SetDataReadyCallBack@8';
procedure SetDataReadyEvent(dataevent: THandle); stdcall;
  external DLLName delayed  name '_SetDataReadyEvent@4';
procedure SetDDSBiasResistance(Resistance: Integer); stdcall;
  external DLLName delayed  name '_SetDDSBiasResistance@4';
procedure SetDDSBoxingStyle(boxing: Cardinal); stdcall;
  external DLLName delayed  name '_SetDDSBoxingStyle@4';
procedure SetDDSDutyCycle(cycle: Integer); stdcall;
  external DLLName delayed  name '_SetDDSDutyCycle@4';
procedure SetDDSPinlv(pinlv: Cardinal); stdcall;
  external DLLName delayed  name '_SetDDSPinlv@4';
procedure SetDDSZoomResistance(Resistance: Integer); stdcall;
  external DLLName delayed  name '_SetDDSZoomResistance@4';
procedure SetDevNoticeCallBack(ppara: Pointer; AddCallBack: AddCallBack;
  rmvcallback: RemoveCallBack); stdcall;
  external DLLName delayed  name '_SetDevNoticeCallBack@12';
procedure SetDevNoticeEvent(addevent, rmvevent: THandle); stdcall;
  external DLLName delayed  name '_SetDevNoticeEvent@8';
procedure SetIOInOut(channel, inout: Integer); stdcall;
  external DLLName delayed  name '_SetIOInOut@8';
procedure SetIOReadStateCallBack(ppara: Pointer; callback: IOReadStateCallBack);
  stdcall; external DLLName delayed  name '_SetIOReadStateCallBack@8';
procedure SetIOReadStateReadyEvent(dataevent: THandle); stdcall;
  external DLLName delayed  name '_SetIOReadStateReadyEvent@4';
procedure SetIOState(channel, state: Integer); stdcall;
  external DLLName delayed  name '_SetIOState@8';
function SetOscChannelRange(channel, minmv, maxmv: Integer): Integer; stdcall;
  external DLLName delayed  name '_SetOscChannelRange@12';
function SetOscSample(sample: Cardinal): Cardinal; stdcall;
  external DLLName delayed  name '_SetOscSample@4';
procedure SetPreTriggerPercent(front: Integer); stdcall;
  external DLLName delayed  name '_SetPreTriggerPercent@4';
function SetRollMode(en: Cardinal): Integer; stdcall;
  external DLLName delayed  name '_SetRollMode@4';
procedure SetTriggerLevel(level: Integer); stdcall;
  external DLLName delayed  name '_SetTriggerLevel@4';
procedure SetTriggerMode(mode: Cardinal); stdcall;
  external DLLName delayed  name '_SetTriggerMode@4';
procedure SetTriggerPulseWidthNs(down_ns, up_ns: Integer); stdcall;
  external DLLName delayed  name '_SetTriggerPulseWidthNs@8';
procedure SetTriggerSenseDiv(sense: Double); stdcall;
  external DLLName delayed  name '_SetTriggerSenseDiv@8';
procedure SetTriggerSource(source: Cardinal); stdcall;
  external DLLName delayed  name '_SetTriggerSource@4';
procedure SetTriggerStyle(style: Cardinal); stdcall;
  external DLLName delayed  name '_SetTriggerStyle@4';
procedure TriggerForce; stdcall; external DLLName delayed  name '_TriggerForce@0';

implementation

end.
