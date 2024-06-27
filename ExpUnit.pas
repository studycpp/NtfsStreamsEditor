unit ExpUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList;

type
  TEXP_Form = class(TForm)
    EXp_LB: TListBox;
    label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    ExpPath_EB: TButtonedEdit;
    Label2: TLabel;
    ImageList1: TImageList;
    RadioButton1: TRadioButton;
    procedure ExpPath_EBChange(Sender: TObject);
    procedure ExpPath_EBRightButtonClick(Sender: TObject);
    procedure ExpPath_EBKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    realpath:string;
  end;

var
  EXP_Form: TEXP_Form;


implementation

uses ScanUnit,NSEKernel,FileCtrl;

{$R *.dfm}

procedure TEXP_Form.ExpPath_EBChange(Sender: TObject);
var tmpname,tmpstr:string;
    i:integer;
begin
  realpath:=IncludeTrailingPathDelimiter(ExpPath_EB.Text);

  EXp_LB.Items.BeginUpdate;
  EXp_LB.Clear;
   for I := 0 to EXP_SourceFiles.Count - 1 do
   begin
       tmpname:= realpath+TEXPThread_Rename(EXP_SourceFiles[i]);
       tmpstr:=EXP_SourceFiles[i]+'  ->  '+tmpname;
       Exp_LB.AddItem(tmpstr,nil);
   end;

  EXp_LB.Items.EndUpdate;
end;

procedure TEXP_Form.ExpPath_EBKeyPress(Sender: TObject; var Key: Char);
begin
    ExpPath_EBRightButtonClick(self);
end;

procedure TEXP_Form.ExpPath_EBRightButtonClick(Sender: TObject);
var pathstr:string;
begin
  pathstr:=ExpPath_EB.Text;
   if  Selectdirectory('Ñ¡Ôñ´ÅÅÌ/ÎÄ¼þ¼Ð','',pathstr) then
    begin
      if not DirectoryExists(pathstr)then Exit;
       ExpPath_EB.Text:=pathstr;
    end;
end;

end.
