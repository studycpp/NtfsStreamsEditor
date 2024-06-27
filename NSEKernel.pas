unit NSEkernel;

 {$DEFINE UNICODE}
interface

uses
  Messages,Windows,SysUtils,Variants, Classes,shlwapi,Contnrs,Masks,shlobj,ActiveX,
  Registry;
type
   NTSTATUS=INTEGER;
   USHORT = Word;

const STATUS_BUFFER_OVERFLOW=NTSTATUS($80000005);
// Io Status block (see NTDDK.H)
type
   IO_STATUS_BLOCK=record
   Status:NTSTATUS;
   Information:ULONG;
   end;
	 PIO_STATUS_BLOCK=^IO_STATUS_BLOCK;

   PIO_APC_ROUTINE=^IO_APC_ROUTINE;
   IO_APC_ROUTINE=procedure(
            ApcContext:Pointer;
   					IoStatusBlock:PIO_STATUS_BLOCK;
   					Reserved:ULONG);
// File information classes (see NTDDK.H)
 type FILE_INFORMATION_CLASS=(
    // end_wdm
    FileDirectoryInformation       = 1,
    FileFullDirectoryInformation, // 2
    FileBothDirectoryInformation, // 3
    FileBasicInformation,         // 4  wdm
    FileStandardInformation,      // 5  wdm
    FileInternalInformation,      // 6
    FileEaInformation,            // 7
    FileAccessInformation,        // 8
    FileNameInformation,          // 9
    FileRenameInformation,        // 10
    FileLinkInformation,          // 11
    FileNamesInformation,         // 12
    FileDispositionInformation,   // 13
    FilePositionInformation,      // 14 wdm
    FileFullEaInformation,        // 15
    FileModeInformation,          // 16
    FileAlignmentInformation,     // 17
    FileAllInformation,           // 18
    FileAllocationInformation,    // 19
    FileEndOfFileInformation,     // 20 wdm
    FileAlternateNameInformation, // 21
    FileStreamInformation,        // 22
    FilePipeInformation,          // 23
    FilePipeLocalInformation,     // 24
    FilePipeRemoteInformation,    // 25
    FileMailslotQueryInformation, // 26
    FileMailslotSetInformation,   // 27
    FileCompressionInformation,   // 28
    FileObjectIdInformation,      // 29
    FileCompletionInformation,    // 30
    FileMoveClusterInformation,   // 31
    FileQuotaInformation,         // 32
    FileReparsePointInformation,  // 33
    FileNetworkOpenInformation,   // 34
    FileAttributeTagInformation,  // 35
    FileTrackingInformation,      // 36
    FileMaximumInformation
// begin_wdm
    );
    PFILE_INFORMATION_CLASS=^FILE_INFORMATION_CLASS;
//
// Streams information
//

{$ALIGN 4}   /// #pragma pack(4)
   PFILE_STREAM_INFORMATION=^FILE_STREAM_INFORMATION;
   FILE_STREAM_INFORMATION=packed record
   	NextEntry:ULONG;
	  NameLength:ULONG;
	  Size:LARGE_INTEGER;
	  AllocationSize:LARGE_INTEGER;
    Name:USHORT;
   end;
{$ALIGN ON}     ///#pragma pack()


   TNtQueryInformationFile=function(
				FileHandle:THANDLE;
				IoStatusBlock:PIO_STATUS_BLOCK;
				FileInformation:Pointer;
				Length:ULONG;
				FileInformationClass:FILE_INFORMATION_CLASS):NTSTATUS;stdcall;
    PTNtQueryInformationFile=^TNtQueryInformationFile;


   TRtlNtStatusToDosError=function(Status:NTSTATUS):ULONG;stdcall;
    PTRtlNtStatusToDosError=^TRtlNtStatusToDosError;

 ///  stream.h stream.c  end///
 ////////////////////////////////
 //////////////////////////
 /////////////////////
 ///  my define
const  DefaultTailer:array[0..20]of char= '::$DATA';
       AppendTailer:array[0..20]of char= ':$DATA';


type  Ret_Info=(
    RI_UnKnown,
    RI_UnNTFS,
    RI_CanNotAccessFile,
    RI_CanNotGetStreamsInfo,
    RI_NoStreams,
    RI_GetStreamsInfoOK,
    RI_NoSuchStream,
    RI_Search,
    RI_ChangeStreamOK,
    RI_ChangeStreamFail,
    RI_AddStreamOK,
    RI_AddStreamFail,
    RI_DelStreamOK,
    RI_DelStreamFail,
    RI_BackStreamOK,
    RI_BackStreamFail
    );



var global_KernelInitial:BOOL=false;
    NtQueryInformationFile:TNtQueryInformationFile;


function IsNTFS(path:string):BOOL;
function EnableTokenPrivilege(PrivilegeName:PChar):BOOL;
function EnableKernel:BOOL;
function  GetFileAllStreams(filename:string;StreamsNamesLst:TStringList):Ret_Info;
function  GetRetInfoMsg(istatus:Ret_Info):string;



function EnumAllDrivers(Drivers:TStringList):bool;
function EnumNtfsDrivers(Drivers:TStringList):bool;
function EnumDirs(const RootPath:string;Enfullpath:bool;Dirs:TStringList):bool;
function EnumFiles(const RootPath,FileFilter:string;Enfullpath:bool;Files:TStringList):bool;

function ShowHardLinkInfo(const filename:string;var number:integer):BOOL;

function ExtractSourceFileName(namewithstream:string):string;
function ExtractStreamName(namewithstream:string):string;
function  GetFileDataFast(filename:string;var filesize:DWORD;
                           var contextBuf;contextPos:DWORD;var contextsize:DWORD):BOOL;

function MyCopyFile(srcName:string;destName:string;rewrite:bool):bool;
function RegUrlProtocol(aProtocolName,
  aProtocolApplicationName: string; aUseParam: Boolean): Boolean;

function UnRegUrlProtocl(aProtocolName: string): Boolean;
procedure RegisterFileType(cMyExt,cMyFileType,cMyDescription,ExeName:string;
                          IcoIndex:integer;
                          DoUpdate:boolean=false);




function ReadTextFileFast(const FileName: string;var sText:string):BOOL;
function ReadHexFileFast(const FileName: string;var sText:string):BOOL;


///////////////////////////////////////////////////////////////////////////////////////////////



////////////////search /////////////////////////////
const WM_NSE_SEARCH_PROC=WM_USER+100;
      WM_NSE_SEARCH_END=WM_USER+101;

type
    PRetinfo_Search=^RetInfo_Search;
     RetInfo_Search=record
      allnumber:integer;
      nowfile:string;
      period:DWORD; ////GetTickCount
     end;

var TSearchThreadRunning:Boolean=false;
type
    TSearchThread = class(TThread)
     private
     Fhandle:THandle; ///窗口句柄
     FRootPaths:TStringList;    ///路径
     FStreamFilter:string;   ///流名称过滤
     FFiles:TStringList;//最终结果
     FPRI_Search:PRetinfo_Search;///处理返回信息
  protected
       procedure Execute; override;
  public
    constructor Create(aFhandle:THandle;
       aFRootPaths:TStringList;
       const aFStreamFilter: string;
       aFFiles:TStringList;
       aFPRI_Search:PRetinfo_Search);virtual;
  end;

   //////扫描中间处理
type
     ScanlistRecord=record
     pathname:String;
     streamname:string;
     size:DWORD;
     virusrank:integer;
  end;
   PScanlistRecord=^ScanlistRecord;
 procedure GetScanRecord(pScanRecord:PScanlistRecord);

/////////////add/////////////////////////////
const WM_NSE_ADD_OK=WM_USER+201;
      WM_NSE_ADD_FAIL=WM_USER+202;
      WM_NSE_ADD_END=WM_USER+203;

type
    PRetinfo_Add=^RetInfo_Add;
     RetInfo_Add=record
      allnumber:integer;
      oknumber:integer;
      failnumber:integer;
      nowfile:string;
      period:DWORD; ////GetTickCount
     end;

var TAddThreadRunning:Boolean=false;
type
    TAddThread = class(TThread)
     private
     Fhandle:THandle; ///窗口句柄
     FTargetFiles:TStringList;    ///目标路径
     FSourceFile:string;/////源文件
     FStreamName:string;   ///流名称
     FOverwrite:BOOL;///覆盖
     FPRI_ADD:PRetinfo_Add;///处理返回信息
  protected
     procedure Execute; override;
  public
    constructor Create(aFhandle:THandle;
       aFTargetFiles:TStringList;
       aFSourceFile: string;
       aFStreamName:string;
       aFOverwrite:BOOL;
       aFPRI_ADD:PRetinfo_Add);virtual;
  end;

/////////////DEL/////////////////////////////
const WM_NSE_DEL_OK=WM_USER+301;
      WM_NSE_DEL_FAIL=WM_USER+302;
      WM_NSE_DEL_END=WM_USER+303;

