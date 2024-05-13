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
    SQLConnection.Params.Values['HostName'] := 'localhost';     // �����ͺ��̽� ȣ��Ʈ
    SQLConnection.Params.Values['Database'] := 'Clients';       // �����ͺ��̽� �̸�
    SQLConnection.Params.Values['User_Name']:= 'root';          // ����� �̸�
    SQLConnection.Params.Values['Password'] := '1234';          // ��й�ȣ
    SQLConnection.LoginPrompt := False;
    SQLConnection.Connected := True;
  except
    on E: Exception do
      ShowMessage('�����ͺ��̽� ���� ����: ' + E.Message);
  end;
end;

procedure TFormRegister.RegisterButtonClick(Sender: TObject);
var
  SQLQuery: TSQLQuery;
  UserExists: Boolean;
begin

  if Length(IdRegisterEdit.Text) > 7 then
  begin
    ShowMessage('Nick Name�� 7�ڷ� �������ּ���!');
    Exit;
  end;

  if PasswordRegisterEdit.Text <> RePasswordRegisterEdit.Text then
  begin
    ShowMessage('�Է��� ��й�ȣ�� ���� �ٸ��ϴ�.');
    Exit;
  end;

  if MessageDlg('ȸ�������� �Ͻðڽ��ϱ�?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if not SQLConnection.Connected then
    begin
      ShowMessage('�����ͺ��̽��� ������ �� �����ϴ�.');
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
        ShowMessage('�̹� �����ϴ� ���̵��Դϴ�.');
        Exit;
      end;

      SQLQuery.SQL.Text := 'INSERT INTO user (Username, Password) VALUES (:Username, :Password)';
      SQLQuery.Params.ParamByName('Username').AsString := IdRegisterEdit.Text;
      SQLQuery.Params.ParamByName('Password').AsString := PasswordRegisterEdit.Text;

      SQLQuery.ExecSQL;

      ShowMessage('ȸ�� ������ �Ϸ�Ǿ����ϴ�.');

    except
      on E: Exception do
        ShowMessage('ȸ�� ���� ����: ' + E.Message);
    end;

    SQLQuery.Free;
  end
  else
  begin
    ShowMessage('ȸ�������� ��ҵǾ����ϴ�.');
  end;
end;




end.
