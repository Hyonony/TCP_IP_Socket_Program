object FormRegister: TFormRegister
  Left = 0
  Top = 0
  Caption = 'FormRegister'
  ClientHeight = 390
  ClientWidth = 476
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object IdLabel: TLabel
    Left = 131
    Top = 147
    Width = 21
    Height = 13
    Caption = 'ID  :'
  end
  object PasswordLabel: TLabel
    Left = 131
    Top = 187
    Width = 56
    Height = 13
    Caption = 'Password  :'
  end
  object RePasswordLabel: TLabel
    Left = 131
    Top = 227
    Width = 88
    Height = 13
    Caption = 'Check Password  :'
  end
  object ContextLabel: TLabel
    Left = 64
    Top = 64
    Width = 342
    Height = 42
    Caption = 'Welcome to Register !'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object IdRegisterEdit: TEdit
    Left = 225
    Top = 144
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object PasswordRegisterEdit: TEdit
    Left = 225
    Top = 184
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object RePasswordRegisterEdit: TEdit
    Left = 225
    Top = 224
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object RegisterButton: TButton
    Left = 177
    Top = 272
    Width = 105
    Height = 45
    Caption = #54924#50896#44032#51077
    TabOrder = 3
    OnClick = RegisterButtonClick
  end
  object SQLConnection: TSQLConnection
    Left = 376
    Top = 280
  end
end