type
    PRetinfo_DEL=^RetInfo_DEL;
     RetInfo_DEL=record
      allnumber:integer;
      oknumber:integer;
      failnumber:integer;
      nowfile:string;
      period:DWORD; ////GetTickCount
     end;

var TDELThreadRunning:Boolean=false;
type
    TDELThread = class(TThread)
     private
     Fhandle:THandle; ///窗口句柄
     FTargetFiles:TStringList;    ///目标路径
     FPRI_DEL:PRetinfo_DEL;///处理返回信息
  protected
     procedure Execute; override;
  public
    constructor Create(aFhandle:THandle;
       aFTargetFiles:TStringList;
       aFPRI_DEL:PRetinfo_DEL);virtual;
  end;

/////////////EXP/////////////////////////////
const WM_NSE_EXP_OK=WM_USER+401;
      WM_NSE_EXP_FAIL=WM_USER+402;
      WM_NSE_EXP_END=WM_USER+403;

type
    PRetinfo_EXP=^RetInfo_EXP;
     RetInfo_EXP=record
      allnumber:integer;
      oknumber:integer;
      failnumber:integer;
      nowfile:string;
      period:DWORD; ////GetTickCount
     end;

var TEXPThreadRunning:Boolean=false;
type
    TEXPThread = class(TThread)
     private
     Fhandle:THandle; ///窗口句柄
     FSourceFiles:TStringList;    ///源文件
     FTargetFiles:TStringList; //目标文件 ///强行覆盖
     FPRI_EXP:PRetinfo_EXP;///处理返回信息
  protected
     procedure Execute; override;
  public
    constructor Create(aFhandle:THandle;
       aFSourceFiles:TStringList;
       aFTargetFiles:TStringList;
       aFPRI_EXP:PRetinfo_EXP);virtual;
  end;

function TEXPThread_Rename(filename:String):string;

  /////////////BAK/////////////////////////////
const WM_NSE_BAK_OK=WM_USER+501;
      WM_NSE_BAK_FAIL=WM_USER+502;
      WM_NSE_BAK_END=WM_USER+503;

type
    PRetinfo_BAK=^RetInfo_BAK;
     RetInfo_BAK=record
      allnumber:integer;
      oknumber:integer;
      failnumber:integer;
      nowfile:string;
      period:DWORD; ////GetTickCount
     end;

var TBAKThreadRunning:Boolean=false;
type
    TBAKThread = class(TThread)
     private
     Fhandle:THandle; ///窗口句柄
     FSourceFiles:TStringList;    ///源文件
     FTargetFile:string; //目标文件
     FPRI_BAK:PRetinfo_BAK;///处理返回信息
  protected
     procedure Execute; override;
  public
    constructor Create(aFhandle:THandle;
       aFSourceFiles:TStringList;
       aFTargetFile:string;
       aFPRI_BAK:PRetinfo_BAK);virtual;
  end;

function BAKAFileStreamFast(fullStreamName:string;TargetFileName:string):BOOL;

  /////////////RESTORE/////////////////////////////
const WM_NSE_RESTORE_OK=WM_USER+601;
      WM_NSE_RESTORE_FAIL=WM_USER+602;
      WM_NSE_RESTORE_END=WM_USER+603;

type
    PRetinfo_RESTORE=^RetInfo_RESTORE;
     RetInfo_RESTORE=record
      allnumber:integer;
      oknumber:integer;
      failnumber:integer;
      nowfile:string;
      period:DWORD; ////GetTickCount
     end;

var TRESTOREThreadRunning:Boolean=false;
type
    TRESTOREThread = class(TThread)
     private
     Fhandle:THandle; ///窗口句柄
     FSourceFile:string;    ///源文件
     FFiles:TStringList;//最终结果
     FOverwrite:BOOL;///覆盖
     FPRI_RESTORE:PRetinfo_RESTORE;///处理返回信息
  protected
     procedure Execute; override;
  public
    constructor Create(aFhandle:THandle;
       aFSourceFile:string;
       aFFiles:Tstringlist;
       aFOverwrite:BOOL;///覆盖
       aFPRI_RESTORE:PRetinfo_RESTORE);virtual;
  end;
function RestoreAFileStreamFast(Sourcename:string;beginpos:DWORD;bOverwrite:BOOL;
                  var nowpos:DWORD;var nowname:string):BOOL;
 ///////////////////////////////////


 const MYHEAD='NtfsStreamsEditor_V2.0_XuGanQuan';
      MYHEADSIZE=256;
      BUFSIZE=$4000;
      INVALID_SET_FILE_POINTER = DWORD(-1);
      MYMAX_PATHSIZE=MAX_PATH*sizeof(Char);
      CharBufSize=MYMAX_PATHSIZE+1;

 type
     PRestoreFileInfo=^RestoreFileInfo;
     RestoreFileInfo=record
       filename:string;
       filesize:DWORD;
 end;

function GetRestoreFileAllName(srcfile:string;listfile:TList):bool;
//////////////////////////////////////////////////////////////////////////
///

type
     deal_resultinfo=record
      time:TDateTime;
      context:string;
      ret:bool;
     end;

implementation

///////////////////////////////////////////////////
////指定路径是否支持ntfs
function IsNTFS(path:string):BOOL;
var fsFlags:DWORD;
    pdw:DWORD;
const FILE_NAMED_STREAMS=$00040000;
begin
    result:=false;
    fsFlags:=0;
    path:=ExtractFileDrive(path);
    if path='' then exit;
    //PathStripToRoot(Pchar(path));  //shlwapi
    {ExtractFileDrive(path);it is bad: csd:\\asd\ can not process
     PathStripToRoot Support E:WEQEWQ\tO89OemWERREWp\1.txtRFEWQRWER  }
     path:=IncludeTrailingPathDelimiter(path);
    //PathAddBackslash(Pchar(path));
		GetVolumeInformation(pchar(path), nil, 0, nil, pdw, fsFlags,nil, 0 );
    if (fsFlags and FILE_NAMED_STREAMS) >0 then result:=true;
   //result:=not ((fsFlags and FILE_NAMED_STREAMS) =0);
end;

/////////////////////////////////
/////获取操作权限
function EnableTokenPrivilege(PrivilegeName:PChar):BOOL;
var
	tpPrevious,tp:TOKEN_PRIVILEGES;
	luid:INT64;
	hToken:Thandle;
	cbPrevious:DWORD;
begin
	result:=FALSE;
  cbPrevious:=sizeof(TOKEN_PRIVILEGES);

	// Get debug privilege
	if  not (OpenProcessToken(GetCurrentProcess(),
                            TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
                            hToken)
            ) then
	begin
		exit;
	end;

	if not (LookupPrivilegeValue(nil,PrivilegeName,luid)) then
	begin
		exit;
	end;
     //
    // first pass.  get current privilege setting
    //
	tp.PrivilegeCount :=1;
	tp.Privileges[0].Luid:=luid;
	tp.Privileges[0].Attributes:=0;

	AdjustTokenPrivileges(
			hToken,
			False,
			tp,
			sizeof(TOKEN_PRIVILEGES),
			tpPrevious,
			cbPrevious);


  if not (GetLastError= ERROR_SUCCESS) then
   begin
    exit;
   end;

      //
    // second pass.  set privilege based on previous setting
    //
    tpPrevious.PrivilegeCount       := 1;
    tpPrevious.Privileges[0].Luid   := luid;
    tpPrevious.Privileges[0].Attributes :=tpPrevious.Privileges[0].Attributes or  SE_PRIVILEGE_ENABLED;
    AdjustTokenPrivileges(
            hToken,
            FALSE,
            tpPrevious,    //in
            cbPrevious,      //in
            tpPrevious,       //out
            cbPrevious         //out
            );
	result:=GetLastError()=ERROR_SUCCESS;
end;



///////////////
// 允许权限和获得地址
function EnableKernel:BOOL;
begin
  EnableTokenPrivilege('SeBackupPrivilege');
  @NtQueryInformationFile:=GetProcAddress(
                        GetModuleHandle('ntdll.dll'),
                        'NtQueryInformationFile');
  Global_KernelInitial:=not (@NtQueryInformationFile=nil);
  result:=Global_KernelInitial;
end;


////////////////////////
/// 获得一个文件的全部数据流，名称放在stringlist
function  GetFileAllStreams(filename:string;StreamsNamesLst:TStringList):Ret_Info;
var
   fileHandle:Thandle;
   streamInfoSize:ULONG;
   streamInfo,streamInfoPtr:PFILE_STREAM_INFORMATION;
   streamName:array[0..MAX_PATH]of WChar;
   ioStatus:IO_STATUS_BLOCK;
   status:NTSTATUS;
   streanNum:DWORD;
   streamNameLen:Integer;
   LastAddName:string;
