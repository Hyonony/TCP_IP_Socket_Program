unit Server;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, IdContext, strutils,IdTCPServer,idsockethandle,
  StdCtrls, IdCustomTCPServer, IdBaseComponent, IdComponent, IdStack,
  System.Generics.Collections, DB, Data.DbxMySql,Data.SqlExpr,
  ConversationList, System.SyncObjs, Chart, IdAntiFreezeBase, Vcl.IdAntiFreeze;


type
  TLogger = class
  private
    FWriter: TStreamWriter;
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    procedure Log(const Msg: string);
  end;


type
  TFormServer = class(TForm)

    DisableBtn          : TButton;
    PortNumber          : TEdit;
    EnableBtn           : TButton;
    TCP                 : TIdTCPServer;
    lbl1                : TLabel;
    lbl2                : TLabel;
    lbl3                : TLabel;
    KillClientButton    : TButton;
    IdAntiFreeze1       : TIdAntiFreeze;
    ClientList          : TListBox;
    MsgMemo             : TMemo;
    MessageBox          : TEdit;
    SendMsgButton       : TButton;
    AllSendButton       : TButton;
    ClientsNumBtn       : TButton;
    ClientsChangeEdit   : TEdit;
    NumClients          : TStaticText;
    NumClientsText      : TStaticText;
    SQLConnection       : TSQLConnection;
    SearchDataButton    : TButton;
    ChartButton: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure ConnectToDatabase;
    function GetUserIDByUserName(const UserName: String): Integer;
    function GetUserNameByUserID(const UserID: Integer): String;
    function GetUserIDs(ExcludedUserID : Integer): TList<Integer>;

    procedure SendMessageToDatabase(const SenderID, ReceiveID : Integer; MessageText, MessageType : String);
    function IsOnlineClient(UserID : Integer) : Boolean;

    procedure UpdateBindings;

    procedure TCPConnect(AThread: TIdContext);
    procedure TCPDisconnect(AThread: TIdContext);

    procedure TCPExecute(AThread: TIdContext);

    procedure HandleNickCommand(SenderName: string; AThread: TIdContext);
    procedure HandleEchoCommand(SenderName, MessageText: string);
    procedure HandleBrooCommand(SenderID, ReceiverID: Integer);
    procedure HandleOtherCommands(Stream: string);


    procedure EnableBtnClick(Sender: TObject);
    procedure DisableBtnClick(Sender: TObject);
    procedure KillClientButtonClick(Sender: TObject);
    procedure SendMsgButtonClick(Sender: TObject);
    procedure AllSendButtonClick(Sender: TObject);
    procedure ClientsNumBtnClick(Sender: TObject);
    procedure SearchDataButtonClick(Sender: TObject);
    procedure ChartButtonClick(Sender: TObject);

  private
    IsKillClient : Boolean;
    FLock        : TCriticalSection;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TClientThread = class(TObject)
    IP          : String;
    Index       : Integer;
    Thread      : Pointer;
  end;

var
  FormServer          : TFormServer;
  FormConversation    : TFormConversation;
  FormChart           : TFormChart;
  Clients             : TList;
  Logger              : TLogger;

  DynamicClientsList  : TList<String>;

implementation
{$R *.dfm}

// Server Form 생성자
constructor TFormServer.Create(AOwner: TComponent);
var
  i : Integer;
begin
  inherited Create(AOwner);
  FLock := TCriticalSection.Create;
  DynamicClientsList := TList<String>.Create;

  Clients := TList.Create;
  Logger := TLogger.Create('server.log');

  // 기본 50 자리로 설정
  for i := 1 to 50 do
  begin
    DynamicClientsList.Add('');
  end;

  ConnectToDatabase;
end;

// Server Form 소멸자
destructor TFormServer.Destroy;
begin
  Logger.Free;
  FLock.Free;
  inherited Destroy;
end;

procedure TFormServer.FormCreate(Sender: TObject);
begin
  ClientList.Clear;
  UpdateBindings;
  Logger.Log('===== Program Open =====');
end;

procedure TFormServer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Clients.Free;
  DynamicClientsList.Free;
  TCP.Active:=false;
  Logger.Log('===== Program Exit =====');
end;

