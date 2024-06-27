unit BAKUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls;

type
  TBak_Form = class(TForm)
    Label1: TLabel;
    BAK_LB: TListBox;
    Bak_name_EB: TButtonedEdit;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    ImageList1: TImageList;
    SaveDialog1: TSaveDialog;
    procedure Bak_name_EBRightButtonClick(Sender: TObject);
    procedure Bak_name_EBChange(Sender: TObject);
    procedure Bak_name_EBKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    realfile:string;
  end;

var
  Bak_Form: TBak_Form;

implementation

uses ScanUnit;

{$R *.dfm}

procedure TBak_Form.Bak_name_EBChange(Sender: TObject);
var I:integer;
    tmpstr:string;
begin
    realfile:=Bak_name_EB.Text;
    SaveDialog1.FileName:=ExtractFilename(realfile);
    BAK_LB.Items.BeginUpdate;
    BAK_LB.Clear;
    for I := 0 to BAK_SourceFiles.Count - 1 do
    begin
      tmpstr:=BAK_SourceFiles[i]+'  >>  '+realfile;
      BAK_LB.AddItem(tmpstr,nil);
    end;
    BAK_LB.Items.EndUpdate;
end;

procedure TBak_Form.Bak_name_EBKeyPress(Sender: TObject; var Key: Char);
begin
   Bak_name_EBRightButtonClick(self);
end;

procedure TBak_Form.Bak_name_EBRightButtonClick(Sender: TObject);
begin
     SaveDialog1.InitialDir:=ExtractFilepath(Bak_name_EB.Text);
   SaveDialog1.FileName:=ExtractFileName(Bak_name_EB.Text);
  if SaveDialog1.Execute(handle) then
   begin
    Bak_name_EB.Text:=SaveDialog1.FileName;
   end;
end;

end.
