program oscst_NEW_DLL;

uses
  Forms,
  uOSCmain in 'uOSCmain.pas' {FormuOSCR},
  vdsolib in 'vdsolib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormuOSCR, FormuOSCR);
  Application.Run;

end.
