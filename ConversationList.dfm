object FormConversation: TFormConversation
  Left = 0
  Top = 0
  Align = alCustom
  Caption = 'FormConversation'
  ClientHeight = 390
  ClientWidth = 726
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
  object ClientList: TListBox
    Left = 8
    Top = 48
    Width = 121
    Height = 305
    ItemHeight = 13
    TabOrder = 0
  end
  object ClientListText: TStaticText
    Left = 8
    Top = 25
    Width = 102
    Height = 20
    Caption = '   Client'#39's List   '
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
  end
  object EchoSearchButton: TButton
    Left = 152
    Top = 19
    Width = 90
    Height = 25
    Caption = #50640#53076' '#45824#54868' '#44160#49353
    TabOrder = 2
    OnClick = EchoSearchButtonClick
  end
  object WhisperSearchButton: TButton
    Left = 307
    Top = 19
    Width = 90
    Height = 25
    Caption = #44499#49549#47568' '#44160#49353
    TabOrder = 3
    OnClick = WhisperSearchButtonClick
  end
  object Tdbgrd: TDBGrid
    Left = 152
    Top = 48
    Width = 566
    Height = 303
    Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object FriendSearchButton: TButton
    Left = 470
    Top = 19
    Width = 90
    Height = 25
    Caption = #52828#44396' '#45824#54868' '#44160#49353
    TabOrder = 5
    OnClick = FriendSearchButtonClick
  end
  object AllSearchButton: TButton
    Left = 628
    Top = 19
    Width = 90
    Height = 25
    Caption = #51204#52404' '#45824#54868' '#44160#49353
    TabOrder = 6
    OnClick = AllSearchButtonClick
  end
  object SQLConnection: TSQLConnection
    LibraryName = 'dbxmys.dll'
    VendorLib = 'libmysql.dll'
    Left = 72
    Top = 296
  end
  object Tdtstprvdr: TDataSetProvider
    Left = 168
    Top = 296
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 232
    Top = 296
  end
end
