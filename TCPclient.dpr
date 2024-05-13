program TCPclient;

uses
  Vcl.Forms,
  Client in 'Client.pas' {FormClient},
  FriendRequest in 'FriendRequest.pas' {FormFriendRequest},
  Register in 'Register.pas' {FormRegister},
  Conversation in 'Conversation.pas' {FormConversation};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormClient, FormClient);
  Application.CreateForm(TFormFriendRequest, FormFriendRequest);
  Application.CreateForm(TFormRegister, FormRegister);
  Application.CreateForm(TFormConversation, FormConversation);
  Application.Run;
end.