// Connect To Database
procedure TFormServer.ConnectToDatabase;
begin
  SQLConnection := TSQLConnection.Create(nil);
  try
    SQLConnection.DriverName                 := 'MySQL';
    SQLConnection.GetDriverFunc              := 'getSQLDriverMYSQL';
    SQLConnection.LibraryName                := 'dbxmys.dll';
    SQLConnection.VendorLib                  := 'libmysql.dll';
    SQLConnection.Params.Values['HostName']  := 'localhost';    // 데이터베이스 호스트
    SQLConnection.Params.Values['Database']  := 'Clients';      // 데이터베이스 이름
    SQLConnection.Params.Values['User_Name'] := 'root';         // 사용자 이름
    SQLConnection.Params.Values['Password']  := '1234';         // 비밀번호
    SQLConnection.LoginPrompt := False;
    SQLConnection.Connected := True;
  except
    on E: Exception do
      ShowMessage('데이터베이스 연결 실패: ' + E.Message);
  end;
end;

// UserName을 통해 UserID 검출
function TFormServer.GetUserIDByUserName(const UserName: String): Integer;
var
  SQLQuery: TSQLQuery;
begin
  Result := -1;

  if not SQLConnection.Connected then Exit;

  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := SQLConnection;
    SQLQuery.SQL.Text := 'SELECT UserID FROM User WHERE Username = :Username';
    SQLQuery.Params.ParamByName('Username').AsString := UserName;
    SQLQuery.Open;

    if not SQLQuery.IsEmpty then
      Result := SQLQuery.Fields[0].AsInteger; // UserID 값을 반환
  finally
    SQLQuery.Free;
  end;
end;

// UserID를 통해 UserName을 검출
function TFormServer.GetUserNameByUserID(const UserID: Integer): String;
var
  SQLQuery: TSQLQuery;
begin
  Result := '';

  if not SQLConnection.Connected then Exit;

  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := SQLConnection;
    SQLQuery.SQL.Text := 'SELECT Username FROM User WHERE UserID = :UserID';
    SQLQuery.Params.ParamByName('UserID').AsInteger := UserID;
    SQLQuery.Open;

    if not SQLQuery.IsEmpty then
      Result := SQLQuery.Fields[0].AsString; // UserID 값을 반환
  finally
    SQLQuery.Free;
  end;
end;

// 모든 UserID를 찾아주는 함수 (전체 톡 보내기 기능을 사용하기 위해 사용 됌.)
function TFormServer.GetUserIDs(ExcludedUserID : Integer): TList<Integer>;
var
  SQLQuery: TSQLQuery;
  UserIDList: TList<Integer>;
begin
  UserIDList := TList<Integer>.Create;

  if not SQLConnection.Connected then Exit;

  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := SQLConnection;
    SQLQuery.SQL.Text := 'SELECT UserID FROM user WHERE UserID <> :ExcludedUserID';
    SQLQuery.Params.ParamByName('ExcludedUserID').AsInteger := ExcludedUserID;
    SQLQuery.Open;

    while not SQLQuery.Eof do
    begin
      UserIDList.Add(SQLQuery.FieldByName('UserID').AsInteger);
      SQLQuery.Next;
    end;
  finally
    SQLQuery.Free;
  end;
  Result := UserIDList;
end;

// DataBase에 메시지를 저장할 수 있는 기능
procedure TFormServer.SendMessageToDatabase(const SenderID, ReceiveID : Integer; MessageText, MessageType : String);
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

    SQLQuery.SQL.Text := 'INSERT INTO Message(SenderID, ReceiveID, MessageText, MessageType, SendTime) '+
                         'VALUES (:SenderID, :ReceiveID, :MessageText, :MessageType, now());';

    SQLQuery.Params.ParamByName('SenderID').AsInteger     := SenderID;
    SQLQuery.Params.ParamByName('ReceiveID').AsInteger    := ReceiveID;
    SQLQuery.Params.ParamByName('MessageText').AsString   := MessageText;
    SQLQuery.Params.ParamByName('MessageType').AsString   := MessageType;

    SQLQuery.ExecSQL;
  finally
    SQLQuery.Free;
  end;
end;

