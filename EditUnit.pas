unit EditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls,ChildFormUnit, StdCtrls,NSEKernel, ImgList,shellapi;

type
  TEditForm = class(TChildForm)
    Panel1: TPanel;
    title_panel: TPanel;
    Splitter1: TSplitter;
    Client_Panel: TPanel;
    Panel4: TPanel;
    Splitter2: TSplitter;
    Panel5: TPanel;
    Edit_Main_TV:TTreeView;
    Edit_Info_LV: TListView;
    Refresh_Button: TButton;
    Info_title_Panel: TPanel;
    Panel3: TPanel;
    TreeView_IL: TImageList;
    info_file_button: TButton;
    info_name_Edit: TEdit;
    del_btn: TButton;
    add_btn: TButton;
    Exp_btn: TButton;
    info_stream_Edit: TEdit;
    info_Memo: TMemo;
    hardlink_Button: TButton;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure Edit_Main_TVCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure Edit_Main_TVExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure Refresh_ButtonClick(Sender: TObject);
    procedure Edit_Main_TVDeletion(Sender: TObject; Node: TTreeNode);
    procedure Edit_Main_TVClick(Sender: TObject);
    procedure info_file_buttonClick(Sender: TObject);
    procedure Edit_Info_LVColumnClick(Sender: TObject; Column: TListColumn);
    procedure Edit_Info_LVCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure del_btnClick(Sender: TObject);
    procedure Exp_btnClick(Sender: TObject);
    procedure add_btnClick(Sender: TObject);
    procedure Edit_Info_LVClick(Sender: TObject);
    procedure hardlink_ButtonClick(Sender: TObject);
  private
    function InitTreeView:Bool;
    procedure UpdateInfoMessage(filename:string);
    procedure ResultAddtoRecord(info: deal_resultinfo);

    procedure DelOK(var msg:Tmessage);message WM_NSE_DEL_OK;
    procedure DelFail(var msg:Tmessage);message WM_NSE_Del_Fail;
    procedure DelEnd(var msg:Tmessage);message WM_NSE_Del_End;

    procedure EXPOK(var msg:Tmessage);message WM_NSE_EXP_OK;
    procedure EXPFail(var msg:Tmessage);message WM_NSE_EXP_Fail;
    procedure EXPEnd(var msg:Tmessage);message WM_NSE_EXP_End;


   procedure AddOK(var msg:Tmessage);message WM_NSE_ADD_OK;
    procedure AddFail(var msg:Tmessage);message WM_NSE_ADD_Fail;
    procedure AddEnd(var msg:Tmessage);message WM_NSE_ADD_End;

  public
    SelectFileName:string;
    SelectFileStreamName:string;
  end;

var
  EditForm: TEditForm;

type
  PMyData=^TMyData;
  TMyData=Record
     sLongName:string;
     sShortName:string;
end;

/////////////界面排序专用/////////
var  ColumnToSort:integer;
  IsAscSort:array[0..3]of boolean;

implementation

uses ScanUnit,RecordUnit,DelUnit,ExpUnit,AddUnit;
{$R *.dfm}


procedure TEditForm.ResultAddtoRecord(info: deal_resultinfo);
begin
  with  RecordForm.Record_LV.Items.Add do
  begin
    Caption:=DateTimetoStr(info.time);
    Subitems.Add(info.context);
    if info.ret=true then
    begin
     Subitems.Add('成功');
    end else Subitems.Add('失败');
  end;
end;

procedure TEditForm.info_file_buttonClick(Sender: TObject);
var ShExecInfo:TSHELLEXECUTEINFO;
begin
 ZeroMemory(@ShExecInfo,sizeof(TSHELLEXECUTEINFO));
	ShExecInfo.cbSize := sizeof(SHELLEXECUTEINFO);
	ShExecInfo.fMask := SEE_MASK_INVOKEIDLIST ;
	ShExecInfo.Wnd:= Application.handle;
	ShExecInfo.lpVerb :=  'properties';
	ShExecInfo.lpFile := pchar(info_name_edit.Text);
	ShExecInfo.lpParameters :=  '';
	ShExecInfo.lpDirectory :=  nil;
	ShExecInfo.nShow :=  SW_SHOW;
	ShExecInfo.hInstApp :=  application.handle;
	ShellExecuteEx(@ShExecInfo);
