object FormClient: TFormClient
  Left = 0
  Top = 0
  Caption = 'FormClient'
  ClientHeight = 504
  ClientWidth = 685
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
    Left = 24
    Top = 10
    Width = 49
    Height = 13
    Caption = 'Server IP:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 111
    Top = 10
    Width = 59
    Height = 13
    Caption = 'Server Port:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl3: TLabel
    Left = 198
    Top = 10
    Width = 74
    Height = 13
    Caption = 'Your Nickname:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl4: TLabel
    Left = 25
    Top = 97
    Width = 58
    Height = 13
    Caption = #51204#52404' '#52292#54021#48169
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl5: TLabel
    Left = 408
    Top = 97
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
  object PassWordLabel: TLabel
    Left = 198
    Top = 58
    Width = 50
    Height = 13
    Caption = 'Password:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object ConnectNameLabel: TLabel
    Left = 278
    Top = 10
    Width = 3
    Height = 13
  end
  object RedIsSelf: TLabel
    Left = 592
    Top = 126
    Width = 22
    Height = 13
    Caption = #51088#49888
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentColor = False
    ParentFont = False
  end
  object GreenIsFriend: TLabel
    Left = 592
    Top = 145
    Width = 22
    Height = 13
    Caption = #52828#44396
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object DefaultIsBlack: TLabel
    Left = 592
    Top = 164
    Width = 22
    Height = 13
    Caption = #51068#48152
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object IPNumber: TEdit
    Left = 24
    Top = 29
    Width = 81
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object PortNumber: TEdit
    Left = 111
    Top = 29
    Width = 59
    Height = 21
    TabOrder = 1
    Text = '8080'
  end
  object UserName: TEdit
    Left = 196
    Top = 29
    Width = 109
    Height = 21
    TabOrder = 2
    Text = 'What is your name?'
    OnKeyPress = UserNameKeyPress
  end
  object TMsgMemo: TMemo
    Left = 25
    Top = 123
    Width = 312
    Height = 284
    Color = clCream
    ReadOnly = True
    TabOrder = 3
  end
  object TSendMsgButton: TButton
    Left = 407
    Top = 422
    Width = 82
    Height = 44
    Caption = #44060#51064' '#53665
    Enabled = False
    TabOrder = 4
    OnClick = TSendMsgButtonClick
  end
  object TMessageBox: TEdit
    Left = 25
    Top = 445
    Width = 312
    Height = 21
    TabOrder = 5
    Text = #47700#49464#51648#47484' '#51077#47141#54644#51452#49464#50836'.'
  end
  object GetClients: TButton
    Left = 407
    Top = 472
    Width = 169
    Height = 18
    Caption = #53364#46972#51060#50616#53944' '#51217#49549#51088' '#48520#47084#50724#44592
    TabOrder = 6
    OnClick = GetClientsClick
  end
  object ConnectButton: TButton
    Left = 404
    Top = 20
    Width = 85
    Height = 40
    Caption = #47196#44536#51064
    TabOrder = 7
    OnClick = ConnectButtonClick
  end
  object DisconnectButton: TButton
    Left = 495
    Top = 20
    Width = 85
    Height = 40
    Caption = #47196#44536#50500#50883
    TabOrder = 8
    OnClick = DisconnectButtonClick
  end
  object ClientList: TListBox
    Left = 408
    Top = 123
    Width = 178
    Height = 284
    Style = lbOwnerDrawFixed
    ItemHeight = 13
    TabOrder = 9
    OnDrawItem = ClientListDrawItem
  end
  object AllSendButton: TButton
    Left = 495
    Top = 422
    Width = 82
    Height = 44
    Caption = #51204#52404' '#53665
    TabOrder = 10
    OnClick = AllSendButtonClick
  end
  object ConnectState: TStaticText
    Left = 586
    Top = 20
    Width = 73
    Height = 17
    Caption = 'Connect State'
    TabOrder = 11
  end
  object ConnectText: TStaticText
    Left = 586
    Top = 43
    Width = 84
    Height = 17
    BorderStyle = sbsSingle
    Caption = '   Disconnect   '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
  end
  object TPasswordBox: TEdit
    Left = 196
    Top = 77
    Width = 109
    Height = 21
    PasswordChar = '*'
    TabOrder = 13
  end
  object FriendButton: TButton
    Left = 589
    Top = 202
    Width = 88
    Height = 33
    Caption = #52828#44396' '#52628#44032
    TabOrder = 14
    OnClick = FriendButtonClick
  end
  object RegisterButton: TButton
    Left = 589
    Top = 338
    Width = 88
    Height = 33
    Caption = #54924' '#50896' '#44032' '#51077
    TabOrder = 15
    OnClick = RegisterButtonClick
  end
  object WithdrawButton: TButton
    Left = 589
    Top = 374
    Width = 88
    Height = 33
    Caption = #54924' '#50896' '#53448' '#53748
    TabOrder = 16
    OnClick = WithdrawButtonClick
  end
  object SearchDataButton: TButton
    Left = 589
    Top = 299
    Width = 88
    Height = 33
    Caption = #45936#51060#53552' '#44160#49353
    TabOrder = 17
    OnClick = SearchDataButtonClick
  end
  object TCP: TIdTCPClient
    OnDisconnected = TcpDisconnected
    OnConnected = TcpConnected
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 193
    Top = 328
  end
  object idntfrz1: TIdAntiFreeze
    Left = 233
    Top = 328
  end
  object SQLConnection: TSQLConnection
    Left = 232
    Top = 280
  end
end