// Online만 Echo 기능에 부합하는 메서드 (전에는 접속하지 않아도 db를 통해 전달이 됐었음.)
function TFormServer.IsOnlineClient(UserID : Integer) : Boolean;
var
  Query: TSQLQuery;
begin
  Result := False;
  Query := TSQLQuery.Create(nil);
  try
    Query.SQLConnection := SQLConnection;
    Query.SQL.Text := 'SELECT IsOnline FROM user WHERE UserID = :UserID';
    Query.ParamByName('UserID').AsInteger := UserID;
    Query.Open;

    // Delphi와 MySQL 간의 Boolean 타입 직접 매핑이 지원되지 않음
    if not Query.IsEmpty then
      Result := Query.FieldByName('IsOnline').AsInteger = 1;

  finally
    Query.Free;
  end;
end;


// TCP Binding 설정
procedure TFormServer.UpdateBindings;
var Binding : TIdSocketHandle;
begin
  TCP.DefaultPort := StrToInt(PortNumber.Text);
  TCP.Bindings.Clear;

  Binding      := TCP.Bindings.Add;
  Binding.Port := TCP.DefaultPort;
end;


// TCP Connect
procedure TFormServer.TCPConnect(AThread: TIdContext);
var
  Client : TClientThread;
begin
  FLock.Enter;
  try
    Client := TClientThread.Create;
    try
      Client.IP     := AThread.Connection.Socket.Binding.PeerIP;
      Client.Index  := ClientList.Count;
      Client.Thread := AThread;
      AThread.Data  := Client;
      Clients.Add(Client);
      ClientList.Items.Add(Client.IP + ' ' + IntToStr(ClientList.Count));


      Logger.Log('클라이언트 연결됨: ' + Client.IP );
    except
      on E: Exception do
      begin
        Client.Free;
        ShowMessage('클라이언트 연결 처리 중 에러 발생: ' + E.Message);
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

// TCP Disconnect
procedure TFormServer.TCPDisconnect(AThread: TIdContext);
var
  Client: TClientThread;
  IndexInClientList, i: Integer;
  IPAndIndex: String;
begin
  FLock.Enter;
  try
    Client := Pointer(AThread.Data);
    Client.IP := AThread.Connection.Socket.Binding.PeerIP;

    Logger.Log('클라이언트 연결 해제됨: ' + Client.IP);

    IndexInClientList := -1;
    for i := 0 to ClientList.Items.Count - 1 do
    begin
      IPAndIndex := ClientList.Items[i];
      if Pos(Client.IP, IPAndIndex) = 1 then
      begin
        IndexInClientList := i;
        Break;
      end;
    end;

    if IndexInClientList > -1 then
    begin
      ClientList.Items.Delete(IndexInClientList);
      Clients.Delete(IndexInClientList);
      DynamicClientsList.Delete(IndexInClientList);

      for i := IndexInClientList to Clients.Count - 1 do
      begin
        TClientThread(Clients[i]).Index := TClientThread(Clients[i]).Index - 1;
      end;
    end

    else if IsKillClient then
    begin
      IndexInClientList := ClientList.Items.IndexOf(DynamicClientsList[Client.index]);

      if IndexInClientList > -1 then
      begin
        ClientList.Items.Delete(IndexInClientList);
        Clients.Delete(IndexInClientList);
        DynamicClientsList.Delete(IndexInClientList);

        for i := IndexInClientList to Clients.Count - 1 do
        begin
          TClientThread(Clients[i]).Index := TClientThread(Clients[i]).Index - 1;
        end;
      end;

      IsKillClient := False;
    end

    else if ClientList.Items.IndexOf(DynamicClientsList[Client.index]) > -1 then
    begin
      IndexInClientList := ClientList.Items.IndexOf(DynamicClientsList[Client.index]);
      ClientList.Items.Delete(IndexInClientList);
      Clients.Delete(IndexInClientList);
      DynamicClientsList.Delete(IndexInClientList);

      for i := IndexInClientList to Clients.Count - 1 do
      begin
        TClientThread(Clients[i]).Index := TClientThread(Clients[i]).Index - 1;
      end;
    end;

    i := Clients.IndexOf(Client);
    if i > -1 then
      Clients.Delete(i);

    Client.Free;
    AThread.Data := nil;
  finally
    FLock.Leave;
  end;
end;