begin
   Result:=Ret_Info.RI_UnKnown;
   ///检查是否能进行操作
  if Global_KernelInitial=false then
  begin
  result:=Ret_Info.RI_UnNTFS;
  exit;
  end;
   {open dir file
     c:\      c:
     c:\asd c:\asd\
     c:\asd\file.txt
   }

   fileHandle:=CreateFile(PChar(filename),
                          GENERIC_READ,
                          FILE_SHARE_READ or FILE_SHARE_WRITE,
                          nil,
                          OPEN_EXISTING,
                          FILE_FLAG_BACKUP_SEMANTICS,
                          0);
   if (fileHandle=INVALID_HANDLE_VALUE) then
   begin
      result:=Ret_Info.RI_CanNotAccessFile;
      Exit;
   end;

   streanNum:=0;
   streamInfoSize:=$4000;
   Getmem(streamInfo,streamInfoSize);
   status:=STATUS_BUFFER_OVERFLOW;
   while(status=STATUS_BUFFER_OVERFLOW)do
   begin
      status:=NtQueryInformationFile(fileHandle,
                                    @ioStatus,
                                    streamInfo,
                                    streamInfoSize,
                                    FileStreamInformation);
      if(status=STATUS_BUFFER_OVERFLOW)then
      begin
         Freemem(streamInfo);
         inc(streamInfoSize,$4000);
         Getmem(streamInfo,streamInfoSize);
      end else
      begin
          break;
      end;
   end;//while end

     ////// if success and has info
   if ( (NTSTATUS(status)>=0) and (ioStatus.Information<>0) )then
   begin
         streamInfoPtr:=streamInfo;
         while(true)do
         begin
           Move(streamInfoPtr^.Name,streamName,streamInfoPtr^.NameLength);
           streamName[streamInfoPtr^.NameLength div 2]:= #0;

           ///Skip the standard Data stream
           ///  ::$DATA  (7)  :$DATA(6)  :asd.aaa:$DATA  (>7)
           ///
           streamNameLen:=StrLen(streamName); //Returns number of characters not size
           if streamNameLen>7 then
           begin
           ///提取字符
             LastAddName:=Copy(streamName,2,streamNameLen-7);
             StreamsNamesLst.Add(LastAddName);
             inc(streanNum);
           end;
           if (streamInfoPtr^.NextEntry=0) then break;
           streamInfoPtr:=PFILE_STREAM_INFORMATION(PByte(streamInfoPtr)+streamInfoPtr^.NextEntry);
         end;  ///entry list
   end else
   begin
        if NTSTATUS(status)<0 then result:=Ret_Info.RI_CanNotGetStreamsInfo;
        FreeMem(streamInfo);
        CloseHandle(filehandle);
        result:=Ret_Info.RI_UnKnown;
        exit;
   end;   ///if success and has info

   FreeMem(streamInfo);
   CloseHandle(filehandle);
   if streanNum=0 then result:=Ret_Info.RI_NoStreams else
   result:=Ret_Info.RI_GetStreamsInfoOK;
end;



//////////////////
///获取返回信息
function  GetRetInfoMsg(istatus:Ret_Info):string;
begin
  case istatus of
    Ret_Info.RI_UnKnown:result:='未知错误';
    Ret_Info.RI_UnNTFS:result:='不是NTFS文件系统';
    Ret_Info.RI_CanNotAccessFile:result:='不能打开文件';
    Ret_Info.RI_CanNotGetStreamsInfo:result:='不能获得文件的附加数据流信息';
    Ret_Info.RI_NoStreams:result:='文件没有交换数据流';
    Ret_Info.RI_GetStreamsInfoOK:result:='成功获取文件的交换数据流信息';
    Ret_Info.RI_NoSuchStream:result:='无指定名称的交换数据流';
    Ret_Info.RI_DelStreamOK:result:='删除附加交换数据流成功';
    Ret_Info.RI_DelStreamFail:result:='不能删除指定的交换数据流';
  end;
end;




//////////////////获取文件大小和快速信息////////////////
function  GetFileDataFast(filename:string;var filesize:DWORD;var contextBuf;contextPos:DWORD;var contextsize:DWORD):BOOL;
var filehandle:THandle;
const
  INVALID_SET_FILE_POINTER = DWORD(-1);
begin
  result:=FALSE;
  filehandle:=CreateFile(pchar(filename),
                      GENERIC_READ,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil,
                      OPEN_EXISTING,
                      0,
                      0);
 if (filehandle=INVALID_HANDLE_VALUE) then
 begin
  filesize:=DWORD(-1);
  contextsize:=0;
  Exit;
 end;

 filesize := GetFileSize(filehandle,Nil);
 if (filesize = INVALID_FILE_SIZE) then
 begin
   filesize:=DWORD(-1);
   contextsize:=0;
   CloseHandle(filehandle);
   exit;
 end;
{
 if Pointer(contextBuf)=nil then
 begin
   contextsize:=0;
   Result:=true;
   CloseHandle(filehandle);
   exit;
 end;    }

 if contextPos>filesize then
 begin
   contextsize:=0;
   CloseHandle(filehandle);
   exit;
 end;


 if (INVALID_SET_FILE_POINTER = SetFilePointer(filehandle,contextPos,NIL,FILE_BEGIN)) then
 begin
   contextsize:=0;
   CloseHandle(filehandle);
   Exit;
 end;

 ReadFile( filehandle, contextBuf,contextsize,contextsize,Nil);

  Closehandle(filehandle);
  result:=true;

end;



/////枚举全部磁盘
function EnumAllDrivers(Drivers:TStringList):bool;
var drvdw:DWORD;
    i:integer;
begin
   result:=false;
    Drivers.Clear;
    i:=$41;  //A
  drvdw:=GetLogicalDrives;
  if drvdw>0then
  begin
    repeat
      if (drvdw and $1)=1 then
        begin
        Drivers.Add(chr(i)+':');
        end;
       drvdw:=drvdw shr 1;
      inc(i);
    until(drvdw=0);
   result:=true;
  end;
end;

/////枚举全部NTFS磁盘
function EnumNtfsDrivers(Drivers:TStringList):bool;
var drvdw:DWORD;
    i,drvnum:integer;
    tempdrv:string;
begin
   result:=false;
   drvnum:=0;
   Drivers.Clear;
   i:=$41;   //A
  drvdw:=GetLogicalDrives;
  if drvdw>0 then
  begin
    repeat
      if (drvdw and $1)=1 then
        begin
        tempdrv:=chr(i)+':';
        if NSekernel.IsNTFS(tempdrv)then
           begin
             inc(drvnum);
             Drivers.Add(chr(i)+':');
           end;
        end;
       drvdw:=drvdw shr 1;
      inc(i);
    until(drvdw=0);
  end;
    if  drvnum>0 then   result:=true;

end;

function EnumDirs(const RootPath:string;Enfullpath:bool;Dirs:TStringList):bool;
var myRootpath:string;
    FindHandle:THandle;
    wfd:TWin32FindData ;
    tempname:string;
begin
  result:=false;
   myRootpath:=ExcludeTrailingPathDelimiter(RootPath);   //删了再加 防止c:\ c: c:\a\a\
   Dirs.Clear;
   FindHandle:=Windows.FindFirstFile(PChar(myRootpath+'\*'), wfd) ;
   if FindHandle<> INVALID_HANDLE_VALUE then
   begin
      try
       repeat
          if ( wfd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY )<> 0  then
          begin
           tempname:=wfd.cFileName;
           if (tempname<> '.') and (tempname<>'..') then
           begin
           if Enfullpath=true then tempname:=myRootpath+'\'+tempname;
           Dirs.Add(tempname);
           end;
          end; ////找到目录
       until not Windows.FindNextFile(FindHandle, wfd);
      finally
        Windows.FindClose(FindHandle);
      end;
     result:=true;
   end ;

end;

function EnumFiles(const RootPath,FileFilter:string;Enfullpath:bool;Files:TStringList):bool;
var myRootpath:string;
    FindHandle:THandle;
    wfd:TWin32FindData ;
    tempname:string;
