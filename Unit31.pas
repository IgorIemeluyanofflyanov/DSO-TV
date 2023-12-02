unit Unit31;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TForm31 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form31: TForm31;

implementation

uses
  vdsolib;

{$R *.dfm}

procedure TForm31.FormCreate(Sender: TObject);
begin
InitDll;


Capture(1,'a');

end;

end.
