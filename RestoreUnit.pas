unit RestoreUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls;

type
  TRestore_Form = class(TForm)
    Label1: TLabel;
    Restore_name_EB: TButtonedEdit;
    Button1: TButton;
    Button2: TButton;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    REstore_ReWrite_CB: TCheckBox;
    Restore_LB: TListBox;
    Label2: TLabel;
    procedure Restore_name_EBRightButtonClick(Sender: TObject);
    procedure Restore_name_EBChange(Sender: TObject);
    procedure REstore_ReWrite_CBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Restore_name_EBKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    realfile:string;
    realover:bool;
    MyList: TList;
  end;

var
  Restore_Form: TRestore_Form;


implementation

uses NSEKernel;
{$R *.dfm}

procedure TRestore_Form.FormCreate(Sender: TObject);
begin
MyList:=TList.Create;
end;

procedure TRestore_Form.Restore_name_EBChange(Sender: TObject);
var //ret:bool;
    i:integer;
    tmprec:Prestorefileinfo;
    tmpstr:string;
begin
   realfile:=Restore_name_EB.Text;
   Restore_LB.Items.BeginUpdate;
   Restore_LB.Clear;
    try
      MyList.Clear;
      GetRestoreFileAllName(realfile,MyList);
      for I := 0 to MyList.Count - 1 do
      begin
        tmprec:=MyList[i];
        tmpstr:= tmprec.filename+'   '+Format('%u ×Ö½Ú',[tmprec.filesize]);
        Restore_LB.AddItem(tmpstr,nil);
        Dispose(tmprec);
       end;
    finally
       //////////
    end;
   Restore_LB.Items.EndUpdate;
end;

procedure TRestore_Form.Restore_name_EBKeyPress(Sender: TObject; var Key: Char);
begin
    Restore_name_EBRightButtonClick(self);
end;

procedure TRestore_Form.Restore_name_EBRightButtonClick(Sender: TObject);
begin
   OpenDialog1.InitialDir:=ExtractFilepath(Restore_name_EB.Text);
   OpenDialog1.FileName:=ExtractFileName(Restore_name_EB.Text);
   if OpenDialog1.Execute(handle) then
   begin
    if fileExists(OpenDialog1.FileName) then
    Restore_name_EB.Text:=OpenDialog1.FileName;
   end;
end;

procedure TRestore_Form.REstore_ReWrite_CBClick(Sender: TObject);
begin
    realover:= Restore_reWrite_Cb.Checked;
end;

end.
