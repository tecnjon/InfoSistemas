unit UFormCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient, Vcl.Buttons,
  Vcl.ExtCtrls, Data.DB, REST.Response.Adapter, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, Vcl.StdCtrls, IdMessage, IdBaseComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP;

type
  TForm5 = class(TForm)
    edtCep: TLabeledEdit;
    edtLogradouro: TLabeledEdit;
    edtComplemento: TLabeledEdit;
    Client: TRESTClient;
    Request: TRESTRequest;
    Response: TRESTResponse;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    edtBairro: TLabeledEdit;
    edtLocalidade: TLabeledEdit;
    cbUF: TComboBox;
    Label1: TLabel;
    edtNome: TLabeledEdit;
    edtCPF: TLabeledEdit;
    edtRG: TLabeledEdit;
    edtTelefone: TLabeledEdit;
    edtemail: TLabeledEdit;
    edtNumero: TLabeledEdit;
    smtp: TIdSMTP;
    idMessage: TIdMessage;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    edtPais: TLabeledEdit;
    procedure edtCepEnter(Sender: TObject);
    procedure edtCepExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure edtCepKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    function getNumber(const str : String) : String;
    function formataCEP(const str : String): String;
    function formataCPFCNPJ(const  str : string): string;
    function formataTelefone(str:string): string;
    procedure EnviarEmail(const str : String);
    procedure pesquisarCEP;
    { Private declarations }
  public
    { Public declarations }
  end;
const
  BaseURL = 'https://viacep.com.br/ws/';

var
  Form5: TForm5;

implementation
  uses
    System.MaskUtils, JSON, XMLDoc, XMLIntf, IdAttachmentFile ;

function TForm5.FormataCPFCNPJ(const str: string): string;
const
  MascaraCPF: string = '000\.000\.000\-00;0;_';
  MascaraCNPJ: string = '00\.000\.000\/0000\-00;0;_';
begin

  if str.IsEmpty then Exit;

  Result := getNumber(str);

  case Length(Result) of
    09: Result := FormatMaskText(MascaraCPF, '00' + Result);
    10: Result := FormatMaskText(MascaraCPF, '0' + Result);
    11: Result := FormatMaskText(MascaraCPF, Result);
    14: Result := FormatMaskText(MascaraCNPJ, Result);
  else
    Exit;
  end;
end;

function TForm5.formataTelefone(str : string): string;
const
  MascaraTelDDD9  : string   = '(00) 00000-0000;0;_';
  MascaraTel9     : string  =      '00000-0000;0;_';
  MascaraTelDDD   : string   = '(00) 0000-0000;0;_';
  MascaraTel      : string   =      '0000-0000;0;_';
begin

 if str.IsEmpty then exit;

  if str[1] = '0' then
    str := copy(str, 2, length(str));

  Result := str;
  Result := getNumber(Result);

  case Length(str) of
    08 : Result := FormatMaskText(MascaraTel     , Result);
    09 : Result := FormatMaskText(MascaraTel9    , Result);
    10 : Result := FormatMaskText(MascaraTelDDD  , Result);
    11 : Result := FormatMaskText(MascaraTelDDD9 , Result);
  else
    Exit;
  end;
end;

function TForm5.formataCEP(const str : String): String;
const
  MascaraCEP  : string   = '00.000-000;0;_';
begin
  if str.IsEmpty then exit;

  Result := FormatMaskText(MascaraCEP, getNumber(str));
end;

procedure TForm5.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_RETURN then
  SelectNext(ActiveControl, True, False);
end;

procedure TForm5.FormShow(Sender: TObject);
begin
  Client.BaseURL := BaseURL;
end;

{$R *.dfm}

procedure TForm5.edtCepExit(Sender: TObject);

begin
  if Sender = edtCep then
  begin

    TLabeledEdit(Sender).Text := formataCEP(  TLabeledEdit(Sender).Text);

    pesquisarCEP;

  end else if Sender = edtCPF then
    TLabeledEdit(Sender).Text := formataCPFCNPJ(TLabeledEdit(Sender).Text)
  else if Sender = edtTelefone then
    TLabeledEdit(Sender).Text := FormataTelefone(TLabeledEdit(Sender).Text);

end;

procedure TForm5.edtCepKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_RETURN then pesquisarCEP;

end;

procedure TForm5.EnviarEmail(const str: String);
var
  XML: TXMLDocument;
  NodeT, NodeR, NdEndereco: IXMLNode;
  I: Integer;
  Att : TIdAttachmentFile;
  sPathXML: string;

begin

  if str.IsEmpty then
    raise Exception.Create('Nenhum email foi informado.');

  if not MessageDlg('Deseja realmente enviar o email?',mtConfirmation,[mbYes,mbNo],0) = mrNo then Exit;


  smtp.Host     := 'smtp.gmail.com';
  smtp.Port     := 465;
  smtp.Username := 'esolucaonnf';
  smtp.Password := '85534736';
