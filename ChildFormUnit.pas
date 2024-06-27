{
Copyright ?1999 by Delphi 5 Developer's Guide - Xavier Pacheco and Steve Teixeira
}

unit ChildFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,Menus;

type

  TChildForm = class(TForm)
  private
    FAsChild: Boolean;
    FTempParent: TWinControl;
  protected
   // constructor Create(AOwner: TComponent); overload;// override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent; AParent: TWinControl); reintroduce; overload;
    function CanChange: Boolean; virtual;
  end;

var
  ChildForm: TChildForm;

implementation

{$R *.DFM}
  {
constructor TChildForm.Create(AOwner: TComponent);
begin
  FAsChild := False;
  inherited Create(AOwner);
end;   }

constructor TChildForm.Create(AOwner: TComponent; AParent: TWinControl);
begin
  FAsChild := True;
  FTempParent := aParent;
  inherited Create(AOwner);
end;

procedure TChildForm.Loaded;
begin
  inherited;
  if FAsChild then
  begin
    align := alClient;
    BorderStyle := bsNone;
    BorderIcons := [];
    Parent := FTempParent;
    Position := poDefault;
  end;

end;

procedure TChildForm.CreateParams(var Params: TCreateParams);
Begin
  Inherited CreateParams(Params);
  if FAsChild then
    Params.Style := Params.Style or WS_CHILD;
end;


function TChildForm.CanChange: Boolean;
begin
  Result := True;
end;

end.
