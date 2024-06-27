unit ScanUnit;

interface

uses
  Windows,Messages,SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ChildFormUnit,Dialogs, StdCtrls, ExtCtrls, ImgList, ComCtrls, NSEKernel;


  //////信息结果
  //////处理结果显示



type
  TScanForm = class(TChildForm)
    ImageList1: TImageList;
    Panel1: TPanel;
    Scan_Button: TButton;
    Panel2: TPanel;
    Func_Panel: TPanel;
    Scan_LV: TListView;
    DEl_Button: TButton;
    Add_Button: TButton;
    Exp_button: TButton;
    Bak_Button: TButton;
    StreamsFilter_GB: TGroupBox;
    StreamsFilter_CB: TComboBox;
    Deal_Timer: TTimer;
    RESTORE_Button: TButton;
    ImageList2: TImageList;
    Panel3: TPanel;
    Deal_PB: TProgressBar;
    Panel5: TPanel;
    Scan_PB: TProgressBar;
    ScanStop_Button: TButton;
    Search_info_Label: TLabel;
    deal_info_Label: TLabel;
    GroupBox1: TGroupBox;
    ScanType_RB1: TRadioButton;
    ScanType_RB2: TRadioButton;
    ScanPath_EB: TButtonedEdit;
    SaveDialog1: TSaveDialog;
    Record_Button: TButton;
    procedure Scan_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Deal_TimerTimer(Sender: TObject);
    procedure ScanStop_ButtonClick(Sender: TObject);
    procedure DEl_ButtonClick(Sender: TObject);
    procedure Scan_LVColumnClick(Sender: TObject; Column: TListColumn);
    procedure Scan_LVCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ScanPath_EBRightButtonClick(Sender: TObject);
    procedure Exp_buttonClick(Sender: TObject);
    procedure ScanPath_EBEnter(Sender: TObject);
    procedure Add_ButtonClick(Sender: TObject);
    procedure Record_ButtonClick(Sender: TObject);
    procedure Bak_ButtonClick(Sender: TObject);
    procedure RESTORE_ButtonClick(Sender: TObject);
    procedure Scan_LVDblClick(Sender: TObject);
    procedure ScanPath_EBChange(Sender: TObject);
  private
    procedure SearchProc(var msg:Tmessage);message WM_NSE_SEARCH_PROC;
    procedure SearchEnd(var msg:Tmessage);message WM_NSE_SEARCH_END;

    procedure DelOK(var msg:Tmessage);message WM_NSE_DEL_OK;
    procedure DelFail(var msg:Tmessage);message WM_NSE_Del_Fail;
    procedure DelEnd(var msg:Tmessage);message WM_NSE_Del_End;

    procedure EXPOK(var msg:Tmessage);message WM_NSE_EXP_OK;
    procedure EXPFail(var msg:Tmessage);message WM_NSE_EXP_Fail;
    procedure EXPEnd(var msg:Tmessage);message WM_NSE_EXP_End;


   procedure AddOK(var msg:Tmessage);message WM_NSE_ADD_OK;
    procedure AddFail(var msg:Tmessage);message WM_NSE_ADD_Fail;
    procedure AddEnd(var msg:Tmessage);message WM_NSE_ADD_End;



    procedure BAKOK(var msg:Tmessage);message WM_NSE_BAK_OK;
    procedure BAKFail(var msg:Tmessage);message WM_NSE_BAK_Fail;
    procedure BAKEnd(var msg:Tmessage);message WM_NSE_BAK_End;

    procedure RESTOREOK(var msg:Tmessage);message WM_NSE_RESTORE_OK;
    procedure RESTOREFail(var msg:Tmessage);message WM_NSE_RESTORE_Fail;
    procedure RESTOREEnd(var msg:Tmessage);message WM_NSE_RESTORE_End;

  public
     Procedure ResultAddtoRecord(info:deal_resultinfo);
  end;

var
  ScanForm: TScanForm;

///////////////处理专用///////////////////////
/////


  /////扫描
var   search_Paths:TStringList;
  search_Files:TStringList;
  search_RI:Retinfo_Search;
  search_thread:TSearchthread;
  deal_search_RI:deal_resultinfo;

  /////DEL
var   DEL_Files:TStringList;
      DEL_RI:Retinfo_DEL;
      DEL_thread:TDELthread;
      deal_DEL_RI:deal_resultinfo;

  /////EXP
