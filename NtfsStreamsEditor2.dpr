program NtfsStreamsEditor2;


{$R *.dres}

uses
  Forms,
  NSEKernel in 'NSEKernel.pas',
  MainUnit in 'MainUnit.pas' {MainForm},
  ScanUnit in 'ScanUnit.pas' {ScanForm},
  ChildFormUnit in 'ChildFormUnit.pas' {ChildForm},
  EditUnit in 'EditUnit.pas' {EditForm},
  RecordUnit in 'RecordUnit.pas' {RecordForm},
  aboutUnit in 'aboutUnit.pas' {AboutForm},
  DElUnit in 'DElUnit.pas' {DEL_Form},
  ExpUnit in 'ExpUnit.pas' {EXP_Form},
  AddUnit in 'AddUnit.pas' {Add_Form},
  BAKUnit in 'BAKUnit.pas' {Bak_Form},
  RestoreUnit in 'RestoreUnit.pas' {Restore_Form},
  FastViewUnit in 'FastViewUnit.pas' {FastViewForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Ntfs数据流处理 NtfsStreamsEditor 2';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFastViewForm, FastViewForm);
  Application.Run;
end.
