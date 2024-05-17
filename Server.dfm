object FormServer: TFormServer
  Left = 0
  Top = 0
  Caption = 'TCPserver'
  ClientHeight = 416
  ClientWidth = 656
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
  object lbl1: TLabel
    Left = 40
    Top = 5
    Width = 68
    Height = 13
    Caption = 'Server Port:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 40
    Top = 58
    Width = 47
    Height = 13
    Caption = #47700#49884#51648' '#52285
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl3: TLabel
    Left = 368
    Top = 58
    Width = 91
    Height = 13
    Caption = #53364#46972#51060#50616#53944' '#51217#49549#51088
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object DisableBtn: TButton
    Left = 265
    Top = 24
    Width = 75
    Height = 25
    Caption = #49436#48260' '#45803#44592
    TabOrder = 0
    OnClick = DisableBtnClick
  end
  object PortNumber: TEdit
    Left = 40
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '8080'
  end
  object EnableBtn: TButton
    Left = 183
    Top = 23
    Width = 75
    Height = 25
    Caption = #49436#48260' '#50676#44592
    TabOrder = 2
    OnClick = EnableBtnClick
  end
  object KillClientButton: TButton
    Left = 368
    Top = 24
    Width = 169
    Height = 25
    Caption = #44053#53748#54616#44592
    Enabled = False
    TabOrder = 3
    OnClick = KillClientButtonClick
  end
  object ClientList: TListBox
    Left = 368
    Top = 77
    Width = 169
    Height = 284
    ItemHeight = 13
    TabOrder = 4
  end
  object MsgMemo: TMemo
    Left = 40
    Top = 77
    Width = 300
    Height = 284
    Color = clCream
    ReadOnly = True
    TabOrder = 5
  end
  object MessageBox: TEdit
    Left = 40
    Top = 375
    Width = 497
    Height = 21
    TabOrder = 6
    Text = #47700#49464#51648#47484' '#51077#47141#54644#51452#49464#50836
  end
  object SendMsgButton: TButton
    Left = 543
    Top = 292
    Width = 103
    Height = 52
    Caption = #44060#51064' '#53665
    Enabled = False
    TabOrder = 7
    OnClick = SendMsgButtonClick
  end
  object AllSendButton: TButton
    Left = 543
    Top = 344
    Width = 103
    Height = 52
    Caption = #51204#52404' '#53665
    Enabled = False
    TabOrder = 8
    OnClick = AllSendButtonClick
  end
  object ClientsNumBtn: TButton
    Left = 543
    Top = 106
    Width = 103
    Height = 49
    Caption = #51217#49549#51088' '#49688' '#48320#44221
    TabOrder = 9
    OnClick = ClientsNumBtnClick
  end
  object ClientsChangeEdit: TEdit
    Left = 543
    Top = 79
    Width = 103
    Height = 21
    TabOrder = 10
    Text = '50'
  end
  object NumClients: TStaticText
    Left = 543
    Top = 27
    Width = 76
    Height = 17
    Caption = #51217#49549' '#44032#45733#51088' '#49688
    TabOrder = 11
  end
  object NumClientsText: TStaticText
    Left = 628
    Top = 26
    Width = 16
    Height = 17
    Caption = '50'
    TabOrder = 12
  end
  object SearchDataButton: TButton
    Left = 543
    Top = 241
    Width = 103
    Height = 52
    Caption = #45936#51060#53552' '#44160#49353
    TabOrder = 13
    OnClick = SearchDataButtonClick
  end
  object ChartButton: TButton
    Left = 543
    Top = 190
    Width = 103
    Height = 52
    Caption = #52264#53944
    TabOrder = 14
    OnClick = ChartButtonClick
  end
  object TCP: TIdTCPServer
    Bindings = <>
    DefaultPort = 9999
    OnConnect = TCPConnect
    OnDisconnect = TCPDisconnect
    OnExecute = TCPExecute
    Left = 424
    Top = 304
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 480
    Top = 304
  end
  object SQLConnection: TSQLConnection
    LibraryName = 'dbxmys.dll'
    VendorLib = 'libmysql.dll'
    Left = 424
    Top = 256
  end
end
