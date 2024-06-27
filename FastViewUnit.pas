unit FastViewUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,NSEKernel;

type
  TFastViewForm = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Splitter1: TSplitter;
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    procedure Memo2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    procedure Redraw(filename:string);
  end;

var FastViewForm:TFastViewForm;

implementation

{$R *.dfm}

 procedure TFastViewForm.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#$1B then hide;
end;

procedure TFastViewForm.Memo2KeyPress(Sender: TObject; var Key: Char);
begin
if Key=#$1B then hide;
end;

procedure TFastViewForm.Redraw(filename: string);
 var tmptext:String;
 begin
   Caption:=filename;
   memo1.Lines.BeginUpdate;
   memo1.Lines.Clear;
   memo2.Lines.BeginUpdate;
   memo2.Lines.Clear;
   try
   ReadTextFileFast(filename,tmptext);
   memo1.Lines.Add(tmptext);
   ReadHexFileFast(filename,tmptext);
   memo2.Lines.Add(tmptext);
   except

   end;
   memo1.Lines.EndUpdate;
   memo2.Lines.EndUpdate;
 end;

end.