//  smtp.AuthType := atLogin;
  idMessage.MessageParts.Clear;
  idMessage.From.Address := 'alvarinda2013@gmail.com';
  idMessage.Subject      := 'Cadastro';
  idMessage.Body.Text    := 'Dados cadastrais';
  idMessage.ContentType:='text/html';
  idMessage.CharSet := 'utf-8';
  idMessage.Encoding := meMIME;

  idMessage.Body.Add('Segue informações cadastrais.');
  idMessage.Body.Add('Nome: '       + edtNome.Text);
  idMessage.Body.Add('Identidade: ' + edtTelefone.Text);
  idMessage.Body.Add('CPF: '        + edtTelefone.Text);
  idMessage.Body.Add('Email: '      + edtTelefone.Text);
  idMessage.Body.Add('***** Endereço ******');
  idMessage.Body.Add('CEP: '         + edtCep.Text);
  idMessage.Body.Add('Logradouro: '  + edtLogradouro.Text);
  idMessage.Body.Add('Numero: '      + edtNumero.Text);
  idMessage.Body.Add('Complemento: ' + edtComplemento.Text);
  idMessage.Body.Add('Bairro: '      + edtBairro.Text);
  idMessage.Body.Add('Cidade: '      + edtLocalidade.Text);
  idMessage.Body.Add('Estado: '      + cbUf.Text);
  idMessage.Body.Add('Pais: '        + edtPais.Text);

  idMessage.Recipients.EMailAddresses := str;
  idMessage.ContentType := 'multipart/mixed';

  try
    try
      XML := TXMLDocument.Create(Self);

      XML.Active := True;
      NodeT := XML.AddChild('Cadastro');
      NodeT.ChildValues['Nome']       := edtNome.Text;
      NodeT.ChildValues['Identidade'] := edtRG.Text;
      NodeT.ChildValues['CPF']        := getNumber(edtCPF.Text);
      NodeT.ChildValues['Telefone']   := getNumber(edtTelefone.Text);
      NodeT.ChildValues['Email']      := edtEmail.Text;

      NdEndereco := NodeT.AddChild('Endereco');
      NdEndereco.ChildValues['Cep']         := getNumber(edtCep.Text);
      NdEndereco.ChildValues['Logradouro']  := edtLogradouro.Text;
      NdEndereco.ChildValues['Numero']      := edtNumero.Text;
      NdEndereco.ChildValues['Complemento'] := edtComplemento.Text;
      NdEndereco.ChildValues['Bairro']      := edtBairro.Text;
      NdEndereco.ChildValues['Cidade']      := edtLocalidade.Text;
      NdEndereco.ChildValues['UF']          := cbUf.Text;
      NdEndereco.ChildValues['Pais']        := edtPais.Text;

      sPathXML := ExtractFilePath(paramStr(0));

      XML.SaveToFile(sPathXML + 'cadastro.xml');

      if FileExists(sPathXML + 'cadastro.xml') then
        Att := TIdAttachmentFile.Create(idMessage.MessageParts, sPathXML + 'cadastro.xml');

      smtp.Connect;
      smtp.Send(idMessage);

      ShowMessage('Email enviado com sucesso');

    except
      on e: exception do
        raise Exception.Create(e.Message);

    end;
  finally
  smtp.Disconnect(False);

  end;


end;

function TForm5.getNumber(const str: String): String;
var
  I: Integer;
begin
  Result := EmptyStr;
  for I := 1 to Length(str) do
    if CharInSet(str[I],['0'..'9']) then
      Result := Result + str[I];
end;

procedure TForm5.pesquisarCEP;
var
  jo : TJsonObject;
begin
  if Trim(edtLogradouro.Text).IsEmpty
  and not(Trim(edtCep.Text).IsEmpty)
  then
  begin
    try
      try
        Request.Resource := getNumber(edtCep.Text)
                            + '/json';
        Request.Execute;

        JO := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Response.Content),0) as TJsonObject;
        edtLogradouro.Text := jo.GetValue<string>('logradouro');
        edtComplemento.Text := jo.GetValue<string>('complemento');
        edtBairro.Text := jo.GetValue<string>('bairro');
        edtLocalidade.Text := jo.GetValue<string>('localidade');
        cbuf.ItemIndex := cbUf.Items.IndexOF(jo.GetValue<string>('uf'));
      except
        on e: exception do
          ShowMessage('Aconteceu algo de errado ao pesquisar o cep informado.');
      end;
    finally
      FreeAndNil(JO);
    end;

  end;
end;

procedure TForm5.SpeedButton1Click(Sender: TObject);
begin
  EnviarEmail(EdtEmail.Text);
end;

procedure TForm5.edtCepEnter(Sender: TObject);
begin
  TLabeledEdit(Sender).Text := getNumber(TLabeledEdit(Sender).Text)
end;

end.