var   EXP_SourceFiles:TStringList;
      EXP_TargetFiles:TStringList;
      EXP_RI:Retinfo_EXP;
      EXP_thread:TEXPthread;
      deal_EXP_RI:deal_resultinfo;
      EXP_LastPath:string='C:\';

 /////ADD
var  ADD_SourceFiles:TStringList;
  ADD_TargetFiles:TStringList;
  ADD_RI:Retinfo_ADD;
  ADD_thread:TADDthread;
  deal_ADD_RI:deal_resultinfo;
  ADD_Lastfilename:string='C:\Autoexec.bat';
  ADD_LastStreamname:string='wantgirl';

  /////BAK
var   BAK_SourceFiles:TStringList;
      BAK_RI:Retinfo_BAK;
      BAK_thread:TBAKthread;
      deal_BAK_RI:deal_resultinfo;
      BAK_LastFilename:string='C:\bak.nse';

  /////RESTORE
var  Restore_TargetFiles:TStringList;
    RESTORE_RI:Retinfo_RESTORE;
    RESTORE_thread:TRESTOREthread;
    deal_RESTORE_RI:deal_resultinfo;





////////////////////界面处理/////////////////////
///
///

/////////////界面排序专用/////////
var  ColumnToSort:integer;
  IsAscSort:array[0..5]of boolean;


implementation

uses FileCtrl,RecordUnit,DelUnit,ExpUnit,AddUnit,BAKUnit,RestoreUnit,FastViewUnit;

{$R *.dfm}



procedure TScanForm.FormCreate(Sender: TObject);
begin
//////////////////////
search_Paths:=TStringList.Create;
search_Files:=TStringList.Create;
//////////////////////////
DEL_Files:=TStringList.Create;
//////////////////////////////
EXP_SourceFiles:=TStringList.Create;
EXP_TargetFiles:=TStringList.Create;
/////////////////////////////
ADD_SourceFiles:=TStringList.Create;
ADD_TargetFiles:=TStringList.Create;
/////////////////////////////////////////
BAK_SourceFiles:=TStringList.Create;
//////////////////////////////////////
Restore_TargetFiles:=TStringList.Create;
///////////////////////////////////
Deal_Timer.Enabled:=false;
end;



procedure TScanForm.ScanPath_EBChange(Sender: TObject);
begin
  ScanPath_EB.SetFocus;

end;

procedure TScanForm.ScanPath_EBEnter(Sender: TObject);
begin
ScanType_RB2.Checked:=true;

end;

procedure TScanForm.ScanPath_EBRightButtonClick(Sender: TObject);
var pathstr:string;
begin
  pathstr:=ScanPath_EB.Text;
  try
    if  Selectdirectory('选择磁盘/文件夹','',pathstr) then
    ScanPath_EB.Text:=pathstr;
  finally
     ScanType_RB2.Checked:=true;
  end;


end;





procedure TScanForm.ScanStop_ButtonClick(Sender: TObject);
begin
 if NSEkernel.TSearchThreadRunning=true then
 begin
 search_thread.Terminate;
 TSearchThreadRunning:=false;
 end;

end;


procedure TScanForm.Scan_LVColumnClick(Sender: TObject; Column: TListColumn);
var I:Integer;
begin
  ColumnToSort:=column.Index;
  IsAscSort[ColumnToSort]:=not IsAscSort[ColumnToSort];
   if ColumnToSort = 0 then
    begin
     for I := 0 to Scan_LV.Items.Count - 1 do
       Scan_LV.Items[i].Checked:=IsAscSort[ColumnToSort];
      exit;
   end;
      Scan_LV.AlphaSort;
end;


function  CompareValue(s1,s2:integer):integer;//升序
begin
     if   s1 >s2   then   result:=1
     else   result:=0;
end;

procedure TScanForm.Scan_LVCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
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

if (ColumnToSort = 3) or (ColumnToSort = 4) then
begin
     ix := ColumnToSort - 1;
    if IsAscSort[ColumnToSort] then
     Compare:=CompareValue(strtoint(Item1.SubItems[ix]),strtoint(Item2.SubItems[ix]))
     else
     Compare:=CompareValue(strtoint(Item2.SubItems[ix]),strtoint(Item1.SubItems[ix]));