begin
   result:=false;
   myRootpath:=ExcludeTrailingPathDelimiter(RootPath);//删了再加 防止c:\ c: c:\a\a\
   Files.Clear;
   FindHandle:=Windows.FindFirstFile(PChar(myRootpath+'\'+FileFilter), wfd) ;
   if FindHandle<> INVALID_HANDLE_VALUE then
   begin
     try
       repeat
          if (wfd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY )= 0  then
          begin
           tempname:=wfd.cFileName;
           if Enfullpath=true then tempname:=myRootpath+'\'+tempname;
           Files.Add(tempname);
          end;
        until not Windows.FindNextFile(FindHandle, wfd);
      finally
        Windows.FindClose(FindHandle);
      end;
      result:=true;
    end;
end;



////////////////////////////////////////////////////////////////
function ExtractSourceFileName(namewithstream:string):string;
var
  I: Integer;
begin
  I := LastDelimiter(':', namewithstream);
  if (I > 0) and (namewithstream[I] = ':') then
    Result := Copy(namewithstream, 0, I-1) else
    Result := namewithstream;
end;

//////////////////////////////////////////////////
function ExtractStreamName(namewithstream:string):string;
var
  I: Integer;
begin
  I := LastDelimiter(':', namewithstream);
  if (I > 0) and (namewithstream[I] = ':') then
    Result := Copy(namewithstream, I+1, MaxInt) else
    Result := '';
end;
/////////////////////////////////////////////////////////////
function ShowHardLinkInfo(const filename:string;var number:integer):BOOL;
var HFile:THandle;
    bhfi:BY_HANDLE_FILE_INFORMATION ;
    ret:BOOL;
begin
   result:=false;
   HFile:=CreateFile(pchar(filename),
                      GENERIC_READ,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil,
                      OPEN_EXISTING,
                      FILE_FLAG_SEQUENTIAL_SCAN,
                      0);
  if (HFile=INVALID_HANDLE_VALUE) then
  begin
    Exit;
  end;
   ret:= GetFileInformationByHandle(hfile, &bhfi);
	 CloseHandle(hfile);
	 if not ret then Exit;
   number:=bhfi.nNumberOfLinks;
   result:=true;
end;

////////////////////////////////////////////////////////////
function MyCopyFile(srcName:string;destName:string;rewrite:bool):bool;
var filehandleSrc,filehandleDest:THandle;
    filesizeSrc,filesizeDest:DWORD;
    brSrc,brDest:BOOL;
    posSrc,posDest:DWORD;
    tempSrcPos,tempDestPos:DWORD;
    Buf:array[0..BUFSIZE-1]of byte;
    readsizeSrc,WritesizeDest:ULONG;
    FileOpenMode:DWORD;
    ShouldRead:DWORD;
begin
   Result:=false;
   ///////////////////////////////////////////////////////////////////////
  filehandlesrc:=CreateFile(pchar(srcName),
                      GENERIC_READ,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil,
                      OPEN_EXISTING,
                      0,
                      0);
  if (filehandlesrc=INVALID_HANDLE_VALUE) then
  begin
    Exit;
  end;


  filesizesrc:=GetFileSize(filehandlesrc,nil);
  if INVALID_FILE_SIZE=filesizesrc then
  begin
     Closehandle(filehandlesrc);
     Exit;
  end;

/////////////////////////////////////////////////////////////
   tempSrcPos:=0;
   posSrc:=SetFilePointer(filehandlesrc,tempSrcPos,nil,FILE_BEGIN);
   if possrc=INVALID_SET_FILE_POINTER then
   begin
       Closehandle(filehandlesrc);
       Exit;
   end;
////////////////////////////////////////

 if rewrite then FileOpenMode:=OPEN_ALWAYS else FileOpenMode:=CREATE_NEW;
//////////////////////////////////////////////
   filehandledest:=CreateFile(Pchar(destName),
                      GENERIC_WRITE,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil,
                      FileOpenMode,
                      FILE_ATTRIBUTE_NORMAL,
                      0);
  if (filehandledest=INVALID_HANDLE_VALUE) then
  begin
     Closehandle(filehandlesrc);
     Exit;
  end;

    posdest:=0;
    posdest:=SetFilePointer(filehandledest,posdest,nil,FILE_BEGIN);
   if posdest=INVALID_SET_FILE_POINTER then
    begin
     Closehandle(filehandleSrc);
     Closehandle(filehandledest);
     Exit;
    end;

/////////////还原一个文件////////////////////////////////////////////
   tempDestPos:=0;  //当前文件相对
   posdest:=0;
   filesizeDest:=filesizesrc;
   while(tempDestPos<filesizeDest) do
   begin
    ///////读/////////////////
    possrc:=tempSrcPos+tempDestPos;
    possrc:=SetFilePointer(filehandlesrc,possrc,nil,FILE_BEGIN);
     if possrc=INVALID_SET_FILE_POINTER then
     begin
     Closehandle(filehandleSrc);
     Closehandle(filehandledest);
     Exit;
     end;
     Zeromemory(@buf,BUFSIZE);
     ShouldRead:=filesizeDest-tempDestPos;
     if (ShouldRead>BUFSIZE) then ShouldRead:=BUFSIZE;
     brsrc:=ReadFile(filehandlesrc,Buf,ShouldRead,readsizesrc,nil);

      if (brsrc=false)or (ShouldRead<>readsizesrc)  then
      begin
        Closehandle(filehandleSrc);
        Closehandle(filehandledest);
        Exit;
      end;
      //////写
      posdest:=SetFilePointer(filehandledest,posdest,nil,FILE_BEGIN);
      if posdest=INVALID_SET_FILE_POINTER then
      begin
        Closehandle(filehandleSrc);
        Closehandle(filehandledest);
        Exit;
      end;

      brdest:=WriteFile(filehandledest,buf,ShouldRead,Writesizedest,nil);
      if (brdest=false) or (ShouldRead<>Writesizedest) then
      begin
        Closehandle(filehandleSrc);
        Closehandle(filehandledest);
        Exit;
      end;

     posdest:=posdest+ShouldRead;
     tempDestPos:=tempDestPos+ShouldRead;
   end;   ////一个文件还原完毕

    Closehandle(filehandledest);
    Closehandle(filehandlesrc);
    Result:=true;
end;
 //////////////////////////////////////////////////////



 function WordLoHiExchange(w:Word):Word; register;
  asm XCHG AL, AH end; { TextFormat返回文本编码类型，sText未经处理的文本 }


function ReadTextFileFast(const FileName: string;var sText:string):BOOL;
const TMPBUFSIZE=32768;
var filesize:DWORD;
    tmpBuf:array[0..TMPBUFSIZE-1]of Byte;
    CodeBuf:TBytes;
    CodeOffset:DWORD;
    CodeEncodeing:TEncoding;
    realsize:DWORD;
    ret:BOOL;
    tmpstr:string;
    dwi:DWORD;
begin
  Result:=false;
  realsize:=TMPBUFSIZE;
  tmpstr:='[文本]';
  ret:=GetFileDataFast(FileName,filesize,tmpBuf,0,realsize);
  if not ret then
  begin
    tmpstr:=tmpstr+'(无法读取文件)'+#13#10;
    sText:=tmpstr;
    Exit;
  end;

    if realsize=0 then
  begin
    tmpstr:=tmpstr+'(文件大小0字节)'+#13#10;
    sText:=tmpstr;
    Exit;
  end;

  if filesize<realsize then realsize:=filesize;

  Setlength(Codebuf,realsize);
  for dwi := 0 to realsize - 1 do
    CodeBuf[dwi]:=tmpBuf[dwi];


  try
  CodeEncodeing:=nil;/////import
  CodeOffset :=TEncoding.GetBufferEncoding(CodeBuf, CodeEncodeing);
  tmpstr:=tmpstr+'(自动识别编码类型:'+CodeEncodeing.ToString+')'+#13#10;
  tmpstr:=tmpstr+CodeEncodeing.GetString(CodeBuf, CodeOffset, realsize - CodeOffset);
  except
   tmpstr:='(无法读取文件)'+#13#10;
  end;

  if filesize>realsize then
    tmpstr:=tmpstr+#13#10+'(文件大小:'+Format('%u',[filesize])+
            '字节;只显示了前32768字节内容)';
   sText:=tmpstr;
   result:=true;
end;


function ReadHexFileFast(const FileName: string;var sText:string):BOOL;
const TMPBUFSIZE=32768;
var filesize:DWORD;
    tmpBuf:array[0..TMPBUFSIZE-1]of Byte;///not uses TBytes 动态数组不连续 除非stream
    onebuf:byte;
    realsize:DWORD;
    ret:BOOL;
    tmpstr:string;
    dwi,dw2:DWORD;

    leftstr,midstr:string;
    rigthstr:string;
    midLen:DWORD;
begin
  Result:=false;
  realsize:=TMPBUFSIZE;
  ret:=GetFileDataFast(FileName,filesize,tmpBuf,0,realsize);

  midLen:=0;
  tmpstr:='[16进制]'+#13#10;
  tmpstr:=tmpstr+
'        | 00 01 02 03 04 05 06 07  08 09 0A 0B 0C 0D 0E 0F  0123456789ABCDEF'+#13#10+
'        |---------------------------------------------------------------------'+#13#10;

  if not ret then
  begin
    tmpstr:=tmpstr+'(无法读取文件)'+#13#10;
    sText:=tmpstr;
    Exit;
  end;

  if realsize=0 then
  begin
    tmpstr:=tmpstr+'00000000|（文件大小0字节)'+#13#10;
    sText:=tmpstr;
    Exit;
  end;

  if filesize<realsize then realsize:=filesize;


  leftstr:='';
  midstr:='';
  rigthstr:='';
  for dwi := 0 to realsize - 1 do
  begin
    inc(midLen);
    if midLen=1  then
    begin
      leftstr:=inttoHex(dwi*16,8)+'| '; ///additional 1 blank
    end;

    onebuf:=tmpBuf[dwi];
    midstr:=midstr+inttohex(onebuf,2)+' ';  ///1 blank

    if onebuf in [20..126] then
    rigthstr:=rigthstr+Chr(onebuf)
    else
    rigthstr:=rigthstr+'.';

    if midLen=8  then
    begin
      midstr:=midstr+' ';  ///additional 1 blank
    end;

    if midLen=16 then
    begin
      midstr:=midstr+' ';   ///2 blank  to rigthstr
      rigthstr:=rigthstr+#13#10;
      tmpstr:=tmpstr+leftstr+midstr+rigthstr;
      midLen:=0;
      leftstr:='';
      midstr:='';
      rigthstr:='';
    end;

    ////不满1行，midstr加入空白字符
    if dwi=realsize-1 then
    begin
     for dw2 := 1 to 16-midLen do
     begin
        midstr:=midstr+'   ' ;  ///3 blank
        if  8=midlen+dw2  then
        begin
          midstr:=midstr+' ';   ///additional 1 blank
        end;
     end;
     midstr:=midstr+' ';    //////2 blank  to rigthstr add 1
     tmpstr:=tmpstr+leftstr+midstr+rigthstr;
    end;//不满1行，

  end; ///for end

   if filesize>realsize then
    tmpstr:=tmpstr+#13#10+'（文件大小:'+Format('%u',[filesize])+
            '字节;只显示了前32768字节内容)';

   sText:=tmpstr;
   result:=true;

end;
///////////////////////////////////////////
procedure GetScanRecord(pScanRecord:PScanlistRecord);
var streamname,filename:string;
    filesize:DWORD;
    ContextWORD:WORD;
    ContextSize:DWORD;
    tmprank,okend:integer;
begin
   filename:=pScanRecord.pathname;
   streamname:=ExtractStreamName(filename);
   pScanRecord.streamname:=streamname;

   filesize:=0;
   tmprank:=0;
   okend:=0;////不需要再判断的标志
   ContextWORD:=0;
   ContextSize:=Sizeof(ContextWORD);
   if not GetFileDataFast(filename,filesize,ContextWORD,0,ContextSize) then
   begin
     pScanRecord.size:= DWORD(-1);
     pScanRecord.virusrank:=tmprank;
     okend:=1;
   end;

   if filesize<ContextSize then okend:=1;
  /////////////////////////////////////////////////////////////////////////////

   ////////////////////////////
  if (streamname='favicon') and (filesize<$1000) then
  begin
    tmprank:=0;
    okend:=1;
  end;

  if (streamname='KAVICHS') and (filesize<$100 )then
  begin
    tmprank:=0;
    okend:=1;
  end;

  if (streamname='Zone.Identifier') and (filesize<$100 )then
  begin
    tmprank:=0;
    okend:=1;
  end;

  if filesize=0 then
  begin
    tmprank:=0;
    okend:=1;
  end;

   if okend=0 then
   begin
     tmprank:=1;   //数据流名
     if filesize>$1000 then  inc(tmprank);   //数据流尺寸
     if filesize>$8000 then  inc(tmprank);
     if ContextWORD=$5A4D then  inc(tmprank,2);   //内容
   end;

    pScanRecord.size:= filesize;
    pScanRecord.virusrank:=tmprank;
end;





 //////////////searchthread
constructor TSearchThread.Create(aFhandle:THandle;
       aFRootPaths:TStringList;
       const aFStreamFilter: string;
       aFFiles:TStringList;
       aFPRI_Search:PRetinfo_Search);
begin
   inherited Create(true);
   FreeOnTerminate:=True;
   Fhandle:=aFhandle;
   FRootPaths:=aFRootPaths;
   FStreamFilter:=aFStreamFilter;
   FFiles:=aFFiles;
   FPRI_Search:=aFPRI_Search;

end;



 ////队列遍历   或者用tstack
procedure  TSearchThread.Execute;
var myRootpath:string;
    pathnum:integer;
    FindHandle:THandle;
    wfd:TWin32FindData ;
    tempname:string;
    dirs:TQueue;
    Curdir:PChar;
    temppath:string;
    streamlst:Tstringlist;
    i,listindex:integer;
    Firsttime:DWORD;
begin
    Firsttime:=GettickCount;
    FFiles.Clear;
    listindex:=0;
    FPRI_Search.allnumber:=0;
    pathnum:=0;
    dirs:=TQueue.Create;//创建目录队列
    streamlst:=TStringList.Create;
    while pathnum<FRootPaths.Count do
    begin ////all paths

    if Terminated then break;
    myRootpath:=ExcludeTrailingPathDelimiter(FRootPaths[pathnum]); //目录不需要\ 驱动器C::asd C:\:asd 都可
    dirs.Push(Pchar(myRootPath)) ;
    curDir:=PChar(dirs.Pop);//出队

    FPRI_Search.nowfile:=StrPas(curDir);
     ///寻找本身的数据流
    if Ret_Info.RI_GetStreamsInfoOK=GetFileAllStreams(curDir,streamlst)then
     begin
        for I := 0 to streamlst.Count - 1 do
         begin
          if Terminated then break;
          if MatchesMask(streamlst[i],FStreamFilter)=True then
          begin
            temppath:=StrPas(curDir)+':'+streamlst[i];
            FFiles.Add(temppath);
            Inc(FPRI_Search.allnumber);
            listindex:=FPRI_Search.allnumber-1;
            SendMessage(Fhandle,WM_NSE_SEARCH_PROC,listindex,0);
          end;
        end;
        streamlst.Clear;
     end;

          while curDir<>nil do
          begin
             if Terminated then break;
             FPRI_Search.nowfile:=StrPas(curDir);
             temppath:=StrPas(curDir)+'\*';
             FindHandle:=Windows.FindFirstFile(Pchar(temppath),wfd);
              if FindHandle<> INVALID_HANDLE_VALUE then
              begin
                try
                  repeat
                   if Terminated then break;
                  tempname:=wfd.cFileName;
                  if (tempname<> '.') and (tempname<>'..') then  //排除本身和上级目录
                  begin
                     temppath:=StrPas(curDir)+'\'+tempname;
                     FPRI_Search.nowfile:=temppath;
                     if ( wfd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY )<> 0  then//是目录
                     begin
                         dirs.Push(StrNew(PChar(temppath)));
                            {将搜索到的目录入队。让它先晾着。
                            因为TQueue里面的数据只能是指针,所以要把string转换为PChar
                            同时使用StrNew函数重新申请一个空间存入数据，否则会使已经进
                            入队列的指针指向不存在或不正确的数据(tmpStr是局部变量)。}
                     end;
                     if Ret_Info.RI_GetStreamsInfoOK=GetFileAllStreams(temppath,streamlst)then
                     begin
                         for I := 0 to streamlst.Count - 1 do
                         begin
                           if MatchesMask(streamlst[i],FStreamFilter)=True then
                           begin
                           temppath:=StrPas(curDir)+'\'+tempname+':'+streamlst[i];
                           FFiles.Add(temppath);
                           Inc(FPRI_Search.allnumber);
                           listindex:=FPRI_Search.allnumber-1;
                           SendMessage(Fhandle,WM_NSE_SEARCH_PROC,listindex,0);
                           end; ////match
                         end;  ////count
                         streamlst.Clear;
                       end;
                   end;  ///invalid path or file or disk
                 until not Windows.FindNextFile(FindHandle, wfd);
                finally
                  Windows.FindClose(FindHandle);
                end;
              end;///filehandle valid
            {当前目录找到后，如果队列中没有数据，则表示全部找到了；
                否则就是还有子目录未查找，取一个出来继续查找。}
           if dirs.Count > 0 then   curDir:=Pchar(dirs.Pop)   else       curDir:=nil;
            FPRI_Search.period:=GettickCount-Firsttime;
          end; ///one path while end
   inc(pathnum);
  end;  ///all path end
  dirs.Free;
  streamlst.Free;
  TSearchThreadRunning:=false;
  SendMessage(Fhandle,WM_NSE_SEARCH_END,listindex,0);
end;
///////////////////////////////////////////////////////////////////////
///  addthread/////////////////////////////////////
constructor TAddThread.Create(aFhandle:THandle;
       aFTargetFiles:TStringList;
       aFSourceFile: string;
       aFStreamName:string;
       aFOverwrite:BOOL;
       aFPRI_ADD:PRetinfo_Add);
begin
   inherited Create(true);
   FreeOnTerminate:=True;
  Fhandle:=aFhandle;
  FTargetFiles:=aFTargetFiles;
  FSourceFile:=aFSourceFile;
  FStreamName:=aFStreamName;
  FOverwrite:=aFOverwrite;
  FPRI_ADD:=aFPRI_ADD;
end;

procedure TAddthread.Execute;
var i:integer;
    tmpname:string;
    ret:BOOL;
    listindex:integer;
    Firsttime:DWORD;
begin
   Firsttime:=GetTickCount;
   listindex:=0;
   FPRi_ADD.allnumber:=0;
   FPRi_ADD.oknumber:=0;
   FPRi_ADD.failnumber:=0;
   for I := 0 to FTargetFiles.Count - 1 do
   begin
     if Terminated  then break;
     inc(FPRi_ADD.allnumber);
     listindex:=i;
     tmpname:=FTargetFiles[i];
     FPRI_ADD.nowfile:=tmpname;
     ret:=MyCopyFile(FSourceFile,tmpname,FOverwrite);
     if ret=true then
     begin
       inc(FPRi_ADD.oknumber);
       SendMessage(Fhandle,WM_NSE_ADD_OK,listindex,0);
     end else
     begin
        inc(FPRi_ADD.failnumber);
        SendMessage(Fhandle,WM_NSE_ADD_Fail,listindex,0);
     end;
     FPRi_ADD.period:=GettickCount-Firsttime;
   end;
    TADDThreadRunning:=false;
    SendMessage(Fhandle,WM_NSE_ADD_END,listindex,0);
end;

////////////////////////////////////
///  DELthread/////////////////////////////////////
constructor TDELThread.Create(aFhandle:THandle;
       aFTargetFiles:TStringList;
       aFPRI_DEL:PRetinfo_DEL);
begin
   inherited Create(true);
   FreeOnTerminate:=True;
  Fhandle:=aFhandle;
  FTargetFiles:=aFTargetFiles;
  FPRI_DEL:=aFPRI_DEL;
end;

procedure TDELthread.Execute;
var i:integer;
    ret:BOOL;
    listindex:integer;
    Firsttime:DWORD;
begin
   Firsttime:=GetTickCount;
   listindex:=0;
   FPRi_DEL.allnumber:=0;
   FPRi_DEL.oknumber:=0;
   FPRi_DEL.failnumber:=0;
   for I := 0 to FTargetFiles.Count - 1 do
   begin
     if Terminated  then break;
     inc(FPRi_DEL.allnumber);
     listindex:=i;
     FPRI_DEL.nowfile:=FTargetFiles[i];
     ret:=windows.DeleteFile(Pchar(FTargetFiles[i]));
     if ret=true then
     begin
       inc(FPRi_DEL.oknumber);
       SendMessage(Fhandle,WM_NSE_DEL_OK,listindex,0);
     end else
     begin
        inc(FPRi_DEL.failnumber);
        SendMessage(Fhandle,WM_NSE_DEL_Fail,listindex,0);
     end;
     FPRi_DEL.period:=GettickCount-Firsttime;
   end;
    TDELThreadRunning:=false;
    SendMessage(Fhandle,WM_NSE_DEL_END,listindex,0);
end;
//////////////////////////////////////////////////////////////////
///  EXPthread/////////////////////////////////////
constructor TEXPThread.Create(aFhandle:THandle;
       aFSourceFiles:TStringList;
       aFTargetFiles:TStringList;
       aFPRI_EXP:PRetinfo_EXP);
begin
   inherited Create(true);
   FreeOnTerminate:=True;
  Fhandle:=aFhandle;
  FSourceFiles:=aFSourceFiles;
  FTargetFiles:=aFTargetFiles;
  FPRI_EXP:=aFPRI_EXP;
end;

////冒号:  用!代替  \反斜杠 用 _代替
function TEXPThread_Rename(filename:String):string;
var i,len:integer;
begin
     Result:= filename;
    len:=Length(filename);
   for I := 1 to len do
   begin
     if Result[i]=':' then Result[i]:='!';
     if Result[i]='\' then Result[i]:='_';
   end;
end;

procedure TEXPthread.Execute;
var i:integer;
    ret:BOOL;
    listindex:integer;
    Firsttime:DWORD;
begin

   Firsttime:=GetTickCount;
   listindex:=0;
   FPRi_EXP.allnumber:=0;
   FPRi_EXP.oknumber:=0;
   FPRi_EXP.failnumber:=0;
   for I := 0 to FSourceFiles.Count - 1 do
   begin
     if Terminated  then break;
     inc(FPRi_EXP.allnumber);
     listindex:=i;
     FPRi_EXP.nowfile:=FSourceFiles[i];
     ret:=MyCopyFile(FSourceFiles[i],
                     FTargetFiles[i],
                     true);  //强行覆盖
     if ret=true then
     begin
       inc(FPRi_EXP.oknumber);
       SendMessage(Fhandle,WM_NSE_EXP_OK,listindex,0);
     end else
     begin
        inc(FPRi_EXP.failnumber);
        SendMessage(Fhandle,WM_NSE_EXP_Fail,listindex,0);
     end;
     FPRi_EXP.period:=GettickCount-Firsttime;
   end;
    TEXPThreadRunning:=false;
    SendMessage(Fhandle,WM_NSE_EXP_END,listindex,0);
end;


//////////////////////////////////////////////////////////////////
///  BAKthread/////////////////////////////////////
constructor TBAKThread.Create(aFhandle:THandle;
       aFSourceFiles:TStringList;
       aFTargetFile:string;
       aFPRI_BAK:PRetinfo_BAK);
begin
   inherited Create(true);
   FreeOnTerminate:=True;
  Fhandle:=aFhandle;
  FSourceFiles:=aFSourceFiles;
  FTargetFile:=aFTargetFile;
  FPRI_BAK:=aFPRI_BAK;
end;

//////////////////
function BAKaFileStreamFast(fullStreamName:string;TargetFileName:string):BOOL;
var filehandleSrc,filehandleDest:THandle;
    brSrc,brDest:BOOL;
    posSrc,posDest:DWORD;
    filesizeSrc,filesizeDest:DWORD;
    strbuf:array[0..CharBUFSize-1]of char;
    Buf:array[0..BUFSIZE-1]of byte;
    readsizeSrc,WritesizeDest:ULONG;
    tempDestPos:DWORD;
    ShouldWrite:DWORD;
begin
  result:=false;
///////////////////////////////////////////////////////////////////////
  filehandlesrc:=CreateFile(pchar(fullStreamName),
                      GENERIC_READ,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil,
                      OPEN_EXISTING,
                      0,
                      0);
 if (filehandlesrc=INVALID_HANDLE_VALUE) then
 begin
  Closehandle(filehandlesrc);
  Exit;
 end;

    filesizesrc:=GetFileSize(filehandlesrc,nil);
   if INVALID_FILE_SIZE=filesizesrc then
   begin
     Closehandle(filehandlesrc);
     Exit;
   end;
//////////////////////////////////////////////
   filehandledest:=CreateFile(pchar(TargetFileName),
                      GENERIC_WRITE,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil,
                      OPEN_ALWAYS,
                      FILE_ATTRIBUTE_NORMAL,
                      0);
 if (filehandledest=INVALID_HANDLE_VALUE) then
 begin
  Closehandle(filehandledest);
  Closehandle(filehandlesrc);
  Exit;
 end;

     filesizedest:=GetFileSize(filehandledest,nil);
   if INVALID_FILE_SIZE=filesizedest then
   begin
     Closehandle(filehandledest);
     Closehandle(filehandlesrc);
     Exit;
   end;
   /////////////////////////////////////
   posdest:=SetFilePointer(filehandledest,0,nil,FILE_END);
    if posdest=INVALID_SET_FILE_POINTER then
      begin
     Closehandle(filehandledest);
     Closehandle(filehandlesrc);
     Exit;
   end;
//////////////////////////write head//////////////////////
     Zeromemory(@strbuf,CharBufSize);
     stringtowidechar(MYHEAD,strbuf,CharBufSize);
     brdest:=WriteFile(filehandledest,strbuf,MYHEADSIZE,Writesizedest,nil);
    if (brdest=false) or (MYHEADSIZE<>Writesizedest) then
   begin
     Closehandle(filehandledest);
     Closehandle(filehandlesrc);
     Exit;
   end;


     Zeromemory(@strbuf,CharBufSize);
     stringtowidechar(fullStreamName,strbuf,CharBufSize);
     brdest:=WriteFile(filehandledest,strbuf,MYMAX_PATHSIZE,Writesizedest,nil);
    if (brdest=false) or (MYMAX_PATHSIZE<>Writesizedest)then
   begin
     Closehandle(filehandledest);
     Closehandle(filehandlesrc);
     Exit;
   end;

  brdest:=WriteFile(filehandledest,filesizesrc,sizeof(filesizesrc),Writesizedest,nil);
    if (brdest=false)or (sizeof(filesizesrc)<>Writesizedest) then
   begin
     Closehandle(filehandledest);
     Closehandle(filehandlesrc);
     Exit;
   end;
////////////////循环写入 超过填入空白////////////////////////
   tempDestPos:=0;
   possrc:=0;
   while(tempDestPos<filesizesrc) do
   begin
    possrc:=SetFilePointer(filehandlesrc,possrc,nil,FILE_BEGIN);
      if possrc=INVALID_SET_FILE_POINTER then
     begin
       Closehandle(filehandledest);
       Closehandle(filehandlesrc);
       Exit;
     end;

     Zeromemory(@buf,BUFSIZE);
     ShouldWrite:=filesizesrc-tempDestPos;
     if (ShouldWrite>BUFSIZE) then ShouldWrite:=BUFSIZE;

     brsrc:=ReadFile(filehandlesrc,Buf,ShouldWrite,readsizesrc,nil);
     if (brsrc=false) or (ShouldWrite<>readsizesrc) then
     begin
       Closehandle(filehandledest);
        Closehandle(filehandlesrc);
       Exit;
     end;

     brdest:=WriteFile(filehandledest,buf,ShouldWrite,Writesizedest,nil);
     if (brdest=false) or (ShouldWrite<>Writesizedest) then
     begin
       Closehandle(filehandledest);
        Closehandle(filehandlesrc);
       Exit;
     end;

     possrc:=possrc+BUFSIZE;
     tempDestPos:=tempDestPos+BUFSIZE;

   end;
////////////////////////////////////////////////////////////////
  Closehandle(filehandlesrc);
  Closehandle(filehandledest);
  result:=true;

end;

procedure TBAKthread.Execute;
var i:integer;
    tmpname,targetname:string;
    ret:BOOL;
    listindex:integer;
    Firsttime:DWORD;
begin
   Firsttime:=GetTickCount;
   listindex:=0;
   FPRi_BAK.allnumber:=0;
   FPRi_BAK.oknumber:=0;
   FPRi_BAK.failnumber:=0;
   targetname:=FTargetFile;
   for I := 0 to FSourceFiles.Count - 1 do
   begin
     if Terminated  then break;
     inc(FPRi_BAK.allnumber);
     listindex:=i;
     tmpname:=FSourceFiles[i];
     FPRi_BAK.nowfile:=tmpname;
     ret:=BAKaFileStreamFast(Pchar(FSourceFiles[i]),Pchar(targetname));  //强行覆盖
     if ret=true then
     begin
       inc(FPRi_BAK.oknumber);
       SendMessage(Fhandle,WM_NSE_BAK_OK,listindex,0);
     end else
     begin
        inc(FPRi_BAK.failnumber);
        SendMessage(Fhandle,WM_NSE_BAK_Fail,listindex,0);
     end;
     FPRi_BAK.period:=GettickCount-Firsttime;
   end;
    TBAKThreadRunning:=false;
    SendMessage(Fhandle,WM_NSE_BAK_END,listindex,0);
end;



//////////////////////////////////////////////////////////////////
///  RESTOREthread/////////////////////////////////////





constructor TRESTOREThread.Create(aFhandle:THandle;
       aFSourceFile:string;
       aFFiles:Tstringlist;
       aFOverwrite:BOOL;///覆盖
       aFPRI_RESTORE:PRetinfo_RESTORE);
begin
   inherited Create(true);
   FreeOnTerminate:=True;
  Fhandle:=aFhandle;
  FSourceFile:=aFSourceFile;
  FFiles:=aFFiles;
  FOverwrite:=aFOverwrite;
  FPRI_RESTORE:=aFPRI_RESTORE;
end;


function RestoreAFileStreamFast(Sourcename:string;beginpos:DWORD;bOverwrite:BOOL;var nowpos:DWORD;var nowname:string):BOOL;
var filehandleSrc,filehandleDest:THandle;
    filesizeSrc,filesizeDest:DWORD;
    brSrc,brDest:BOOL;
    posSrc,posDest:DWORD;
    tempSrcPos,tempDestPos:DWORD;
    Buf:array[0..BUFSIZE-1]of byte;
    strbuf:array[0..CharBUFSize-1]of char;
    readsizeSrc,WritesizeDest:ULONG;
    FileOpenMode:DWORD;
    targetname:string;
    ShouldRead:DWORD;
begin
   Result:=false;
   ///////////////////////////////////////////////////////////////////////
  filehandlesrc:=CreateFile(pchar(Sourcename),
                      GENERIC_READ,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil,
                      OPEN_EXISTING,
                      0,
                      0);
  if (filehandlesrc=INVALID_HANDLE_VALUE) then
  begin
    Exit;
  end;


  filesizesrc:=GetFileSize(filehandlesrc,nil);
  if INVALID_FILE_SIZE=filesizesrc then
  begin
     Closehandle(filehandlesrc);
     Exit;
  end;

  if beginpos>filesizesrc then
  begin
     Closehandle(filehandlesrc);
     Exit;
  end;

/////////////////////////////////////////////////////////////
   posSrc:=SetFilePointer(filehandlesrc,beginpos,nil,FILE_BEGIN);
   if possrc=INVALID_SET_FILE_POINTER then
   begin
       Closehandle(filehandlesrc);
       Exit;
   end;
////////////check source file///////////////////////////////////////////////////////////////
  ///head check

     Zeromemory(@strbuf,CharBUFSize);
     brSrc:=ReadFile(filehandlesrc,strbuf,MYHEADSize,readsizesrc,nil);
     if (brsrc=false)or(readsizesrc<>MYHEADSize) or (strbuf<>MYHEAD)then
     begin
     Closehandle(filehandlesrc);
     Exit;
     end;




   ///name check
     Zeromemory(@strbuf,CharBUFSize);
     brsrc:=ReadFile(filehandlesrc,strbuf,MYMAX_PATHSIZE,readsizesrc,nil);
     if (brsrc=false)or(readsizesrc<>MYMAX_PATHSIZE) then
     begin
       Closehandle(filehandlesrc);
       Exit;
     end;
     targetname:=strbuf;
     nowname:=targetname;

  // sizecheck
    brsrc:=ReadFile(filehandlesrc,filesizeDest,Sizeof(filesizeDest),readsizesrc,nil);
    if (brsrc=false)or(readsizesrc<>Sizeof(filesizeDest)) then
    begin
     Closehandle(filehandlesrc);
     Exit;
    end;
/////////////check file end //////////////////////////
///
      tempSrcPos:=beginpos+MYHEADSIZE+MYMAX_PATHSIZE+Sizeof(filesizeDest);
////////////////////////////////////////

 if bOverwrite then FileOpenMode:=OPEN_ALWAYS else FileOpenMode:=CREATE_NEW;
//////////////////////////////////////////////
   filehandledest:=CreateFile(Pchar(targetname),
                      GENERIC_WRITE,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil,
                      FileOpenMode,
                      FILE_ATTRIBUTE_NORMAL,
                      0);
  if (filehandledest=INVALID_HANDLE_VALUE) then
  begin
     Closehandle(filehandlesrc);
     nowpos:=tempSrcPos+filesizeDest;    ///不允许覆盖失败后重新定位
     Exit;
  end;

    posdest:=0;
    posdest:=SetFilePointer(filehandledest,posdest,nil,FILE_BEGIN);
   if posdest=INVALID_SET_FILE_POINTER then
    begin
     Closehandle(filehandleSrc);
     Closehandle(filehandledest);
     Exit;
    end;

/////////////还原一个文件////////////////////////////////////////////
   tempDestPos:=0;  //当前文件相对
   posdest:=0;
   while(tempDestPos<filesizeDest) do
   begin
    ///////读/////////////////
    possrc:=tempSrcPos+tempDestPos;
    possrc:=SetFilePointer(filehandlesrc,possrc,nil,FILE_BEGIN);
     if possrc=INVALID_SET_FILE_POINTER then
     begin
     Closehandle(filehandleSrc);
     Closehandle(filehandledest);
     Exit;
     end;
     Zeromemory(@buf,BUFSIZE);
     ShouldRead:=filesizeDest-tempDestPos;
     if (ShouldRead>BUFSIZE) then ShouldRead:=BUFSIZE;
     brsrc:=ReadFile(filehandlesrc,Buf,ShouldRead,readsizesrc,nil);

      if (brsrc=false)or (ShouldRead<>readsizesrc)  then
      begin
        Closehandle(filehandleSrc);
        Closehandle(filehandledest);
        Exit;
      end;
      //////写
      posdest:=SetFilePointer(filehandledest,posdest,nil,FILE_BEGIN);
      if posdest=INVALID_SET_FILE_POINTER then
      begin
        Closehandle(filehandleSrc);
        Closehandle(filehandledest);
        Exit;
      end;

      brdest:=WriteFile(filehandledest,buf,ShouldRead,Writesizedest,nil);
      if (brdest=false) or (ShouldRead<>Writesizedest) then
      begin
        Closehandle(filehandleSrc);
        Closehandle(filehandledest);
        Exit;
      end;

     posdest:=posdest+ShouldRead;
     tempDestPos:=tempDestPos+ShouldRead;
   end;   ////一个文件还原完毕

    Closehandle(filehandledest);
    Closehandle(filehandlesrc);
    nowpos:=tempSrcPos+filesizeDest;
    Result:=true;
end;




procedure TRESTOREthread.Execute;
var  listindex:integer;
    Firsttime:DWORD;

    filehandlesrc:THandle;
    filesizesrc:DWORD;
    tempPos,tempnowpos:DWORD;
    tempname:string;
    br:BOOL;
begin
   Firsttime:=GetTickCount;
   FPRi_RESTORE.allnumber:=0;
   listindex:=0;
   FPRi_RESTORE.oknumber:=0;
   FPRi_RESTORE.failnumber:=0;

///////////////////////////////////////////////////////////////////////
  filehandlesrc:=CreateFile(pchar(FSourceFile),
                      GENERIC_READ,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil,
                      OPEN_EXISTING,
                      0,
                      0);
  if (filehandlesrc=INVALID_HANDLE_VALUE) then
  begin
    TRESTOREThreadRunning:=false;
    SendMessage(Fhandle,WM_NSE_RESTORE_END,listindex,0);
    Exit;
  end;
    filesizesrc:=GetFileSize(filehandlesrc,nil);
    Closehandle(filehandlesrc);
   if INVALID_FILE_SIZE=filesizesrc then
   begin
     TRESTOREThreadRunning:=false;
     SendMessage(Fhandle,WM_NSE_RESTORE_END,listindex,0);
     Exit;
   end;


   tempPos:=0;
   while temppos<filesizesrc do
   begin       ///while
    if Terminated then break;
    inc(FPRi_RESTORE.allnumber);
     br:=RestoreAFileStreamFast(FSourceFile,temppos,FOverwrite,tempnowpos,tempname);
     FPRi_RESTORE.nowfile:=tempname;
     FFiles.Add(tempname);
     listindex:=FPRi_RESTORE.allnumber-1;
    if br=true then
     begin
       inc(FPRi_RESTORE.oknumber);
       SendMessage(Fhandle,WM_NSE_RESTORE_OK,listindex,0);
     end else
     begin
        inc(FPRi_RESTORE.failnumber);
        SendMessage(Fhandle,WM_NSE_RESTORE_Fail,listindex,0);
     end;
     temppos:=tempnowpos;
     FPRi_RESTORE.period:=GettickCount-Firsttime;
   end;
    TRESTOREThreadRunning:=false;
    SendMessage(Fhandle,WM_NSE_RESTORE_END,listindex,0);
end;


 function GetRestoreFileAllName(srcfile:string;listfile:TList):bool;
var filehandleSrc:THandle;
    filesizeSrc,filesizeDest:DWORD;
    brSrc:BOOL;
    posSrc:DWORD;
    tempSrcPos:DWORD;
    strbuf:array[0..CharBUFSize-1]of char;
    readsizeSrc:ULONG;
    Prfi:PRestoreFileInfo;
begin
   Result:=false;
   ///////////////////////////////////////////////////////////////////////
  filehandlesrc:=CreateFile(pchar(srcfile),
                      GENERIC_READ,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil,
                      OPEN_EXISTING,
                      0,
                      0);
  if (filehandlesrc=INVALID_HANDLE_VALUE) then
  begin
    Exit;
  end;


  filesizesrc:=GetFileSize(filehandlesrc,nil);
  if INVALID_FILE_SIZE=filesizesrc then
  begin
     Closehandle(filehandlesrc);
     Exit;
  end;
   tempSrcPos:=0;

/////////////////////////////////////////////////////////////
  while tempSrcPos<filesizesrc do
  begin
   posSrc:=SetFilePointer(filehandlesrc,tempSrcPos,nil,FILE_BEGIN);
   if possrc=INVALID_SET_FILE_POINTER then
   begin
       Closehandle(filehandlesrc);
       Exit;
   end;
////////////check source file///////////////////////////////////////////////////////////////
  ///head check

     Zeromemory(@strbuf,CharBUFSize);
     brSrc:=ReadFile(filehandlesrc,strbuf,MYHEADSize,readsizesrc,nil);
     if (brsrc=false)or(readsizesrc<>MYHEADSize) or (strbuf<>MYHEAD)then
     begin
     Closehandle(filehandlesrc);
     Exit;
     end;

     New(Prfi);

   ///name check
     Zeromemory(@strbuf,CharBUFSize);
     brsrc:=ReadFile(filehandlesrc,strbuf,MYMAX_PATHSIZE,readsizesrc,nil);
     if (brsrc=false)or(readsizesrc<>MYMAX_PATHSIZE) then
     begin
       Closehandle(filehandlesrc);
       Exit;
     end;

     Prfi.filename:=strbuf;

  // sizecheck
    brsrc:=ReadFile(filehandlesrc,filesizeDest,Sizeof(filesizeDest),readsizesrc,nil);
    if (brsrc=false)or(readsizesrc<>Sizeof(filesizeDest)) then
    begin
     Closehandle(filehandlesrc);
     Exit;
    end;

    Prfi.filesize:=filesizeDest;
/////////////check file end //////////////////////////
    listfile.Add(Prfi);
    tempSrcPos:=tempSrcPos+MYHEADSIZE+MYMAX_PATHSIZE+Sizeof(filesizeDest)+filesizeDest;
////////////////////////////////////////
  end;////while end
   Closehandle(filehandlesrc);
   Result:=true;
end;

///////////////////////////////////////////////////////////////////////////////////////////////////
///
function RegUrlProtocol(aProtocolName,
  aProtocolApplicationName: string; aUseParam: Boolean): Boolean;
var
  objReg: TRegistry;
begin
  Result := False;
  objReg := TRegistry.Create;
  try
    objReg.RootKey := HKEY_CLASSES_ROOT;
    if objReg.OpenKey('\' + aProtocolName, True) then
    begin
      objReg.WriteString('', aProtocolName + 'Protocol');
      objReg.WriteString('URL Protocol', aProtocolApplicationName);
      if objReg.OpenKey('\' + aProtocolName + '\DefaultIcon', True) then
      begin
        objReg.WriteString('', aProtocolApplicationName + ',1');
      end;
      if objReg.OpenKey('\' + aProtocolName + '\shell\open\command', True) then
      begin
        if aUseParam then
          objReg.WriteString('', '"' + aProtocolApplicationName + '" "%1"')
        else
          objReg.WriteString('', '"' + aProtocolApplicationName + '"');
      end;
      Result := True;
    end;
  finally
    FreeAndNil(objReg);
  end;
end;

function UnRegUrlProtocl(aProtocolName: string): Boolean;
var
  objReg: TRegistry;
begin
  Result := False;
  objReg := TRegistry.Create;
  try
    objReg.RootKey := HKEY_CLASSES_ROOT;
    objReg.DeleteKey(aProtocolName);
    Result := True;
  finally
    FreeAndNil(objReg);
  end;
end;

procedure RegisterFileType(cMyExt,cMyFileType,cMyDescription,ExeName:string;
                          IcoIndex:integer;
                          DoUpdate:boolean=false);
var
  Reg: TRegistry;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_CLASSES_ROOT;
    Reg.OpenKey(cMyExt, True);
    //写入自定义文件后缀
    Reg.WriteString('', cMyFileType);
    Reg.CloseKey;
    //写入自定义的文件类型
    //格式为：HKEY_CLASSES_ROOT\cMyExt\(Default) = 'cMyFileType'

    //下面为该文件类型创建关联
    Reg.OpenKey(cMyFileType, True);
    Reg.WriteString('', cMyDescription);
    //写入文件类型的描述信息
    Reg.CloseKey;

    // 下面为自定义文件类型选择图标
    // 加入键格式为 HKEY_CLASSES_ROOT\cMyFileType\DefaultIcon
    //  \(Default) = 'Application Dir\Project1.exe,0'
    Reg.OpenKey(cMyFileType + '\DefaultIcon', True);
    Reg.WriteString('', ExeName + ',' + IntToStr(IcoIndex));
    Reg.CloseKey;

    // 下面注册在资源管理器中打开文件的程序
    Reg.OpenKey(cMyFileType + '\Shell\Open', True);
    Reg.WriteString('', '&Open');
    Reg.CloseKey;

    //  格式：HKEY_CLASSES_ROOT\Project1.FileType\Shell\Open\Command
    //  (Default) = '"Application Dir\Project1.exe" "%1"'
    Reg.OpenKey(cMyFileType + '\Shell\Open\Command', True);
    Reg.WriteString('', '"' + ExeName + '" "%1"');
    Reg.CloseKey;

    //最后，让资源管理器实现我们加入的文件类型，只需调用SHChangeNotify即可
    if DoUpdate then SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
  finally
    Reg.Free;
  end;
end;

initialization
   EnableKernel;
finalization

end.

