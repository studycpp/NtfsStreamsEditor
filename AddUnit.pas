unit AddUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, ExtCtrls;

type
  TAdd_Form = class(TForm)
    ADD_LB: TListBox;
    Label2: TLabel;
    Add_src_EB: TButtonedEdit;
    Button1: TButton;
    Button2: TButton;
    ImageList1: TImageList;
    Label3: TLabel;
    Add_name_Edit: TEdit;
    Add_ReWrite_CB: TCheckBox;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    procedure Add_Opt_Change(Sender: TObject);
    procedure Add_ReWrite_CBClick(Sender: TObject);
    procedure Add_src_EBRightButtonClick(Sender: TObject);
    procedure Add_src_EBKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    realfile:string;
    realname:string;
    realOver:Bool;
  end;

var
  Add_Form: TAdd_Form;

implementation


uses ScanUnit,NSEKernel;

{$R *.dfm}

procedure TAdd_Form.Add_ReWrite_CBClick(Sender: TObject);
begin
    realOver:=Add_ReWrite_CB.Checked;
end;

procedure TAdd_Form.Add_src_EBKeyPress(Sender: TObject; var Key: Char);
begin
   Add_src_EBRightButtonClick(self);
end;

procedure TAdd_Form.Add_src_EBRightButtonClick(Sender: TObject);
begin
 if OpenDialog1.Execute(handle) then
   Add_src_EB.Text:= OpenDialog1.FileName;
end;

procedure TAdd_Form.Add_Opt_Change(Sender: TObject);
var tmpname:string;
    i:integer;
begin
     realfile:=Add_src_EB.Text;
     realname:=Add_Name_Edit.Text;
     realOver:=Add_ReWrite_CB.Checked;

     ADD_LB.Items.BeginUpdate;
     ADD_LB.Clear;
      for I := 0 to ADD_SourceFiles.Count - 1 do
      begin
        tmpname:=ADD_SourceFiles[i]+':'+realname;
        ADD_LB.AddItem(tmpname,nil);
      end;

      ADD_LB.Items.EndUpdate;
end;

end.
