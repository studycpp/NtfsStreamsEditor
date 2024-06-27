unit aboutUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ChildFormUnit, ExtCtrls, OleCtrls, SHDocVw, AppEvnts;

type
  TAboutForm = class(TChildForm)
    WB1: TWebBrowser;
    Splitter1: TSplitter;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses Activex;

{$R *.dfm}
{$R Additional.res}

function GetTempDirectory: String;
var
TempDir: array[0..MAX_PATH] of Char;
begin
GetTempPath(MAX_PATH, @TempDir);
Result := StrPas(TempDir);
end;

procedure TAboutForm.FormCreate(Sender: TObject);
var
  resStream: TResourceStream;
  tmphelpfile:string;
begin

  tmphelpfile:=GetTempDirectory+'NSE2HELP.mht';
  try
  resStream := TResourceStream.Create(HInstance, 'NSE2HELP', 'MHT');
  resStream.SaveToFile(tmphelpfile);
  finally
   FreeAndNil(resStream);
  end;
   WB1.Navigate(tmphelpfile);
end;

end.