end;

procedure TEditForm.FormCreate(Sender: TObject);
begin
  InitTreeView;
  try
     Edit_Main_TV.Selected:=Edit_Main_TV.TopItem;
      Edit_Main_TVClick(nil);
   except
   end;
end;

procedure TEditForm.hardlink_ButtonClick(Sender: TObject);
var ret:BOOL;
    deal_Hard_RI:deal_resultinfo;
begin
  if MessageBox(handle,Pchar('为该文件创建新的硬连接吗？'),PChar('创建新硬连接提示'),MB_YESNOCANCEL or MB_ICONINFORMATION)=IDYES then
     begin
        if saveDialog1.Execute(handle) then
        begin
           ret:=CreateHardLink(pchar(saveDialog1.FileName), pchar(SelectFileName),nil);
           deal_Hard_RI.time:=now;
           deal_Hard_RI.context:='硬连接:'+SelectFileName
                       +'到'
                       +saveDialog1.FileName;
           deal_Hard_RI.ret:=ret;
           ResultAddtoRecord(deal_Hard_RI);
           if ret then
             ShowMessage('创建成功')
            else
            ShowMessage('创建失败') ;
        end;
     end;
end;

function TEditForm.InitTreeView;
var tn:TTreeNode;
    addstrlist:TStringList;
    i:Integer;
    seldata:PMyData;
begin
   result:=false;
   addstrlist:=TStringList.Create;
   Edit_Main_TV.AutoExpand:=false;
   NSEKernel.EnumNtfsDrivers(addstrlist);
   Edit_Main_TV.Items.BeginUpdate;
   if addstrlist.Count=0 then
   begin
     title_Panel.Caption:='没有NTFS文件系统的磁盘';
     exit;
   end;

  ////disk
   for i:=0 to addstrlist.Count-1 do
   begin
   new(seldata);
   seldata.sLongName:=addstrlist.Strings[i];
   tn:=Edit_Main_TV.Items.AddObject(nil,seldata.sLongName,seldata);
   tn.ImageIndex:=0;
   tn.SelectedIndex:=0;
   Edit_Main_TV.Items.AddChildObject(tn,'disk',nil);    ///加显示出树形折叠按钮
   end;
    Edit_Main_TV.Items.EndUpdate;
   addstrlist.Free;
   result:=true;
end;


