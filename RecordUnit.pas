unit RecordUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,ChildFormUnit, ExtCtrls;

type
  TRecordForm = class(TChildForm)
    Record_LV: TListView;
    Panel1: TPanel;
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    procedure Record_LVColumnClick(Sender: TObject; Column: TListColumn);
    procedure Record_LVCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    function SaveToHTMLFile(const FileName: string;LV:TListView; Center: Boolean): Boolean;
  end;

var
  RecordForm: TRecordForm;


  /////////////界面排序专用/////////
var  ColumnToSort:integer;
  IsAscSort:array[0..3]of boolean;

implementation

{$R *.dfm}
function TRecordForm.SaveToHTMLFile(const FileName: string; LV:TListView;Center: Boolean): Boolean;
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
      WriteLn(tfile, 'Ntfs数据流处理工具NtfsStreamsEditor处理结果：');
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

procedure TRecordForm.Button1Click(Sender: TObject);
begin
 if SaveDialog1.Execute(handle) then
  SaveToHTMLFile(SaveDialog1.FileName,Record_LV,false);

end;

procedure TRecordForm.Record_LVColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  ColumnToSort:=column.Index;
  IsAscSort[ColumnToSort]:=not IsAscSort[ColumnToSort];
  Record_LV.AlphaSort;
end;

function  CompareValue(s1,s2:integer):integer;//升序
begin
     if   s1 >s2   then   result:=1
     else   result:=0;
end;

procedure TRecordForm.Record_LVCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var ix: Integer;
begin
if (ColumnToSort = 0) then
begin
    if IsAscSort[ColumnToSort] then
     Compare:=CompareText(Item1.Caption,Item2.Caption)
     else
     Compare:=CompareText(Item2.Caption,Item1.Caption);
end;

if (ColumnToSort = 1) or (ColumnToSort = 2) then
begin
     ix := ColumnToSort - 1;
    if IsAscSort[ColumnToSort] then
     Compare:=CompareText(Item1.SubItems[ix],Item2.SubItems[ix])
     else
     Compare:=CompareText(Item2.SubItems[ix],Item1.SubItems[ix])
end;
end;

end.