// 데이터 수신 이벤트 처리 메서드
procedure TFormServer.TCPExecute(AThread: TIdContext);
var
  Stream, Command, SenderName, MessageText, ReceiverName, TempString: string;
begin
  Stream := AThread.Connection.IOHandler.ReadLn;
  Command := Copy(Stream, 1, Pos(':', Stream));
  try
    // Nickname 중복 검사 기능
    if Command = 'nick:' then
    begin
      SenderName := Copy(Stream, Pos(':', Stream) + 2, MaxInt);

      HandleNickCommand(SenderName, AThread);
    end

    // 현재 접속한 클라이언트 리스트 불러오기
    else if Command ='list:' then
      begin
        ClientList.Items.Delimiter := ':';
        AThread.Connection.IOHandler.WriteLn('list:' + ClientList.Items.DelimitedText);
      end

    //전체 메시지 핸들러
    else if Command = 'echo:' then
      begin
        TempString  := Copy(Stream, Length('echo::') + 1, MaxInt);
        SenderName  := Copy(TempString, 1, Pos(':', TempString) - 1);
        MessageText := Copy(TempString, Pos(':', TempString) + 1, MaxInt);

        HandleEchoCommand(SenderName, MessageText);
      end

    // 친구 추가 핸들러
    else if Command = 'broo:' then
      begin
        TempString    := Copy(Stream, Length('broo::') + 1, MaxInt);
        SenderName    := Copy(TempString, 1, Pos(':', TempString) - 1);
        ReceiverName  := Copy(TempString, Pos(':', TempString) + 1, MaxInt);

        HandleBrooCommand(StrToInt(SenderName), StrToInt(ReceiverName));
      end

    else if Command = 'whis:' then
    begin
      HandleOtherCommands(Stream);
    end;
  except
    on E: Exception do
      ShowMessage('Error : ' + E.Message);
  end;
  

  // 개인 메시지 핸들러
  
  end;


// 클라이언트 서버 연결 시 닉네임 검사 이벤트 핸들러
procedure TFormServer.HandleNickCommand(SenderName: string; AThread: TIdContext);
var
  Client : TClientThread;
begin
  FLock.Enter;
  try
    DynamicClientsList.Count := StrToInt(NumClientsText.Caption);
    if (ClientList.Items.IndexOf(SenderName) < 0) then
    begin
      if DynamicClientsList.Count < ClientList.Count then
        begin
          Client := Clients.Items[ClientList.Count-1];
          TIdContext(Client.Thread).Connection.IOHandler.WriteLn('Limit Exceeded');
          TIdContext(Client.Thread).Connection.Disconnect;

          FormServer.MsgMemo.Lines.Add('<  Connect to error : Server Exceeded  >');
          Logger.Log('<  Client Connect Error : Limit Exceeded  >' + 'name : ' + SenderName);
        end

      else
        begin
          ClientList.Items.Strings[ClientList.Count-1] := SenderName;
          DynamicClientsList[ClientList.Count-1] := SenderName;
          FormServer.MsgMemo.Lines.Add('<  Connect to Success  >' + 'name : ' + SenderName);
          Logger.Log(('<  Connect to Success  >' + 'name : ' + SenderName));
        end;

    end
    else
    begin
      Client := Clients.Items[ClientList.Count-1];
      TIdContext(Client.Thread).Connection.IOHandler.WriteLn('Someone is already using ID' + 'name : ' + SenderName);
      TIdContext(Client.Thread).Connection.Disconnect;
      Logger.Log(('<  Client Connect Error : Someone is already using ID >' + 'name : ' + SenderName));
    end;
  finally
    FLock.Leave;
  end;

end;

// 전체 메시지 송수신 이벤트 핸들러
procedure TFormServer.HandleEchoCommand(SenderName, MessageText: string);
var
  SenderID, UserID: Integer;
  i: Integer;
  AllUserIDs: TList<Integer>;
  Client : TClientThread;
