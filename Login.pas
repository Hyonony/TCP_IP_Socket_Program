unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DB, Data.DbxMySql,Data.SqlExpr;

type
  TFormLogin = class(TForm)
    IdBox: TEdit;
    PasswordBox: TEdit;
    ID: TStaticText;
    Password: TStaticText;
    LoginButton: TButton;
    TCancelButton: TButton;
    SQLConnection: TSQLConnection;

    procedure LoginButtonClick(Sender: TObject);
    procedure TCancelButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    // DB connect
    procedure ConnectToDatabase;
     //ID Password
    procedure CheckIdPassword(const UserName, Password : String);
    procedure FormCreate(Sender: TObject);


  public
    LoginOK : Boolean;
  end;

var
  FormLogin: TFormLogin;


implementation

{$R *.dfm}

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  ConnectToDatabase;
  LoginOK := False;
end;


procedure TFormLogin.ConnectToDatabase;
begin
  SQLConnection := TSQLConnection.Create(nil);
  try
    SQLConnection.DriverName := 'MySQL';
    SQLConnection.GetDriverFunc := 'getSQLDriverMYSQL';
    SQLConnection.LibraryName := 'dbxmys.dll';
    SQLConnection.VendorLib := 'libmysql.dll';
    SQLConnection.Params.Values['HostName'] := 'localhost'; // 데이터베이스 호스트
    SQLConnection.Params.Values['Database'] := 'Clients'; // 데이터베이스 이름
    SQLConnection.Params.Values['User_Name'] := 'root'; // 사용자 이름
    SQLConnection.Params.Values['Password'] := '1234'; // 비밀번호
    SQLConnection.LoginPrompt := False;
    SQLConnection.Connected := True;
  except
    on E: Exception do
      ShowMessage('데이터베이스 연결 실패: ' + E.Message);
  end;
end;

procedure TFormLogin.CheckIdPassword(const UserName, Password : String);
var
  SQLQuery: TSQLQuery;
begin
  if not SQLConnection.Connected then
  begin
    ShowMessage('데이터베이스에 연결되어 있지 않습니다.');
    Exit;
  end;

  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := SQLConnection;

    SQLQuery.SQL.Text := 'SELECT * FROM User WHERE UserName = :UserName AND Password = :Password;';

    SQLQuery.ParamByName('UserName').AsString := UserName;
    SQLQuery.ParamByName('Password').AsString := Password;

    SQLQuery.Open;
    if not SQLQuery.IsEmpty then
    begin
      LoginOK := True;
    end
    else
    begin
      LoginOK := False;
      ShowMessage('사용자 이름 또는 비밀번호가 잘못되었습니다.');
    end;

  finally
    SQLQuery.Free;
  end;
end;


procedure TFormLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormLogin.LoginButtonClick(Sender: TObject);
begin
  CheckIdPassword(IdBox.Text, PasswordBox.Text);

  if LoginOK = True then
  begin
    Close;
  end
  else
  begin
    ShowMessage('로그인 실패 ! 다시 로그인 해주세요 !');
  end;
end;

procedure TFormLogin.TCancelButtonClick(Sender: TObject);
begin
  LoginOK := False;

  Close;
end;



end.
