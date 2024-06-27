unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NSEKernel, ExtCtrls, ImgList,Shellapi, ComCtrls, GIFImg,
  pngimage;

type
  TMainForm = class(TForm)
    MainTop_Panel: TPanel;
    MainCLient_Panel: TPanel;
    ImageList_Main: TImageList;
    Main_PG: TPageControl;
    Main_TS1: TTabSheet;
    Main_TS2: TTabSheet;
    Main_TS3: TTabSheet;
    Main_TS4: TTabSheet;
    Image2: TImage;
    Image1: TImage;
    Label1: TLabel;
    Image3: TImage;
    web_label: TLabel;
    mail_label: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure web_labelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure web_labelMouseLeave(Sender: TObject);
    procedure web_labelClick(Sender: TObject);
    procedure mail_labelClick(Sender: TObject);
  private
  public
  end;

var
  MainForm: TMainForm;


const KernelExecuteNum=4;
type
     KernelExecuteType=(
        KET_search=1,
        KET_del,
        Ket_add,
        KET_bak
     );

 Const MyUrl='nse';

implementation

uses ScanUnit,EditUnit, RecordUnit, AboutUnit;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
var Index:integer;
    str0,str1:string;
begin

 Index:=0;
 ScanForm:=TScanForm.Create(Main_PG,Main_TS1);
 ScanForm.Show;
  EditForm:=TEditForm.Create(Main_PG,Main_TS2);
  EditForm.Show;
 RecordForm:=TRecordForm.Create(Main_PG,Main_TS3);
 RecordForm.Show;
 AboutForm:=TAboutForm.Create(Main_PG,Main_TS4);
 AboutForm.Show;

 str1:=ParamStr(1);

 if Length(str1)>0 then
 begin
     if CompareText(str1,MyUrl+'://scan/')=0 then Index:=0 else
     if CompareText(str1,MyUrl+'://edit/')=0 then Index:=1 else
     if CompareText(str1,MyUrl+'://record/')=0 then Index:=2 else
     if CompareText(str1,MyUrl+'://help/')=0 then Index:=3
     else
       begin
          if FileExists(str1) then
          begin
            BAK_LastFilename:=str1;
             Mainform.Show;
            Scanform.RESTORE_Button.Click;
            //Button1.click比Button1.onclick(self)安全，
            //假如Button1没有相应事件Button1.onclick(self)会有问题，而Button1.click则不会。
          end;
       end;
 end;


 Main_PG.ActivePageIndex:=Index;
 MainTop_Panel.Caption:='NtfsStreamsEditor 2'+' http://blog.sina.com.cn/advnetsoft';
 str0:= ParamStr(0);
 RegUrlProtocol(MyUrl,str0,true);
 RegisterFileType('.nse','NtfsStreamsEditor.BakupFile','NtfsStreamsEditor数据流备份文件',str0,1,false);
end;

procedure TMainForm.mail_labelClick(Sender: TObject);
begin
Shellexecute(handle,PChar('open'),pchar('mailto:advnetsoft@sina.com'),nil,nil,SW_SHOW);
end;

procedure TMainForm.web_labelClick(Sender: TObject);
begin
Shellexecute(handle,PChar('open'),pchar('http://blog.sina.com.cn/advnetsoft'),nil,nil,SW_SHOW);
end;

procedure TMainForm.web_labelMouseLeave(Sender: TObject);
begin
web_label.Font.Style:=web_label.Font.Style-[fsUnderline];
end;

procedure TMainForm.web_labelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   web_label.Font.Style :=web_label.Font.Style+[fsUnderline];
end;

initialization

finalization




end.
