object RecordForm: TRecordForm
  Left = 0
  Top = 0
  Caption = 'RecordForm'
  ClientHeight = 534
  ClientWidth = 749
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Record_LV: TListView
    Left = 0
    Top = 0
    Width = 749
    Height = 493
    Align = alClient
    Columns = <
      item
        Caption = #26102#38388
        MinWidth = 5
        Width = 150
      end
      item
        Caption = #20869#23481
        MinWidth = 5
        Width = 450
      end
      item
        Caption = #32467#26524
        MinWidth = 5
        Width = 100
      end>
    DoubleBuffered = False
    ReadOnly = True
    RowSelect = True
    ParentDoubleBuffered = False
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = Record_LVColumnClick
    OnCompare = Record_LVCompare
    ExplicitWidth = 710
    ExplicitHeight = 394
  end
  object Panel1: TPanel
    Left = 0
    Top = 493
    Width = 749
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 394
    ExplicitWidth = 710
    object Button1: TButton
      Left = 630
      Top = 6
      Width = 75
      Height = 25
      Caption = #23548#20986#35760#24405
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.html'
    FileName = 'Result.html'
    Filter = #32593#39029#25991#20214'(.html)|*.html|'#32593#39029#25991#20214'(.htm)|*.htm|'#25152#26377#25991#20214'(*.*)|*.*'
    Options = [ofOverwritePrompt, ofEnableSizing]
    Left = 280
    Top = 136
  end
end
