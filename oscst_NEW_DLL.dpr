program oscst_NEW_DLL;

uses
  Forms,
  uOSCmain in 'uOSCmain.pas' {FormuOSCR},
  uOSCReader in 'uOSCReader.pas',
  uOSCTV in 'uOSCTV.pas',
  vdsolib in 'vdsolib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormuOSCR, FormuOSCR);
  Application.Run;

end.
