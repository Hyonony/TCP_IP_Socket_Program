program TCPserver;

uses
  Vcl.Forms,
  Server in 'Server.pas' {FormServer},
  ConversationList in 'ConversationList.pas' {FormConversation},
  Chart in 'Chart.pas' {FormChart};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormServer, FormServer);
  Application.CreateForm(TFormConversation, FormConversation);
  Application.CreateForm(TFormChart, FormChart);
  Application.Run;
end.