end;
end;






 procedure TScanForm.Scan_LVDblClick(Sender: TObject);
begin
 if SCan_LV.Selected<>nil then
  begin
    FastViewForm.Redraw(SCan_LV.Selected.SubItems[0]);
    FastViewForm.Show;
   end;
end;

///////////////////////search///////////////////////////////
 procedure TScanForm.Scan_ButtonClick(Sender: TObject);
 var scanpath:string;
begin
  if TSearchThreadRunning=true then
   begin
    exit;
   end;

   //操作
    search_Paths.Clear;
    search_Files.Clear;
    if ScanType_RB1.checked=True then
     begin
        NSEkernel.EnumNtfsDrivers(search_Paths);
     end
     else if ScanType_RB2.checked=True then
     begin
          scanpath:=ScanPath_EB.Text;
           if (scanpath='') or (scanpath[1]='\')then Exit;
           search_Paths.Add(scanpath);
     end;
        ///界面
    Scan_Button.Enabled:=false;
    Scan_LV.Clear;
    ScanStop_Button.Enabled:=True;
    Scan_PB.Position:=0;
    Deal_Timer.Enabled:=true;
    IsAscSort[0]:=true;
    IsAscSort[1]:=true;
    search_thread:=TSearchThread.Create(handle,
                            search_Paths,
                            StreamsFilter_CB.Text,
                            search_Files,
                            @search_RI);
    NSEkernel.TSearchThreadRunning:=true;
    search_thread.Resume;



end;


procedure TScanForm.SearchProc(var msg:Tmessage);
var ScanRecord:ScanlistRecord;
begin
    ScanRecord.pathname:=search_Files[msg.WParam];
    GetScanRecord(@ScanRecord); ///处理
   With Scan_LV.Items.Add do
   begin
     Caption:='';
     Subitems.Add(ScanRecord.pathname);
     Subitems.Add(ScanRecord.streamname);
     Subitems.Add(Format('%u',[ScanRecord.size]));
     Subitems.Add(inttostr(ScanRecord.virusrank));
     if ScanRecord.virusrank>1 then Checked:=true;
   end;
  inherited;
end;

procedure TScanForm.SearchEnd(var msg:Tmessage);
begin
  Scan_Button.Enabled:=true;
  ScanStop_Button.Enabled:=false;
  Scan_PB.Position:=Scan_PB.Max;
  Search_info_Label.Caption:='搜索结果:共'+inttostr(search_RI.allnumber)
                           +'个;'
                           +'用时'+ Format('%.3f s',[Search_RI.period/1000]);
  deal_Search_RI.time:=now;
  deal_Search_RI.context:=Search_info_Label.Caption;
  deal_Search_RI.ret:=true;
  ResultAddtoRecord(deal_Search_RI);
  inherited;

end;



///////////del//////////////////////////


procedure TScanForm.DEL_ButtonClick(Sender: TObject);
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
     end  else exit;
   end;


  ///////////////////////////////////////
  Del_Files.Clear;
  for I := 0 to Scan_LV.Items.Count - 1 do
    begin
      if true=Scan_LV.Items[i].Checked then
      begin
        Del_Files.Add(Scan_LV.Items[i].SubItems[0]);
      end;
    end;
  if Del_Files.Count=0 then
  begin
  ShowMessage('选择需要删除的文件');
  Exit;
  end;

    ///界面
    Deal_PB.Position:=0;
    Deal_Timer.Enabled:=true;

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




procedure TScanForm.DelOK(var msg: TMessage);
begin
  deal_Del_RI.time:=now;
  deal_Del_RI.context:='删除:'+del_ri.nowfile;
  deal_Del_RI.ret:=true;
  ResultAddtoRecord(deal_Del_RI);
   inherited;
end;

procedure TScanForm.DelFail(var msg: TMessage);
begin
    deal_Del_RI.time:=now;
  deal_Del_RI.context:='删除:'+del_ri.nowfile;
  deal_Del_RI.ret:=false;
   ResultAddtoRecord(deal_Del_RI);
   inherited;
end;


 procedure TScanForm.DelEnd(var msg: TMessage);
begin
  deal_Del_RI.time:=now;
  deal_Del_RI.context:='删除结果:共'+inttostr(Del_RI.allnumber)+'个;'
                        +'成功'+inttostr(del_RI.oknumber)+'个;'
                        +'失败'+inttostr(del_RI.Failnumber)+'个;'
                        +'用时'+ Format('%.3f s',[Del_RI.period/1000]);
  deal_Del_RI.ret:=true;
   ///ResultAddtoRecord(deal_Del_RI);
   Deal_PB.Position:=Deal_PB.Max;
   deal_info_Label.Caption:=deal_Del_RI.context;
   ShowMessage(deal_info_Label.Caption);
   inherited;
end;



/////////////Exp///////////////////////////////////
procedure TScanForm.Exp_buttonClick(Sender: TObject);
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
  for I := 0 to Scan_LV.Items.Count - 1 do
    begin
      if true=Scan_LV.Items[i].Checked then
      begin
        EXP_SourceFiles.Add(Scan_LV.Items[i].SubItems[0]);
      end;
    end;
  if EXP_SourceFiles.Count=0 then
  begin
  ShowMessage('选择需要导出的文件');
  Exit;
  end;

       ///界面
    Deal_PB.Position:=0;
    Deal_Timer.Enabled:=true;

    tmppath:=EXP_LastPath;
    Expform:=TExp_Form.Create(nil);
    Expform.ExpPath_EB.text:=tmppath;
    ///this will raise OnChange Method if  Expform.ExpPath_EB.text <> tmppath
    /// so set Expform.ExpPath_EB.text<='asdsad'

    try
     dlgret:=Expform.ShowModal;
     tmppath:=IncludeTrailingPathDelimiter(Expform.realpath);
     EXP_LastPath:=tmppath;
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

procedure TScanForm.EXPOK(var msg: TMessage);
begin
  deal_EXP_RI.time:=now;
  deal_EXP_RI.context:='导出:'+EXP_ri.nowfile
                       +'到'
                       +Exp_TargetFiles[msg.WParam];
  deal_EXP_RI.ret:=true;
  ResultAddtoRecord(deal_EXP_RI);
   inherited;
end;

procedure TScanForm.EXPFail(var msg: TMessage);
begin
    deal_EXP_RI.time:=now;
  deal_EXP_RI.context:='导出:'+EXP_ri.nowfile
                       +'到'
                       +Exp_TargetFiles[msg.WParam];
  deal_EXP_RI.ret:=false;
   ResultAddtoRecord(deal_EXP_RI);
   inherited;
end;


 procedure TScanForm.EXPEnd(var msg: TMessage);
begin
  deal_EXP_RI.time:=now;
  deal_EXP_RI.context:='导出结果:共'+inttostr(EXP_RI.allnumber)+'个;'
                        +'成功'+inttostr(EXP_RI.oknumber)+'个;'
                        +'失败'+inttostr(EXP_RI.Failnumber)+'个;'
                        +'用时'+ Format('%.3f s',[EXP_RI.period/1000]);
  deal_EXP_RI.ret:=true;
   ///ResultAddtoRecord(deal_EXP_RI);
   Deal_PB.Position:=Deal_PB.Max;
   deal_info_Label.Caption:=deal_EXP_RI.context;
   ShowMessage(deal_info_Label.Caption);
   inherited;
end;



////////////////ADD/////////////////////////////////////////////////////
procedure TScanForm.Add_ButtonClick(Sender: TObject);
 var i:integer;
     ADDform:TADD_Form;
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
  for I := 0 to Scan_LV.Items.Count - 1 do
    begin
      if true=Scan_LV.Items[i].Checked then
      begin
        ADD_SourceFiles.Add(Scan_LV.Items[i].SubItems[0]);
      end;
    end;
  if ADD_SourceFiles.Count=0 then
  begin
  ShowMessage('选择需要附加/导入的文件');
  Exit;
  end;
       ///界面
  Deal_PB.Position:=0;
  Deal_Timer.Enabled:=true;

  tmpfile:=ADD_lastFilename;
  tmpstream:=ADD_lastStreamname;
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
     ADD_lastFilename:=tmpfile;
     ADD_lastStreamname:=tmpstream;
   finally
     FreeAndNil(ADDform);
   end;

   if dlgret=mrOk then
   begin
      ADD_TargetFiles.Clear;
      for I := 0 to ADD_SourceFiles.Count - 1 do
      begin
        tmpname:=NSEkernel.ExtractSourceFileName(ADD_SourceFiles[i])+':'+tmpstream;
        ADD_TargetFiles.Add(tmpname);
      end;

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



procedure TScanForm.ADDOK(var msg: TMessage);
begin
  deal_ADD_RI.time:=now;
  deal_ADD_RI.context:='附加:'+ADD_ri.nowfile;
  deal_ADD_RI.ret:=true;
  ResultAddtoRecord(deal_ADD_RI);
   inherited;
end;

procedure TScanForm.ADDFail(var msg: TMessage);
begin
    deal_ADD_RI.time:=now;
  deal_ADD_RI.context:='附加:'+ADD_ri.nowfile;
  deal_ADD_RI.ret:=false;
   ResultAddtoRecord(deal_ADD_RI);
   inherited;
end;


 procedure TScanForm.ADDEnd(var msg: TMessage);
begin
  deal_ADD_RI.time:=now;
  deal_ADD_RI.context:='附加结果:共'+inttostr(ADD_RI.allnumber)+'个;'
                        +'成功'+inttostr(ADD_RI.oknumber)+'个;'
                        +'失败'+inttostr(ADD_RI.Failnumber)+'个;'
                        +'用时'+ Format('%.3f s',[ADD_RI.period/1000]);
  deal_ADD_RI.ret:=true;
   ///ResultAddtoRecord(deal_ADD_RI);
   Deal_PB.Position:=Deal_PB.Max;
   deal_info_Label.Caption:=deal_ADD_RI.context;
   ShowMessage(deal_info_Label.Caption);
   inherited;
end;
///////////////////////////////////////////////////////

////////////////BAK/////////////////////////////////////////////////////
procedure TScanForm.BAK_ButtonClick(Sender: TObject);
 var i:integer;
     BAKform:TBAK_Form;
     dlgret:integer;
     tmpfile:string;
begin
  if TBAKThreadRunning=true then
   begin
     if MessageBox(handle,pchar('有相同的操作任务正在执行，中断那个任务并开始新的任务吗?'),
          Pchar('提示'),MB_YESNOCANCEL or MB_ICONINFORMATION)=IDYES then
     begin
      if BAK_thread<>nil then BAK_thread.Terminate;
      TBAKThreadRunning:=false;
     end  else exit;
   end;
  ///////////////////////////////////////
  BAK_SourceFiles.Clear;
  for I := 0 to Scan_LV.Items.Count - 1 do
    begin
      if true=Scan_LV.Items[i].Checked then
      begin
        BAK_SourceFiles.Add(Scan_LV.Items[i].SubItems[0]);
      end;
    end;
  if BAK_SourceFiles.Count=0 then
  begin
  ShowMessage('选择需要附加/导入的文件');
  Exit;
  end;

  //界面
    Deal_PB.Position:=0;
    Deal_Timer.Enabled:=true;
    DateTimeToString(tmpfile,'YY-MM-DD hh_nn',now);
    tmpfile:=ExtractFilePath(BAK_LastFilename)+tmpfile+'.nse';
    BAKform:=TBAK_Form.Create(nil);
    BAKform.Bak_name_EB.text:=tmpfile;
    ////cause  onchange method



  try
     dlgret:=BAKform.ShowModal;
     tmpfile:=BAKform.realfile;
     BAK_LastFilename:=tmpfile;
   finally
     FreeAndNil(BAKform);
   end;

   if dlgret=mrOk then
   begin
     BAK_thread:=TBAKThread.Create(handle,
                            BAK_SourceFiles,
                            tmpfile,
                            @BAK_RI);
     NSEkernel.TBAKThreadRunning:=true;
     BAK_thread.Resume;
   end;

end;



procedure TScanForm.BAKOK(var msg: TMessage);
begin
  deal_BAK_RI.time:=now;
  deal_BAK_RI.context:='备份:'+BAK_ri.nowfile;
  deal_BAK_RI.ret:=true;
  ResultADDtoRecord(deal_BAK_RI);
   inherited;
end;

procedure TScanForm.BAKFail(var msg: TMessage);
begin
    deal_BAK_RI.time:=now;
  deal_BAK_RI.context:='备份:'+BAK_ri.nowfile;
  deal_BAK_RI.ret:=false;
   ResultAddtoRecord(deal_BAK_RI);
   inherited;
end;


 procedure TScanForm.BAKEnd(var msg: TMessage);
begin
  deal_BAK_RI.time:=now;
  deal_BAK_RI.context:='备份结果:共'+inttostr(BAK_RI.allnumber)+'个;'
                        +'成功'+inttostr(BAK_RI.oknumber)+'个;'
                        +'失败'+inttostr(BAK_RI.Failnumber)+'个;'
                        +'用时'+ Format('%.3f s',[BAK_RI.period/1000]);
  deal_BAK_RI.ret:=true;
   ///ResultAddtoRecord(deal_BAK_RI);
   Deal_PB.Position:=Deal_PB.Max;
   deal_info_Label.Caption:=deal_BAK_RI.context;
   ShowMessage(deal_info_Label.Caption);
   inherited;
end;






////////////////Restore/////////////////////////////////////////////////////
procedure TScanForm.Restore_ButtonClick(Sender: TObject);
 var Restoreform:TRestore_Form;
     tmpfile:string;
     dlgret:integer;
     tmpReWrite:BOOL;
begin

  if TRESTOREThreadRunning=true then
   begin
     if MessageBox(handle,pchar('有相同的操作任务正在执行，中断那个任务并开始新的任务吗?'),
          Pchar('提示'),MB_YESNOCANCEL or MB_ICONINFORMATION)=IDYES then
     begin
      if RESTORE_thread<>nil then RESTORE_thread.Terminate;
      TRESTOREThreadRunning:=false;
     end  else exit;
   end;
  ///////////////////////////////////////
       ///界面
    Deal_PB.Position:=0;
    Deal_Timer.Enabled:=true;

    Restore_TargetFiles.Clear;
    tmpfile:=BAK_LastFilename;
    tmpReWrite:=true;

     Restoreform:=TRestore_Form.Create(nil);
     Restoreform.Restore_name_EB.text:=tmpfile;
     ///will  onChange Method
     Restoreform.REstore_ReWrite_CB.Checked:= tmpReWrite;
   try
     dlgret:=Restoreform.ShowModal;
     tmpfile:=Restoreform.realfile;
     tmpReWrite:=Restoreform.REstore_ReWrite_CB.Checked;
   finally
     FreeAndNil(Restoreform);
   end;

   if dlgret=mrOk then
   begin
     Restore_thread:=TRestoreThread.Create(handle,
                            tmpfile,
                            Restore_TargetFiles,
                            tmpReWrite,
                            @Restore_RI);
     NSEkernel.TRestoreThreadRunning:=true;
     Restore_thread.Resume;
   end;

end;



procedure TScanForm.RestoreOK(var msg: TMessage);
begin
  deal_Restore_RI.time:=now;
  deal_Restore_RI.context:='还原:'+Restore_ri.nowfile;
  deal_Restore_RI.ret:=true;
  ResultADDtoRecord(deal_Restore_RI);
   inherited;
end;

procedure TScanForm.RestoreFail(var msg: TMessage);
begin
    deal_Restore_RI.time:=now;
  deal_Restore_RI.context:='还原:'+Restore_ri.nowfile;
  deal_Restore_RI.ret:=false;
   ResultAddtoRecord(deal_Restore_RI);
   inherited;
end;


 procedure TScanForm.RestoreEnd(var msg: TMessage);
begin
  deal_Restore_RI.time:=now;
  deal_Restore_RI.context:='还原结果:共'+inttostr(Restore_RI.allnumber)+'个;'
                        +'成功'+inttostr(Restore_RI.oknumber)+'个;'
                        +'失败'+inttostr(Restore_RI.Failnumber)+'个;'
                        +'用时'+ Format('%.3f s',[Restore_RI.period/1000]);
  deal_Restore_RI.ret:=true;
   ///ResultAddtoRecord(deal_Restore_RI);
   Deal_PB.Position:=Deal_PB.Max;
   deal_info_Label.Caption:=deal_Restore_RI.context;
   ShowMessage(deal_info_Label.Caption);
   inherited;
end;
////////////////////////////////////////////////////////////////////////////
function SaveToHTMLFile(const FileName: string; LV:TListView;Center: Boolean): Boolean;
var
  i, j: Integer;
  tfile: TextFile;
begin
  try
    ForceDirectories(ExtractFilePath(FileName));
    AssignFile(tfile, FileName);
    try
      ReWrite(tfile);
      WriteLn(tfile, '<html>');
      WriteLn(tfile, '<head>');
      WriteLn(tfile, '<title>' + FileName + '</title>');
      WriteLn(tfile, '</head>');
      WriteLn(tfile, 'Ntfs数据流处理工具NtfsStreamsEditor搜索结果：');
      // WriteLn(tfile, '<table border="1" bordercolor="#000000">');
      // Modified by HsuChong <Hsuchong@hotmail.com> 2006-12-13 10:03:06
      WriteLn(tfile, '<table border=1 cellspacing=0 cellpadding=0 bordercolor="#000000">');
      WriteLn(tfile, '<tr>');
      for i := 0 to LV.Columns.Count - 1 do
      begin
        if center then
          WriteLn(tfile, '<td><b><center>' + LV.Columns[i].Caption + '</center></b></td>')
        else
          WriteLn(tfile, '<td><b>' + LV.Columns[i].Caption + '</b></td>');
      end;
      WriteLn(tfile, '</tr>');
      WriteLn(tfile, '<tr>');
      for i := 0 to LV.Items.Count - 1 do
      begin
        WriteLn(tfile, '<td>' + LV.Items.Item[i].Caption + '</td>');
        for j := 0 to LV.Columns.Count - 2 do
        begin
          if LV.Items.Item[i].SubItems[j] = '' then
            Write(tfile, '<td>-</td>')
          else
            Write(tfile, '<td>' + LV.Items.Item[i].SubItems[j] + '</td>');
        end;
        Write(tfile, '</tr>');
      end;
      WriteLn(tfile, '</table>');
      WriteLn(tfile, '</html>');
      Result := True;
    finally
      CloseFile(tfile);
    end;
  except
    Result := False;
  end;
end;




procedure TScanForm.Record_ButtonClick(Sender: TObject);
begin
 if SaveDialog1.Execute(handle) then
  SaveToHTMLFile(SaveDialog1.FileName,Scan_LV,false);

end;



procedure TScanForm.ResultAddtoRecord(info: deal_resultinfo);
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

//////////////////////////////////////////////////////////////////////////////


procedure TScanForm.Deal_TimerTimer(Sender: TObject);
begin

  if TSearchThreadRunning then
  begin
     Search_info_Label.Caption:='搜索:共'+inttostr(search_RI.allnumber)+
          '   用时:'+Format('%.3f s',[search_RI.period/1000])+
          '   当前搜索:'+search_RI.nowfile;
     Scan_PB.StepIt;
  end else

  if TDelThreadRunning then
  begin
     Deal_PB.StepIt;
     deal_info_Label.Caption:='删除:共'+inttostr(Del_RI.allnumber)+
          '   用时:'+Format('%.3f s',[Del_RI.period/1000])+
          '   当前删除:'+Del_RI.nowfile;
  end else

  if TExpThreadRunning then
  begin
     Deal_PB.StepIt;
     deal_info_Label.Caption:='导出:共'+inttostr(EXP_RI.allnumber)+
          '   用时:'+Format('%.3f s',[EXP_RI.period/1000])+
          '   当前导出:'+EXP_RI.nowfile;
  end else

  if TADDThreadRunning then
  begin
     Deal_PB.StepIt;
     deal_info_Label.Caption:='附加:共'+inttostr(ADD_RI.allnumber)+
          '   用时:'+Format('%.3f s',[ADD_RI.period/1000])+
          '   当前附加'+ADD_RI.nowfile;
  end else

  if TBAKThreadRunning then
  begin
     Deal_PB.StepIt;
     deal_info_Label.Caption:='备份:共'+inttostr(BAK_RI.allnumber)+
          '   用时:'+Format('%.3f s',[BAK_RI.period/1000])+
          '   当前备份:'+BAK_RI.nowfile;
  end else

  if TRestoreThreadRunning then
  begin
     Deal_PB.StepIt;
     deal_info_Label.Caption:='还原:共'+inttostr(Restore_RI.allnumber)+
          '   用时:'+Format('%.3f s',[Restore_RI.period/1000])+
          '   当前还原:'+Restore_RI.nowfile;
  end else
  Deal_Timer.Enabled:=false;

end;

end.
