unit Chart;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCLTee.TeEngine, Vcl.ExtCtrls,
  VCLTee.TeeProcs, VCLTee.Chart, Data.DB, Data.SqlExpr, DBXCommon, // TSQLQuery를 위한 유닛
  VCLTee.TeeData, VCLTee.Series;

type
  TFormChart = class(TForm)
    Chart: TChart;
    SQLConnection: TSQLConnection;
    LineSeries: TSeriesDataSet;

    procedure FormCreate(Sender: TObject);

    procedure ConnectToDatabase;
    procedure LoadDataAndShowChart;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormChart: TFormChart;

implementation

{$R *.dfm}
procedure TFormChart.FormCreate(Sender: TObject);
begin
  ConnectToDatabase;
  LoadDataAndShowChart;
end;

procedure TFormChart.ConnectToDatabase;
begin
  SQLConnection := TSQLConnection.Create(nil);
  try
    SQLConnection.DriverName := 'MySQL';
    SQLConnection.GetDriverFunc := 'getSQLDriverMYSQL';
    SQLConnection.LibraryName := 'dbxmys.dll';
    SQLConnection.VendorLib := 'libmysql.dll';
    SQLConnection.Params.Values['HostName']  := 'localhost'; // 데이터베이스 호스트
    SQLConnection.Params.Values['Database']  := 'Clients'; // 데이터베이스 이름
    SQLConnection.Params.Values['User_Name'] := 'root'; // 사용자 이름
    SQLConnection.Params.Values['Password']  := '1234'; // 비밀번호
    SQLConnection.LoginPrompt := False;
    SQLConnection.Connected := True;
  except
    on E: Exception do
      ShowMessage('데이터베이스 연결 실패: ' + E.Message);
  end;
end;

procedure TFormChart.LoadDataAndShowChart;
var
  SQLQuery: TSQLQuery;
  BarSeries: TBarSeries;
begin
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := SQLConnection;

    SQLQuery.SQL.Text := 'SELECT Username, connectCount FROM user ORDER BY connectCount DESC';

    SQLQuery.Open;

    Chart.View3D := False;
    Chart.Legend.Visible := False;
    BarSeries := TBarSeries.Create(Chart);
    Chart.AddSeries(BarSeries);

    while not SQLQuery.Eof do
    begin

      BarSeries.Add(SQLQuery.FieldByName('connectCount').AsInteger, SQLQuery.FieldByName('Username').AsString);
      SQLQuery.Next;
    end;

  finally
    SQLQuery.Free;
  end;
end;



end.