procedure TEditForm.Edit_Info_LVClick(Sender: TObject);
var  tmptext:string;
begin
 if Edit_Info_LV.Selected<>nil then
 begin
 SelectFileStreamname:=Edit_Info_LV.Selected.SubItems[1];
 end else
 begin
   SelectFileStreamname:= SelectFilename;
 end;
   info_stream_Edit.Text:=SelectFileStreamname;

   info_memo.Lines.BeginUpdate;
   info_memo.Lines.Clear;
   try
   //info_memo.Lines.LoadFromFile('');
   ReadTextFileFast(SelectFileStreamname,tmptext);
   info_memo.Lines.Add(tmptext);
   info_memo.Lines.Add(#13#10);
   info_memo.Lines.Add(
   '==========================================================================');
   ReadHexFileFast(SelectFileStreamname,tmptext);
   info_memo.Lines.Add(tmptext);
   except

   end;
   info_memo.Lines.EndUpdate;
end;

procedure TEditForm.Edit_Info_LVColumnClick(Sender: TObject;
  Column: TListColumn);
var I:Integer;
begin

  ColumnToSort:=column.Index;
  IsAscSort[ColumnToSort]:=not IsAscSort[ColumnToSort];
   if ColumnToSort = 0 then
    begin
     for I := 0 to Edit_Info_LV.Items.Count - 1 do
       Edit_Info_LV.Items[i].Checked:=IsAscSort[ColumnToSort];
      exit;
   end;
  Edit_Info_LV.AlphaSort;
end;


function  CompareValue(s1,s2:integer):integer;//升序
begin
     if   s1 >s2   then   result:=1
     else   result:=0;
end;

procedure TEditForm.Edit_Info_LVCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var ix: Integer;
begin

if (ColumnToSort = 1) or (ColumnToSort = 2) then
begin
  ix := ColumnToSort - 1;
    if IsAscSort[ColumnToSort] then
     Compare:=CompareText(Item1.SubItems[ix],Item2.SubItems[ix])
     else
     Compare:=CompareText(Item2.SubItems[ix],Item1.SubItems[ix]);
end;

if (ColumnToSort = 3)then
begin
     ix := ColumnToSort - 1;
    if IsAscSort[ColumnToSort] then
     Compare:=CompareValue(strtoint(Item1.SubItems[ix]),strtoint(Item2.SubItems[ix]))
     else
     Compare:=CompareValue(strtoint(Item2.SubItems[ix]),strtoint(Item1.SubItems[ix]));
end;
end;

procedure TEditForm.Edit_Main_TVClick(Sender: TObject);
var  seldata:PMyData;
begin
 if Edit_Main_TV.Selected<>nil then
 begin
   Edit_Main_TV.Selected.SelectedIndex:=3;
   seldata:=PMyData(Edit_Main_TV.Selected.Data);
   SelectFileName:=seldata.sLongName;
   info_name_Edit.text:= SelectFileName;
   SelectFileStreamName:=SelectFileName;
   info_stream_Edit.Text:=SelectFileStreamname;
   UpdateInfoMessage(SelectFileName);
   if Edit_Info_LV.Items.Count>0 then
   begin
     Edit_Info_LV.Items[0].Selected:=true;
     Edit_Info_LV.SetFocus;
   end;
   Edit_Info_LV.OnClick(self);
 end;
end;

procedure TEditForm.Edit_Main_TVCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
var seldata:PMyData;
    i:integer;
begin
 for i:=0 to Node.Count-1 do
  begin
     seldata:=PMyData(Node.Item[i].Data);
     if seldata<>nil then Dispose(seldata);
  end;
end;

procedure TEditForm.Edit_Main_TVDeletion(Sender: TObject; Node: TTreeNode);
var seldata:PMyData;
    i:integer;
begin
 for i:=0 to Node.Count-1 do
  begin
     seldata:=PMyData(Node.Item[i].Data);
     if seldata<>nil then Dispose(seldata);
  end;
end;

procedure TEditForm.Edit_Main_TVExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var tn:TTreeNode;
    addstrlist:TStringList;
    i:Integer;
    selpath:string;
    seldata:PMyData;
begin
  addstrlist:=TStringList.Create;
   Edit_Info_LV.Items.BeginUpdate;

   Node.DeleteChildren;  //del nul

     selpath:=PMyData(Node.Data)^.sLongName;
     NSEKernel.EnumDirs(selpath,false,addstrlist);
     //add dir
  for i:=0 to addstrlist.Count-1 do
   begin
   new(seldata);
   seldata.sLongName:=selpath+'\'+addstrlist.Strings[i];
   seldata.sShortName:=addstrlist.Strings[i];
   tn:=Edit_Main_TV.Items.AddChildObject(Node,seldata.sShortName,seldata);
   tn.ImageIndex:=1;
   tn.SelectedIndex:=1;
   Edit_Main_TV.Items.AddChildObject(tn,'path',nil);
   end;
   //add file
   NSEKernel.EnumFiles(selpath,'*',false,addstrlist);
   for i:=0 to addstrlist.Count-1 do
   begin
   new(seldata);
   seldata.sLongName:=selpath+'\'+addstrlist.Strings[i];
   seldata.sShortName:=addstrlist.Strings[i];
   tn:=Edit_Main_TV.Items.AddChildObject(Node,seldata.sShortName,seldata);
   tn.ImageIndex:=2;
   tn.SelectedIndex:=2;
   end;

   Edit_Info_LV.Items.EndUpdate;
   addstrlist.Free;
end;







procedure TEditForm.Refresh_ButtonClick(Sender: TObject);
begin
 Edit_Main_TV.Items.BeginUpdate;
 Edit_Main_TV.Items.Clear;
 InitTreeView;
 Edit_Main_TV.Items.EndUpdate;
end;



/////////////////////////
procedure TEditForm.UpdateInfoMessage(filename:string);
var hlnum,i:integer;
     streamlist:TStringList;
     fullname:string;
    ScanRecord:ScanlistRecord;
begin
   if ShowHardLinkInfo(filename,hlnum) then
   begin
    hardlink_Button.Caption:='硬连接 '+inttostr(hlnum);
   end else
   begin
    hardlink_Button.Caption:='无硬连接信息'
   end;
   streamlist:=TStringList.Create;
   Edit_Info_LV.Items.BeginUpdate;
   Edit_Info_LV.Clear;
   if NSEKernel.Ret_Info.RI_GetStreamsInfoOK=GetFileAllStreams(filename,streamlist) then
   begin
     for I := 0 to streamlist.Count - 1 do
     begin
        fullname:=filename+':'+streamlist.Strings[i];
        ScanRecord.pathname:=fullname;
        GetScanRecord(@ScanRecord); ///处理
       with Edit_Info_LV.Items.Add do
       begin
         Caption:='';
         Subitems.Add(streamlist.Strings[i]);
         Subitems.Add(fullname);
         Subitems.Add(Format('%u',[ScanRecord.size]));
         Subitems.Add(inttostr(ScanRecord.virusrank));
         if ScanRecord.virusrank>1 then Checked:=true;
      end;
     end;
   end;
   Edit_Info_LV.Items.EndUpdate;
  streamlist.Free;
end;

 /////////////////////////////////////////////////////////////////
 //////////////////////del_btn////////////////////////////////////////
procedure TEditForm.del_btnClick(Sender: TObject);
var i:integer;
     delform:TDel_Form;
     dlgret:integer;
begin

   if TDeLThreadRunning=true then
   begin
     if MessageBox(handle,pchar('有相同的操作任务正在执行，中断那个任务并开始新的任务吗?'),
          Pchar('提示'),MB_YESNOCANCEL or MB_ICONINFORMATION)=IDYES then
     begin
      if DEL_thread<>nil then DEL_thread.Terminate;
      TDeLThreadRunning:=false;
     end else exit;
   end;


  ///////////////////////////////////////
  Del_Files.Clear;
  for I := 0 to Edit_info_LV.Items.Count - 1 do
    begin
      if true=Edit_info_LV.Items[i].Checked then
      begin
        Del_Files.Add(Edit_info_LV.Items[i].SubItems[1]);
      end;
    end;
  if Del_Files.Count=0 then
  begin
  ShowMessage('选择需要删除的文件');
  Exit;
  end;


   try
     delform:=TDel_Form.Create(nil);
      for I := 0 to Del_Files.Count - 1 do
      begin
       delform.Del_LB.AddItem(Del_Files[i],nil);
      end;
     dlgret:=delform.ShowModal;
   finally
     FreeAndNIl(delform);
   end;

   if dlgret=mrOk then
   begin
     DEL_thread:=TDelThread.Create(handle,
                            Del_Files,
                            @DEL_RI);
     NSEkernel.TDelThreadRunning:=true;
     DEL_thread.Resume;
   end;

end;

procedure TEditForm.DelOK(var msg: TMessage);
begin
  deal_Del_RI.time:=now;
  deal_Del_RI.context:='删除:'+del_ri.nowfile;
  deal_Del_RI.ret:=true;
  ResultAddtoRecord(deal_Del_RI);
   inherited;
end;

procedure TEditForm.DelFail(var msg: TMessage);
begin
    deal_Del_RI.time:=now;
  deal_Del_RI.context:='删除:'+del_ri.nowfile;
  deal_Del_RI.ret:=false;
   ResultAddtoRecord(deal_Del_RI);
   inherited;
end;



procedure TEditForm.DelEnd(var msg: TMessage);
begin
   Edit_Main_TVClick(self);
   Edit_Main_TV.SetFocus;
  // deal_Del_RI.time:=now;
  deal_Del_RI.context:='删除结果:共'+inttostr(Del_RI.allnumber)+'个;'
                        +'成功'+inttostr(del_RI.oknumber)+'个;'
                        +'失败'+inttostr(del_RI.Failnumber)+'个;'
                        +'用时'+ Format('%.3f s',[Del_RI.period/1000]);
 // deal_Del_RI.ret:=true;
   ShowMessage(deal_Del_RI.context);
   inherited;
end;


///////////add//////////////////////////

procedure TEditForm.add_btnClick(Sender: TObject);
var  ADDform:TADD_Form;
     dlgret:integer;
     tmpfile,tmpstream,tmpname:string;
     tmpRewrite:bool;
begin
  if TADDThreadRunning=true then
   begin
     if MessageBox(handle,pchar('有相同的操作任务正在执行，中断那个任务并开始新的任务吗?'),
          Pchar('提示'),MB_YESNOCANCEL or MB_ICONINFORMATION)=IDYES then
     begin
      if ADD_thread<>nil then ADD_thread.Terminate;
      TAddThreadRunning:=false;
     end  else exit;
   end;
  ///////////////////////////////////////
  ADD_SourceFiles.Clear;
  ADD_SourceFiles.Add(SelectFileName);

       ///界面
  tmpfile:=ADD_LastFileName;
  tmpstream:=ADD_LastStreamName;
  tmpRewrite:=true;
  ADDform:=TADD_Form.Create(nil);
  ADDform.Add_src_EB.text:=tmpfile;
  ADDForm.Add_name_Edit.Text:=tmpstream;
  ///this will raise OnChange Method if  Expform.ExpPath_EB.text <> tmppath
  /// so set ADDform.Add_src_EB.text<='asdsad'
  ADDForm.Add_ReWrite_CB.Checked:=tmpRewrite;

   try
     dlgret:=ADDform.ShowModal;
     tmpfile:=ADDform.realfile;
     tmpstream:=ADDform.realname;
     tmpRewrite:=ADDform.realOver;
   finally
     FreeAndNil(ADDform);
   end;

   if dlgret=mrOk then
   begin
      ADD_TargetFiles.Clear;
      tmpname:=SelectFileName+':'+tmpstream;
      ADD_TargetFiles.Add(tmpname);

     ADD_thread:=TADDThread.Create(handle,
                            ADD_TargetFiles,
                            tmpfile,
                            tmpname,
                            tmpRewrite,
                            @ADD_RI);
     NSEkernel.TADDThreadRunning:=true;
     ADD_thread.Resume;
   end;

end;


procedure TEditForm.ADDOK(var msg: TMessage);
begin
  deal_ADD_RI.time:=now;
  deal_ADD_RI.context:='附加:'+ADD_ri.nowfile;
  deal_ADD_RI.ret:=true;
  ResultAddtoRecord(deal_ADD_RI);
   inherited;
end;

procedure TEditForm.ADDFail(var msg: TMessage);
begin
    deal_ADD_RI.time:=now;
  deal_ADD_RI.context:='附加:'+ADD_ri.nowfile;
  deal_ADD_RI.ret:=false;
   ResultAddtoRecord(deal_ADD_RI);
   inherited;
end;


 procedure TEditForm.ADDEnd(var msg: TMessage);
begin
      Edit_Main_TVClick(self);
   Edit_Main_TV.SetFocus;
  //deal_ADD_RI.time:=now;
  deal_ADD_RI.context:='附加结果:共'+inttostr(ADD_RI.allnumber)+'个;'
                        +'成功'+inttostr(ADD_RI.oknumber)+'个;'
                        +'失败'+inttostr(ADD_RI.Failnumber)+'个;'
                        +'用时'+ Format('%.3f s',[ADD_RI.period/1000]);
 // deal_ADD_RI.ret:=true;
   ///ResultAddtoRecord(deal_ADD_RI);
   ShowMessage(deal_ADD_RI.context);
   inherited;
end;
///////////////////////////////////////////////////////

/////////////Exp///////////////////////////////////
procedure TEditForm.Exp_btnClick(Sender: TObject);
 var i:integer;
     Expform:TExp_Form;
     dlgret:integer;
     tmppath,tmpname:string;
begin
  if TEXPThreadRunning=true then
   begin
     if MessageBox(handle,pchar('有相同的操作任务正在执行，中断那个任务并开始新的任务吗?'),
          Pchar('提示'),MB_YESNOCANCEL or MB_ICONINFORMATION)=IDYES then
     begin
      if EXP_thread<>nil then EXP_thread.Terminate;
      TEXPThreadRunning:=false;
     end  else exit;
   end;
  ///////////////////////////////////////
  EXP_SourceFiles.Clear;
  for I := 0 to Edit_info_LV.Items.Count - 1 do
    begin
      if true=Edit_info_LV.Items[i].Checked then
      begin
        EXP_SourceFiles.Add(Edit_info_LV.Items[i].SubItems[1]);
      end;
    end;
  if EXP_SourceFiles.Count=0 then
  begin
  ShowMessage('选择需要导出的文件');
  Exit;
  end;

       ///界面
    tmppath:=ExtractFilePath(SelectFileName);
    Expform:=TExp_Form.Create(nil);
    Expform.ExpPath_EB.text:=tmppath;
    ///this will raise OnChange Method if  Expform.ExpPath_EB.text <> tmppath
    /// so set Expform.ExpPath_EB.text<='asdsad'

    try
     dlgret:=Expform.ShowModal;
     tmppath:=IncludeTrailingPathDelimiter(Expform.realpath);
    finally
     FreeAndNil(Expform);
    end;

   if dlgret=mrOk then
   begin
      EXP_TargetFiles.Clear;
      for I := 0 to EXP_SourceFiles.Count - 1 do
      begin
        tmpname:= tmppath+TEXPThread_Rename(EXP_SourceFiles[i]);
        EXP_TargetFiles.Add(tmpname);
      end;

     Exp_thread:=TExpThread.Create(handle,
                            Exp_SourceFiles,
                            Exp_TargetFiles,
                            @Exp_RI);
     NSEkernel.TExpThreadRunning:=true;
     Exp_thread.Resume;
   end;

end;



procedure TEditForm.EXPOK(var msg: TMessage);
begin
  deal_EXP_RI.time:=now;
  deal_EXP_RI.context:='导出:'+EXP_ri.nowfile
                       +'到'
                       +Exp_TargetFiles[msg.WParam];
  deal_EXP_RI.ret:=true;
  ResultAddtoRecord(deal_EXP_RI);
   inherited;
end;

procedure TEditForm.EXPFail(var msg: TMessage);
begin
    deal_EXP_RI.time:=now;
  deal_EXP_RI.context:='导出:'+EXP_ri.nowfile
                       +'到'
                       +Exp_TargetFiles[msg.WParam];
  deal_EXP_RI.ret:=false;
   ResultAddtoRecord(deal_EXP_RI);
   inherited;
end;


 procedure TEditForm.EXPEnd(var msg: TMessage);
begin
     Edit_Main_TVClick(self);
   Edit_Main_TV.SetFocus;
  //deal_EXP_RI.time:=now;
  deal_EXP_RI.context:='导出结果:共'+inttostr(EXP_RI.allnumber)+'个;'
                        +'成功'+inttostr(EXP_RI.oknumber)+'个;'
                        +'失败'+inttostr(EXP_RI.Failnumber)+'个;'
                        +'用时'+ Format('%.3f s',[EXP_RI.period/1000]);
 // deal_EXP_RI.ret:=true;
 showMessage(deal_EXP_RI.context);
   ///ResultAddtoRecord(deal_EXP_RI);
   inherited;
end;





end.
