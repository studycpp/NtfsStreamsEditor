object FastViewForm: TFastViewForm
  Left = 0
  Top = 0
  Caption = 'FastViewForm'
  ClientHeight = 429
  ClientWidth = 654
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 209
    Width = 654
    Height = 8
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 305
    ExplicitWidth = 641
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 654
    Height = 209
    Align = alTop
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    OnKeyPress = Memo1KeyPress
    ExplicitTop = 2
  end
  object Memo2: TMemo
    Left = 0
    Top = 217
    Width = 654
    Height = 212
    Align = alClient
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo2')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    OnKeyPress = Memo2KeyPress
  end
end
