object FormLogin: TFormLogin
  Left = 0
  Top = 0
  Caption = 'FormLogin'
  ClientHeight = 229
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object IdBox: TEdit
    Left = 120
    Top = 88
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object PasswordBox: TEdit
    Left = 120
    Top = 128
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object ID: TStaticText
    Left = 80
    Top = 92
    Width = 15
    Height = 17
    Caption = 'ID'
    TabOrder = 2
  end
  object Password: TStaticText
    Left = 64
    Top = 132
    Width = 50
    Height = 17
    Caption = 'Password'
    TabOrder = 3
  end
  object LoginButton: TButton
    Left = 256
    Top = 88
    Width = 73
    Height = 61
    Caption = 'Login'
    TabOrder = 4
    OnClick = LoginButtonClick
  end
  object TCancelButton: TButton
    Left = 309
    Top = 8
    Width = 75
    Height = 25
    Caption = 'CANCLE'
    TabOrder = 5
    OnClick = TCancelButtonClick
  end
  object SQLConnection: TSQLConnection
    Left = 336
    Top = 176
  end
end
