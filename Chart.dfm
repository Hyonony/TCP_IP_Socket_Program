object FormChart: TFormChart
  Left = 0
  Top = 0
  Caption = 'FormChart'
  ClientHeight = 420
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Chart: TChart
    Left = 8
    Top = 8
    Width = 535
    Height = 404
    Title.Font.Color = clRed
    Title.Font.Height = -16
    Title.Font.Name = 'Bahnschrift Light'
    Title.Font.Style = [fsBold, fsItalic]
    Title.Font.Shadow.Color = 11184810
    Title.Text.Strings = (
      #53364#46972#51060#50616#53944#51032' '#51217#49549' '#49688)
    BottomAxis.Title.Caption = #51217#49549#51088
    LeftAxis.Title.Angle = 0
    LeftAxis.Title.Caption = #51217#49549#49688
    TabOrder = 0
    ColorPaletteIndex = 13
  end
  object SQLConnection: TSQLConnection
    LibraryName = 'dbxmys.dll'
    VendorLib = 'libmysql.dll'
    Left = 104
    Top = 296
  end
  object LineSeries: TSeriesDataSet
    Left = 152
    Top = 296
  end
end