begin
  SenderID := FormServer.GetUserIDByUserName(SenderName); // 공유 자원 접근 전

  FLock.Enter; // 공유 자원 접근 시작
  try
    AllUserIDs := FormServer.GetUserIDs(SenderID);
    try
      for i := 0 to AllUserIDs.Count - 1 do
      begin
        UserID := AllUserIDs[i];
        if (UserID <> SenderID) and IsOnlineClient(UserID) then
        begin
          SendMessageToDatabase(SenderID, UserID, MessageText, 'Echo');
        end
      end;
    finally
      AllUserIDs.Free;
    end;
  finally
    FLock.Leave; // 공유 자원 접근 끝
  end;

  FLock.Enter; // Clients 리스트 접근 시작
  try
    for i := 0 to Clients.Count - 1 do
    begin
      Client := Clients.Items[i];
      if Assigned(Client) and Assigned(Client.Thread) and Assigned(TIdContext(Client.Thread).Connection) then
        TIdContext(Client.Thread).Connection.IOHandler.WriteLn(SenderName + ' : ' + MessageText);
    end;
  finally
    FLock.Leave; // Clients 리스트 접근 끝
  end;

  Logger.Log(SenderName + ' >> ' + '전체' + ' : '+ MessageText);
  FormServer.MsgMemo.Lines.Add('<Echo>' + '     Client :  ' + SenderName + ' : ' + MessageText);
end;



// 친구 등록 이벤트 핸들러
procedure TFormServer.HandleBrooCommand(SenderID, ReceiverID: Integer);
var
  Client   : TClientThread;
  UserName : string;
begin
  FLock.Enter;
  try
    UserName := GetUserNameByUserID(ReceiverID);
    ClientList.Selected[ClientList.Items.IndexOf(UserName)] := true;
    Client := Clients.Items[ClientList.ItemIndex];

    TIdContext(Client.Thread).Connection.IOHandler.WriteLn('Reqs::' + IntToStr(SenderID) + ':' + IntToStr(ReceiverID));

    FormServer.MsgMemo.Lines.Add(IntToStr(SenderID) + ' >> ' + IntToStr(ReceiverID) + ' -- 친구 추가 진행 중 --');
    Logger.Log('<Client is making a friend> Send Name: ' + IntToStr(SenderID) + ' Receive Name: ' + IntToStr(ReceiverID));
  finally
    FLock.Leave;
  end;

end;


// 개인 메시지 송수신 이벤트 핸들러
procedure TFormServer.HandleOtherCommands(Stream: string);
var
  RsvName, SendName, Message, SeparatorPos: string;
  SenderID,ReceiverID : Integer;
  Client  : TClientThread;
begin
  FLock.Enter;
  try
    Stream := Copy(Stream, 7, MaxInt);

    RsvName := Copy(Stream, 1, Pos('>', Stream) - 1);
    Stream := Copy(Stream, Pos('>', Stream) + 1, MaxInt);
    SendName := Copy(Stream, 1,  Pos(':', Stream) - 1);
    Message := Copy(Stream,  Pos(':', Stream) + 1, MaxInt);

    if ClientList.Items.IndexOf(RsvName) <> -1 then
    begin
      ClientList.Selected[ClientList.Items.IndexOf(RsvName)] := True;
      Client := Clients.Items[ClientList.ItemIndex];
      TIdContext(Client.Thread).Connection.IOHandler.WriteLn(SendName + ' : ' + Message);
    end;

    FormServer.MsgMemo.Lines.Add('<Whisper>' + 'Client :  ' + SendName + ' : ' + Message);
    Logger.Log(SendName + ' >> ' + RsvName + ' : '+ Message);

    SenderID   := FormServer.GetUserIDByUserName(SendName);
    ReceiverID := FormServer.GetUserIDByUserName(RsvName);

    if SenderID <> -1 then
    begin
      SendMessageToDatabase(SenderID, ReceiverID, Message, 'Whisper');
    end;
  finally
    FLock.Leave;
  end;

end;


// 데이터 검사 Form 생성
procedure TFormServer.SearchDataButtonClick(Sender: TObject);
begin
  FormConversation := TFormConversation.Create(Application);

  FormConversation.ShowModal;
end;

//접속자 수 차트
procedure TFormServer.ChartButtonClick(Sender: TObject);
begin
  FormChart := TFormChart.Create(Application);

  FormChart.ShowModal;
end;

// 클라이언트 리스트 숫자 변경 버튼
procedure TFormServer.ClientsNumBtnClick(Sender: TObject);
var
  NewSize: Integer;
