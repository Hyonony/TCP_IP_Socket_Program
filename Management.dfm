object FormManagement: TFormManagement
  Left = 0
  Top = 0
  Caption = 'FormManagement'
  ClientHeight = 389
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ClientsLabel: TLabel
    Left = 23
    Top = 33
    Width = 91
    Height = 13
    Caption = #53364#46972#51060#50616#53944' '#51217#49549#51088
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ClientList: TListBox
    Left = 23
    Top = 60
    Width = 434
    Height = 125
    Style = lbOwnerDrawFixed
    ItemHeight = 13
    TabOrder = 0
  end
end
