object Add_Form: TAdd_Form
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #38468#21152'+/'#23548#20837'<-'
  ClientHeight = 425
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 17
    Top = 12
    Width = 104
    Height = 13
    Caption = #38468#21152'/'#23548#20837#30340#28304#25991#20214':'
  end
  object Label3: TLabel
    Left = 440
    Top = 12
    Width = 64
    Height = 13
    Caption = #25968#25454#27969#21517#31216':'
  end
  object Label4: TLabel
    Left = 17
    Top = 61
    Width = 402
    Height = 13
    Caption = #28304#25991#20214#21644#25968#25454#27969#30340#21517#31216#19981#33021#21253#21547'  \ / : * ? " < > |        '#20294#21487#20197#26377#9678' '#20013#25991' $data '#31561
  end
  object ADD_LB: TListBox
    Left = 17
    Top = 92
    Width = 550
    Height = 270
    Color = clBtnFace
    DoubleBuffered = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 16
    ParentDoubleBuffered = False
    ParentFont = False
    ScrollWidth = 800
    TabOrder = 5
  end
  object Add_src_EB: TButtonedEdit
    Left = 17
    Top = 31
    Width = 400
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Images = ImageList1
    ParentFont = False
    ReadOnly = True
    RightButton.HotImageIndex = 1
    RightButton.ImageIndex = 0
    RightButton.PressedImageIndex = 2
    RightButton.Visible = True
    TabOrder = 0
    Text = #36873#25321#36755#20837#30340#28304#25991#20214
    OnChange = Add_Opt_Change
    OnKeyPress = Add_src_EBKeyPress
    OnRightButtonClick = Add_src_EBRightButtonClick
  end
  object Button1: TButton
    Left = 70
    Top = 380
    Width = 75
    Height = 25
    Caption = #30830#23450
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 441
    Top = 380
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 4
  end
  object Add_name_Edit: TEdit
    Left = 440
    Top = 31
    Width = 129
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = #36755#20837#25968#25454#27969#21517#31216
    OnChange = Add_Opt_Change
  end
  object Add_ReWrite_CB: TCheckBox
    Left = 441
    Top = 61
    Width = 145
    Height = 17
    Caption = #35206#30422#24050#26377#21516#21517#25968#25454#27969#65311
    TabOrder = 2
    OnClick = Add_ReWrite_CBClick
  end
  object ImageList1: TImageList
    Height = 20
    Width = 20
    Left = 192
    Top = 144
    Bitmap = {
      494C010103000800040014001400FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000500000001400000001002000000000000019
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FAF5F20EEDD7CC37E2AD
      88A7E3C9C63B0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F7F7F708DFDFDF20DFDFDF20DFDFDF20DFDF
      DF20DFDFDF20DFDFDF20DFDFDF20DFDFDF20DFDFDF20DFDFDF20DFDFDF20DFDF
      DF20E7E7E718000000000000000000000000000000000000000000000000F0F0
      F00FD4D4D42BD4D4D42BD4D4D42BD4D4D42BD4D4D42BD4D4D42BD4D4D42BD4D4
      D42BD4D4D42BD4D4D42BD4D4D42BD3D3D32CD4D4D42B00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FEFEFD02ECD2C46AEBB88CDEF7CBA7E6F5CDB1D1F4CBAED5F3C5
      A3EBCD7E4AF9E1A984EEE6CCC43E000000000000000000000000000000000000
      0000000000000000000000000000D6D6D6FFF9FAFAFFF9FAFAFFF9F9F9FFF8F9
      F9FFF8F9F9FFF8F8F8FFF8F8F8FFF7F8F8FFF6F7F7FFF6F7F7FFF6F7F7FFF6F7
      F7FF9F9F9F600000000000000000000000000000000000000000D5D5D5FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB5B5B54A00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FDFC
      FB07EDCEB796E7BC9CCFF9CDA7E9F6CEB1D3F3C9AADEF2C4A2F3F3C3A0FAF3C3
      A1F9CD7F4FF2E2AB90D8CC9172C8DCBAAF550000000000000000000000000000
      0000000000000000000000000000D6D6D6FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FF9F9F9F600000000000000000000000000000000000000000D5D5D5FFF4F4
      F4FFF9F9F9FFF7F9F9FFF8F9F9FFF6F8F8FFF6F8F8FFF6F8F8FFF6F8F8FFF5F6
      F6FFF5F6F6FFF5F6F6FFF5F6F6FFFBFAFAFFB7B7B74800000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F1DDD642FAD3B4D7F7D0
      B4CAF4C8A8E9F4C5A4F3F4C5A2FAF5C6A4F5F4C5A4F6F4C3A2FBF4C4A1FDF4C3
      A0FECC7D4DFCE2A889F3CF865EDBDAAD97DBCA8B759DF7F7F70B000000000000
      0000000000000000000000000000D6D6D6FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FF9F9F9F600000000000000000000000000000000000000000D6D6D6FFF5F6
      F6FFF9FAFAFFF9F9F9FFF8F9F9FFF8F9F9FFF8F8F8FFF7F8F8FFF7F8F8FFF7F8
      F8FFF7F7F7FFF6F7F7FFF6F7F7FFFBFCFCFFB6B6B64900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EAC1ADFBFCDABFBBF4C8
      A8F1F6C7A6F2F6C6A4F8F6C5A3FEF6C5A3FDF6C5A3FCF5C5A3FCF5C5A3FCF5C4
      A2FCCB804FFCE5AB8BF3CE8760DBDBAC97D4CC8263C7EAEAEA1EEAEAEA1EFCFC
      FC03000000000000000000000000D6D6D6FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FF9F9F9F600000000000000000000000000000000000000000D6D6D6FFF6F6
      F6FFFAFAFAFFF9FAFAFFF9FAFAFFF8F9F9FFF8F9F9FFF8F9F9FFF8F8F8FFF7F8
      F8FFF7F8F8FFF7F7F7FFF6F7F7FFFBFCFCFFB6B6B64900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EBC3ADFDFCD9BEBCF5C9
      A8F1F6C8A6F5F6C6A4FEF6C6A4FCF6C6A4FCF6C6A4FCF6C6A4FCF5C5A3FCF5C4
      A2FCCC8150FCE6AC8CF3CE8760DBDBAD99D3CB7D5ECAF0F0F015F2F2F212F8F8
      F809000000000000000000000000D6D6D6FFFBFBFBFFFAFBFBFFFAFBFBFFFAFA
      FAFFFAFAFAFFF9FAFAFFF9FAFAFFF9F9F9FFF8F8F8FFF7F8F8FFF7F8F8FFF7F8
      F8FF9F9F9F600000000000000000000000000000000000000000D6D6D6FFF6F6
      F6FFFAFAFAFFFAFAFAFFF9FAFAFFF9F9F9FFF8F9F9FFF8F9F9FFF8F9F9FFF8F8
      F8FFF7F8F8FFF7F8F8FFF7F7F7FFFBFCFCFFB6B6B64900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EAC3AEFEFBD9BDBEF5C8
      A8F3F7C8A7F6F7C6A4FEF7C7A5FCF7C7A5FCF7C6A5FCF7C7A5FCF6C6A5FCF6C5
      A4FCCE8655FCE9B090F2D08B64DBDDAF9AD3C47756CD00000000000000000000
      0000000000000000000000000000D6D6D6FFFBFBFBFFFBFBFBFFFBFBFBFFFAFB
      FBFFFAFAFAFFFAFAFAFFF9FAFAFFF9FAFAFFF8F9F9FFF8F9F9FFF8F8F8FFF7F8
      F8FF9F9F9F600000000000000000000000000000000000000000D6D6D6FFF6F6
      F6FFFAFBFBFFFAFBFBFFFAFAFAFFF9FAFAFFF9FAFAFFF9F9F9FFF9F9F9FFF8F9
      F9FFF8F9F9FFF7F8F8FFF7F8F8FFFCFDFDFFB6B6B64900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EAC3AEFEFBD8BDBEF6C9
      A9F3F7C8A7F6F7C7A5FEF7C7A6FCF7C7A6FCF7C7A6FCF7C7A5FCF7C7A5FCF6C6
      A4FCD08757FBEAB292F1D38C66DBDEB29DD2C67A57D000000000000000000000
      0000000000000000000000000000D6D6D6FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FF9F9F9F600000000000000000000000000000000000000000D6D6D6FFF6F6
      F6FFFBFBFBFFFBFBFBFFFAFBFBFFFAFAFAFFF9FAFAFFF9FAFAFFF9F9F9FFF8F9
      F9FFF8F9F9FFF8F8F8FFF7F8F8FFFCFDFDFFB6B6B64900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ECC5B1FDFBD7BCC0F6C9
      A8F5F8C9A7F7F8C8A6FEF8C9A7FBF8C8A7FBF8C8A7FBF8C8A7FBF7C8A7FBF7C7
      A6FBD18A5BFBECB697F0D4926AD9E0B59ED0C97B57D300000000000000000000
      0000000000000000000000000000D6D6D6FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FF9F9F9F600000000000000000000000000000000000000000D6D6D6FFF6F7
      F7FFFBFBFBFFFBFBFBFFFBFBFBFFFAFAFAFFFAFAFAFFF9FAFAFFF9FAFAFFF9F9
      F9FFF9F9F9FFF8F9F9FFF8F8F8FFFDFDFDFFB6B6B64900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EDC6B1FDFAD6BBC1F6C8
      A8F6F8C9A8F7F8C9A7FEF8CAA8FBF8CAA8FBF8CAA8FBF8CAA8FBF8CAA8FBF8C9
      A7FBD38E5EFBEFBA9AF0D8966DD9E3BBA6CECB7D59D200000000000000000000
      0000000000000000000000000000D6D6D6FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FF9F9F9F600000000000000000000000000000000000000000D6D6D6FFF7F7
      F7FFFCFCFCFFFBFCFCFFFBFBFBFFFBFBFBFFFAFBFBFFFAFAFAFFFAFAFAFFF9FA
      FAFFF9FAFAFFF9F9F9FFF8F9F9FFFDFEFEFFB6B6B64900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EEC7B2FDFAD6BAC0F6C9
      A9F6F8CAA8F7F8CAA7FDF8CAA8FBF8CAA8FBF8CAA8FBF8CAA9FBF8CAA9FBF8C9
      A7FBD48F5FFBF0BC9DF0D8976ED9E5BDA8CDCD815ED200000000000000000000
      0000000000000000000000000000D6D6D6FFFCFDFDFFFCFCFCFFFCFCFCFFFCFC
      FCFFFBFCFCFFFBFBFBFFFBFBFBFFFAFBFBFFFAFAFAFFF9FAFAFFF9FAFAFFF9F9
      F9FF9F9F9F600000000000000000000000000000000000000000D6D6D6FFF7F7
      F7FFFCFCFCFFFCFCFCFFFBFCFCFFFBFBFBFFFBFBFBFFFAFBFBFFFAFAFAFFFAFA
      FAFFF9FAFAFFF9F9F9FFF8F9F9FFFDFEFEFFB6B6B64900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0CAB5FDFEEBDCDDFAD7
      BFFAF8C9A7F7F9CAA8FDF9CBA9FBF9CBAAFBF9CBAAFBF9CBAAFBF9CBAAFBF9CA
      A9FBD49160FBF2BFA0F0DA9A71D8E8C3ADC9D4906EC700000000000000000000
      0000000000000000000000000000D6D6D6FFFDFDFDFFFDFDFDFFFCFCFCFFFCFC
      FCFFFCFCFCFFFBFCFCFFFBFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF9FAFAFFF9FA
      FAFF9F9F9F600000000000000000000000000000000000000000D6D6D6FFF8F8
      F8FFFCFDFDFFFCFCFCFFFCFCFCFFFBFCFCFFFBFCFCFFFBFBFBFFFBFBFBFFFAFB
      FBFFFAFAFAFFFAFAFAFFF9FAFAFFFEFFFFFFB6B6B64900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0CBB6FDFEE9D9DBFDE3
      D0FBFBD2B5FAF9CCAAFDF9CAA8FBF9CBA9FBF9CBAAFBF9CBA9FBF9CBA9FBF9CA
      A9FBD49263FBF3C2A3EFDB9B73D8E9C5AFC7DDA487C100000000000000000000
      0000000000000000000000000000D6D6D6FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6C8FFE0D6
      C8FF9F9F9F600000000000000000000000000000000000000000D6D6D6FFF8F8
      F8FFFDFDFDFFFCFDFDFFFCFCFCFFFCFCFCFFFBFCFCFFFBFBFBFFFBFBFBFFFBFB
      FBFFFAFBFBFFFAFAFAFFF8FAFAFFFEFFFFFFB6B6B64900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F1CBB7FCFDE5D4D8FCDE
      CAFAFDE0C9FBFCE0C9FEFDDEC7FDFCDABFFCFBD8BEFBFBD8BDFCFBD8BDFCFBD7
      BBFCD5996BFAF5C6A8EFDB9F78D7ECC8B4C6DFAD91BD00000000000000000000
      0000000000000000000000000000D6D6D6FFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
      FDFFFCFDFDFFFCFCFCFFFCFCFCFFFCFCFCFFB2B2B2FFABABABFFA9A9A9FFAFAF
      AFFFC8C8C8370000000000000000000000000000000000000000D6D6D6FFF8F8
      F8FFFDFDFDFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFCFCFCFFFBFCFCFFFBFB
      FBFFFFFFFFFFFFFFFFFFD7D7D7FFCDCDCDFFBDBDBD4200000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F1CCB7FCFCE3CFD5FADB
      C5F9FCDCC5FBFCDCC4FEFCDBC2FDFCDAC0FCFBD9BDFCFBD7BBFCFBD6B9FCFBD4
      B7FBD5996BFAF6CBAEF1DEA57FD8EDCAB7C5DB9F80BB00000000000000000000
      0000000000000000000000000000D6D6D6FFFEFEFEFFFDFEFEFFFDFDFDFFFCFD
      FDFFFCFCFCFFFCFCFCFFFCFCFCFFFBFCFCFFCECECEFFFAFAFAFFCACACAFEB6B6
      B67FFCFCFC030000000000000000000000000000000000000000D6D6D6FFF9F9
      F9FFFDFDFDFFFDFDFDFFFDFDFDFFFCFDFDFFFCFCFCFFFCFCFCFFFCFCFCFFFBFC
      FCFFDADADAFFDEDEDEFFEFEFEFFFC4C4C4FFFBFBFB0400000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F1CDB8FCFBE2CFD3F9DA
      C3F9FBDBC3FBFBDBC2FEFBDAC0FDFBD8BEFCFAD7BCFCFAD6B9FCFAD5B8FCF9D3
      B4FCD39669FBF5CBAEF1DEA883D7EED1BEC5E1AF94B100000000000000000000
      0000000000000000000000000000D6D6D6FFECE9E9FFC4BFBFFFFDFDFDFFC4BF
      BFFFF2EFF0FFECE9E9FFC4BFBFFFFCFCFCFFCDCDCDFFE4E4E4FFB3B3B37FE8E8
      E817000000000000000000000000000000000000000000000000D6D6D6FFF9F9
      F9FFFDFEFEFFFDFDFDFFFDFDFDFFFDFDFDFFFCFDFDFFFCFCFCFFFCFCFCFFFCFC
      FCFFDFE0E0FFE6E6E6FFD1D1D1FFB7B7B7700000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F2D0BBFFFAE0CCD2F8D8
      C1F9FAD9C0FBFAD9BFFEF9D7BBFDF9D5B8FCF9D7BCFCFDECDFFEFDEEE2FFFDEF
      E2FFE7B191F6EDBEA2F3DBA47FD5EED3BFC3DEB196A000000000000000000000
      0000000000000000000000000000D6D6D6FFECE9E9FFC4BFBFFFFDFDFDFFC4BF
      BFFFF3F0F0FFECE9E9FFC4BFBFFFFCFCFCFFBFBFBFFFAEACACFFFBFBFB040000
      0000000000000000000000000000000000000000000000000000D6D6D6FFFEFE
      FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFD6D6D6FFC6C6C6FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F3D8C6D4FAE0CCD0F8D8
      C2F9FCEEE2FEFCEFE3FFFDF0E4FFFDF2E7FFFAEDE2FEEEC3ABFBEEC1A9F8E9BA
      9EF6F9E1D3FBF9E3D5FDF1CAB0C9EBCDB7C7F7D9C1DD00000000000000000000
      0000000000000000000000000000D6D6D6FFD6D6D6FFF6F3F3FFD6D6D6FFF6F3
      F3FFD6D6D6FFD6D6D6FFF6F3F3FFD6D6D6FFC3C1C1FFC7C7C7FF000000000000
      0000000000000000000000000000000000000000000000000000D5D5D5FFE7E7
      E7FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFEAEA
      EAFFC6C6C6FFB3B3B37000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FDECDF76F6D2
      B9EEECC1AAF6F0C7AFFCF9E4D8FDF8E3D6FFF2D7CAFFF2D1BDFFF2D0BCFEEDC3
      ABF4EFC6ADEFF8E4D7F5FAE7DAFFF9E7DBEE0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFCFA1CFEEFE1ACFCEEE5D0FCEEE7BAFEEFE641FEF7F319FEFBFA0B0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000050000000140000000100010000000000F00000000000000000000000
      000000000000000000000000FFFFFF00FF87FE0007E0007000000000F801FE00
      07C0007000000000E000FE0007C000700000000080003E0007C0007000000000
      80000E0007C000700000000080000E0007C000700000000080007E0007C00070
      0000000080007E0007C000700000000080007E0007C000700000000080007E00
      07C000700000000080007E0007C000700000000080007E0007C0007000000000
      80007E0007C000700000000080007E0007C000700000000080007E0007C00070
      0000000080007E000FC000F00000000080007E001FC003F00000000080007E00
      3FC003F000000000C000FFFFFFFFFFF000000000F01FFFFFFFFFFFF000000000
      00000000000000000000000000000000000000000000}
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.*'
    Filter = #25152#26377#25991#20214'(*.*)|*.*'
    Options = [ofFileMustExist, ofEnableSizing]
    Left = 288
    Top = 200
  end
end