begin
  if StrToInt(ClientsChangeEdit.Text) < ClientList.Count then
  begin
    ShowMessage('현재 대기실에 사람이 있습니다. 강퇴를 먼저 진행해주세요.');
  end
  else
  begin
    NewSize := StrToInt(ClientsChangeEdit.Text);

    while DynamicClientsList.Count < NewSize do
      DynamicClientsList.Add('');
    while DynamicClientsList.Count > NewSize do
      DynamicClientsList.Delete(DynamicClientsList.Count - 1);

    NumClientsText.Caption := IntToStr(DynamicClientsList.Count);

    ShowMessage('변경 완료!');
    Logger.Log('Clients list updated. New size: ' + IntToStr(NewSize));
  end;
end;

// 서버 Open 버튼
procedure TFormServer.EnableBtnClick(Sender: TObject);
begin
  try
    TCP.Active            := True;

    EnableBtn.Enabled     := False;
    DisableBtn.Enabled    := True;
    KillClientButton.Enabled := True;
    SendMsgButton.Enabled := True;
    AllSendButton.Enabled := True;
    Logger.Log('===== Server Open =====' + #10#10 +'IP : '+ '======' + GStack.LocalAddress + '======' + #10 +'Port : ' + '======' + PortNumber.Text + '======' + #10#10);
  except
    on E: Exception do
      ShowMessage('서버 시작 에러: ' + E.Message);
  end;
end;
// 서버 Close 버튼
procedure TFormServer.DisableBtnClick(Sender:TObject);
begin
  TCP.Active := False; // 서버 비활성화
  ShowMessage('서버가 중지되었습니다.');

  EnableBtn.Enabled     := True; // Enable 버튼 활성화
  DisableBtn.Enabled    := False; // Disable 버튼 비활성화
  KillClientButton.Enabled := False;
  SendMsgButton.Enabled := False;
  AllSendButton.Enabled := False;
  Logger.Log('===== Server Closed =====' + #10#10);
end;

// 서버에서 클라이언트 개인에게 보내는 버튼
procedure TFormServer.SendMsgButtonClick(Sender: TObject);
var  Client : TClientThread;
begin
  if ClientList.ItemIndex < 0 then Exit;

  Client := Clients.Items[ClientList.ItemIndex];

  TIdContext(Client.Thread).Connection.IOHandler.WriteLn('Server :' + MessageBox.Text);
  FormServer.MsgMemo.Lines.Add(MessageBox.Text);

  Logger.Log('서버: 메시지 송신: ' + MessageBox.Text);
end;


// 서버에서 클라이언트 전체에게 보내는 버튼
procedure TFormServer.AllSendButtonClick(Sender: TObject);
var  Client : TClientThread; i: Integer;
begin
  for i := 0 to Clients.Count - 1 do
  begin
    Client := Clients.Items[i];
    TIdContext(Client.Thread).Connection.IOHandler.WriteLn('Server :' + MessageBox.Text);
    FormServer.MsgMemo.Lines.Add(MessageBox.Text);

    Logger.Log('서버 : 모든 클라이언트에 메시지 송신: ' + MessageBox.Text);
  end;
end;


// 특정 클라이언트 강퇴 버튼
procedure TFormServer.KillClientButtonClick(Sender: TObject);
var
  Client   : TClientThread;
begin
  if ClientList.ItemIndex < 0 then exit;

  IsKillClient := True;
  Client       := Clients.Items[ClientList.itemIndex];
  Logger.Log(ClientList.Items.Strings[ClientList.ItemIndex] + '클라이언트 강퇴 당함. ');
  TIdContext(Client.Thread).Connection.IOHandler.WriteLn('kill:' + 'The server kicked you');
  TIdContext(Client.Thread).Connection.Disconnect;
end;

// Log 생성
constructor TLogger.Create(const FileName: string);
begin
  inherited Create;
  FWriter := TStreamWriter.Create(FileName, True);
end;

// Log 소멸
destructor TLogger.Destroy;
begin
  FWriter.Free;
  inherited;
end;

// Log 작성 기능
procedure TLogger.Log(const Msg: string);
begin
  FWriter.WriteLine(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - ' + Msg);
  FWriter.Flush;
end;



end.

