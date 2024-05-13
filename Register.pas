unit Register;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Data.SqlExpr, Data.DbxMySql,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;

type
  TFormRegister = class(TForm)
    IdRegisterEdit: TEdit;
    PasswordRegisterEdit: TEdit;
    RePasswordRegisterEdit: TEdit;
    IdLabel: TLabel;
    PasswordLabel: TLabel;
    RePasswordLabel: TLabel;
    RegisterButton: TButton;
    ContextLabel: TLabel;
    SQLConnection: TSQLConnection;
    procedure RegisterButtonClick(Sender: TObject);
    procedure ConnectToDatabase;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRegister: TFormRegister;

implementation

{$R *.dfm}
procedure TFormRegister.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Close;
end;

procedure TFormRegister.FormCreate(Sender: TObject);
begin
  ConnectToDatabase;
end;

procedure TFormRegister.ConnectToDatabase;
begin
  SQLConnection := TSQLConnection.Create(nil);
  try
    SQLConnection.DriverName                := 'MySQL';
    SQLConnection.GetDriverFunc             := 'getSQLDriverMYSQL';
    SQLConnection.LibraryName               := 'dbxmys.dll';
    SQLConnection.VendorLib                 := 'libmysql.dll';
    SQLConnection.Params.Values['HostName'] := 'localhost';     // 데이터베이스 호스트
    SQLConnection.Params.Values['Database'] := 'Clients';       // 데이터베이스 이름
    SQLConnection.Params.Values['User_Name']:= 'root';          // 사용자 이름
    SQLConnection.Params.Values['Password'] := '1234';          // 비밀번호
    SQLConnection.LoginPrompt := False;
    SQLConnection.Connected := True;
  except
    on E: Exception do
      ShowMessage('데이터베이스 연결 실패: ' + E.Message);
  end;
end;

procedure TFormRegister.RegisterButtonClick(Sender: TObject);
var
  SQLQuery: TSQLQuery;
  UserExists: Boolean;
begin

  if Length(IdRegisterEdit.Text) > 7 then
  begin
    ShowMessage('Nick Name은 7자로 설정해주세요!');
    Exit;
  end;

  if PasswordRegisterEdit.Text <> RePasswordRegisterEdit.Text then
  begin
    ShowMessage('입력한 비밀번호가 서로 다릅니다.');
    Exit;
  end;

  if MessageDlg('회원가입을 하시겠습니까?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if not SQLConnection.Connected then
    begin
      ShowMessage('데이터베이스에 연결할 수 없습니다.');
      Exit;
    end;

    SQLQuery := TSQLQuery.Create(nil);
    try
      SQLQuery.SQLConnection := SQLConnection;

      SQLQuery.SQL.Text := 'SELECT COUNT(*) FROM user WHERE Username = :Username';
      SQLQuery.Params.ParamByName('Username').AsString := IdRegisterEdit.Text;
      SQLQuery.Open;

      UserExists := SQLQuery.Fields[0].AsInteger > 0;
      SQLQuery.Close;

      if UserExists then
      begin
        ShowMessage('이미 존재하는 아이디입니다.');
        Exit;
      end;

      SQLQuery.SQL.Text := 'INSERT INTO user (Username, Password) VALUES (:Username, :Password)';
      SQLQuery.Params.ParamByName('Username').AsString := IdRegisterEdit.Text;
      SQLQuery.Params.ParamByName('Password').AsString := PasswordRegisterEdit.Text;

      SQLQuery.ExecSQL;

      ShowMessage('회원 가입이 완료되었습니다.');

    except
      on E: Exception do
        ShowMessage('회원 가입 실패: ' + E.Message);
    end;

    SQLQuery.Free;
  end
  else
  begin
    ShowMessage('회원가입이 취소되었습니다.');
  end;
end;




end.
